struct CustomEvent{K, T} <: AbstractEvent
    state::Dict{K, T}
    extras::Dict
    old_state::Function # f(e, args...) compute the old state
    new_state::Function # f(e, args...) compute the new state
    update!::Function    # f(e, args...) sync old and new states
    trigger::Function   # f(e, args...) definition that the event happens
end

function CustomEvent{K, T}(;
        state = Dict{K, T}(),
        extras = Dict(),
        old_state, new_state, update!, trigger
    ) where {K, T}
    CustomEvent{K, T}(state, extras, old_state, new_state, update!, trigger)
end

states(e::CustomEvent) = e.state
extras(e::CustomEvent) = e.extras
old_state(e::CustomEvent, args...) = e.old_state(e, args...)
new_state(e::CustomEvent, args...) = e.new_state(e, args...)
trigger(e::CustomEvent, args...) = e.trigger(e, args...)
update!(e::CustomEvent, arg, args...) = e.update!(e, arg, args...)
update!() = update!(e, keys(states(e)))
reset!(e::CustomEvent) = (empty!(extras(e)); empty!(states(e)))