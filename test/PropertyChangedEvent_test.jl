## ------------------------------------------------------------------
let
    @info("Testing PropertyChangedEvent")
    global __glob = rand()
    e = PropertyChangedEvent(Main)
    update!(e, :__glob)
    
    events_count = 0
    trigger_at = [3, 4, 5]
    for it in 1:10
        
        if is_event!(e, :__glob)
            println(:__glob, " changed!!!")
            events_count += 1
        end

        if it in trigger_at
            __glob = rand()
        end
        sleep(0.1)
    end
    @test events_count == length(trigger_at)
end