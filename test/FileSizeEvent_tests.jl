## ------------------------------------------------------------------
let
    @info("Testing FileSizeEvent")
    e = FileSizeEvent()
    file = joinpath(tempdir(), "FileSizeEvent.test")
    write(file, "")
    update!(e, file)

    events_count = 0
    trigger_at = [3, 4, 5]
    for it in 1:10
        if has_event!(e ,file)
            println(basename(file), " changed!!!")
            events_count += 1
        end

        if it in trigger_at
            _append(file, "a")
        end
        sleep(0.1)
    end
    @test events_count == length(trigger_at)
end