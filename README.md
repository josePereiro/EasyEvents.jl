# EasyEvents

[![Build Status](https://github.com/josePereiro/EasyEvents.jl/actions/workflows/CI.yml/badge.svg?branch=main)](https://github.com/josePereiro/EasyEvents.jl/actions/workflows/CI.yml?query=branch%3Amain)
[![Coverage](https://codecov.io/gh/josePereiro/EasyEvents.jl/branch/main/graph/badge.svg)](https://codecov.io/gh/josePereiro/EasyEvents.jl)

The package define an `AbstractEvent` interface and provide a few basic implementations.
In particular it implements a flexible [`CustomEvent`](https://github.com/josePereiro/EasyEvents.jl/blob/main/src/CustomEvent.jl) type which can handle several different events.
See [`FileMTimeEvent`](https://github.com/josePereiro/EasyEvents.jl/blob/main/src/FileMTimeEvent.jl) as an example and check the tests for usage.

## Basic Usage

```julia
using EasyEvents
let
    @info("Testing PropertyChangedEvent")

    # This handler track an object
    e = PropertyChangedEvent(Main)

    # Initialize the handler state for Main.__glob
    global __glob = rand()
    update!(e, :__glob)
    
    events_count = 0
    trigger_at = [2, 4, 8]
    for it in 1:10
        
        # modify Main.__glob
        if it in trigger_at
            println("[", it, "] changing __glob!!!")
            __glob = rand()
        end
        
        # This will run if Main.__glob changed from the last update
        # The bang indicates that `update!(e, :__glob)` will be called
        if has_event!(e, :__glob)
            println("[", it, "] event detected!!!")
        else
            println("[", it, "] nothing to do!!!")
        end
    end
end
```
