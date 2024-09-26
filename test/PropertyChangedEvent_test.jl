## ------------------------------------------------------------------
let
    @info("Testing PropertyChangedEvent")
    global __glob = rand()
    e = PropertyChangedEvent(Main)
    @test event_type!(e, :__glob) === :new
    
    trigger_at = [3, 4, 5]
    mod_at = Int[]
    same_at = Int[]
    _iter = collect(1:10)
    for it in _iter
        # mod
        it in trigger_at && (__glob = rand())

        _etype = event_type!(e, :__glob)
        if _etype === :mod
            println(:__glob, " changed!!!")
            push!(mod_at, it)
        end

        if _etype === :same
            println(:__glob, " the same!!!")
            push!(same_at, it)
        end

        sleep(0.1)
    end
    @test mod_at == trigger_at
    @test same_at == setdiff(_iter, trigger_at)

end