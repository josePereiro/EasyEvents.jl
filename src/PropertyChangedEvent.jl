function _dft_prop_changed_old_state(e::CustomEvent, prop::Symbol)
    get!(e, prop, nothing)
end

function _dft_prop_changed_new_state(e::CustomEvent, prop::Symbol)
    obj = getindex(extras(e), "OBJ")
    return getproperty(obj, prop)
end

function _dft_prop_changed_update!(e::CustomEvent, prop::Symbol)
    new_mtime = new_state(e, prop)
    setindex!(e, deepcopy(new_mtime), prop)
    return e
end

function _dft_prop_changed_trigger(::CustomEvent, old_val, new_val)
    return !isequal(old_val, new_val)
end

function PropertyChangedEvent(obj)
    e = CustomEvent{Symbol, Any}(
        old_state = _dft_prop_changed_old_state,
        new_state = _dft_prop_changed_new_state,
        update! = _dft_prop_changed_update!,
        trigger = _dft_prop_changed_trigger,
    )
    setindex!(extras(e), obj, "OBJ")
    return e
end
