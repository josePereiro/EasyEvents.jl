let

    @info("Testing FileMTimeEvent")
    e = FileMTimeEvent()
    file = joinpath(tempdir(), "FileMTimeEvent.test")
    touch(file)
    update!(e ,file)

    events_count = 0
    trigger_at = [3, 4, 5]
    for it in 1:10
        if pull_event!(e ,file)
            println(basename(file), " changed!!!")
            events_count += 1
        end

        if it in trigger_at
            touch(file)
        end
        sleep(0.1)
    end
    @test events_count == length(trigger_at)

    return nothing
end