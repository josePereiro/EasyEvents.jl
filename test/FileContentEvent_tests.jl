## ------------------------------------------------------------------
let
    @info("Testing FileContentEvent")
    e = FileContentEvent()
    file = joinpath(tempdir(), "FileContentEvent.test")
    write(file, "0")
    update!(e, file)
    
    events_count = 0
    trigger_at = [3, 4, 5]
    for it in 1:10
        touch(file)
        if pull_event!(e, file)
            println(basename(file), " changed!!!")
            events_count += 1
        end

        if it in trigger_at
            write(file, it)
        end
        sleep(0.1)
    end
    @test events_count == length(trigger_at)
end