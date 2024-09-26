let

    @info("Testing FileMTimeEvent")
    e = FileMTimeEvent()
    file = joinpath(tempdir(), "FileMTimeEvent.test")
    @test event_type!(e, file) === :new

    trigger_at = [3, 4, 5]
    mod_at = Int[]
    same_at = Int[]
    _iter = collect(1:10)
    for it in _iter
        # mod
        it in trigger_at && touch(file)

        _etype = event_type!(e, file)
        if _etype === :mod
            println(basename(file), " changed!!!")
            push!(mod_at, it)
        end

        if _etype === :same
            println(basename(file), " the same!!!")
            push!(same_at, it)
        end

        sleep(0.1)
    end
    @test mod_at == trigger_at
    @test same_at == setdiff(_iter, trigger_at)

    return nothing
end