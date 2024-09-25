abstract type AbstractEvent end

_undefined_error(meth, T, args) = error("Method`$(meth)(e::$T, $args)` not defined!")

## ------------------------------------------------------------------
old_state(e::AbstractEvent, args...) = error("Method `old_state(e::$(typeof(e)), args...)` not defined!")
new_state(e::AbstractEvent, args...) = error("Method `new_state(e::$(typeof(e)), args...)` not defined!")

"""
This should ensure that `old_state` returns an object that do not `trigger` the handler over the return of `new_state`.
That is, it configure the handler to react to a 'incoming event'.
"""
update!

update!(e::AbstractEvent, args...) = error("Method `update!(e::$(typeof(e)), args...)` not defined!")

reset!(e::AbstractEvent, args...) = error("Method `reset!(e::$(typeof(e)), args...)` not defined!")
trigger(e::AbstractEvent, old_state, new_state) = error("Method `trigger(e::$(typeof(e)), old_state, new_state)` not defined!")
states(e::AbstractEvent) = error("Method `states(e::$(typeof(e)))::AbstractDict` not defined!")
istraking(e::AbstractEvent, key) = haskey(states(e), key)

## ------------------------------------------------------------------
Base.getindex(e::AbstractEvent, key) = getindex(states(e), key)
Base.setindex!(e::AbstractEvent, value, key) = setindex!(states(e), value, key)
Base.get!(e::AbstractEvent, key, default) = get!(states(e), key, default)
Base.get!(f::Function, e::AbstractEvent, key) = get!(f, states(e), key)
Base.get(e::AbstractEvent, key, default) = get(states(e), key, default)
Base.get(f::Function, e::AbstractEvent, key) = get(f, states(e), key)

## ------------------------------------------------------------------
"""
Returns true if the event happened.
It do not update the handler state (see bang version).
DEPRECATED
"""
has_event

has_event(e::AbstractEvent, args...) = trigger(e, old_state(e, args...), new_state(e, args...))

"""
Returns true if the event happened.
It do not update the handler state (see bang version).
"""
pull_event

pull_event(e::AbstractEvent, args...) = trigger(e, old_state(e, args...), new_state(e, args...))

@deprecate has_event(x...) pull_event(x...) true

"""
Returns true if the event happened.
Additionally, it will call `update!` over the handler (only if `has_event` triggered).
DEPRECATED
"""
has_event!

function has_event!(e::AbstractEvent, args...)
    flag = has_event(e, args...)
    flag && update!(e, args...)
    return flag
end


"""
Returns true if the event happened.
Additionally, it will call `update!` over the handler (only if `pull_event` triggered).
"""
pull_event!

function pull_event!(e::AbstractEvent, args...)
    flag = pull_event(e, args...)
    flag && update!(e, args...)
    return flag
end

@deprecate has_event!(x...) pull_event!(x...) true

"""
Executes `f()` if `pull_event` returns true.
Returns the results of `f()` or nothing.
"""
on_event

on_event(f::Function, e::AbstractEvent, args...) = (pull_event(e, args...) ? f() : nothing)

"""
Executes `f()` if `pull_event` returns true.
Additionally, it will call `update!` over the handler (only if `pull_event` triggered).
Returns the results of `f()` or nothing.
"""
on_event!

function on_event!(f::Function, e::AbstractEvent, args...)
    flag = pull_event!(e, args...)
    return flag ? f() : nothing
end
