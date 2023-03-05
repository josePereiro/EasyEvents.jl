function _dft_mtime_old_state(e::CustomEvent, file::String)
    get!(e, file, 0.0)
end

function _dft_mtime_new_state(::CustomEvent, file::String)
    mtime(file)
end

function _dft_mtime_update!(e::CustomEvent, file::String)
    new_mtime = new_state(e, file)
    setindex!(e, new_mtime, file)
    return e
end

function _dft_mtime_trigger(::CustomEvent, old_mtime, new_mtime)
    return old_mtime < new_mtime
end

function FileMTimeEvent()
    return CustomEvent{String, Float64}(;
        old_state = _dft_mtime_old_state,
        new_state = _dft_mtime_new_state,
        update! = _dft_mtime_update!,
        trigger = _dft_mtime_trigger, 
    )
end
