function _file_content_hash(file) 
    hash_ = hash("")
    isfile(file) && for line in eachline(file)
        hash_ = hash(line, hash_)
    end
    return hash_
end

function _file_content_mtime_event(e::CustomEvent)
    get!(extras(e), "_MTIME_") do
        FileMTimeEvent()
    end
end

function _get_file_content_hash_cache(e::CustomEvent)
    get!(extras(e), "_HASH_CACHE_") do
        _file_content_hash("")
    end
end

function _up_file_content_hash_cache!(e::CustomEvent, file)
    hash_ = _file_content_hash(file)
    setindex!(extras(e), hash_, "_HASH_CACHE_")
    return hash_
end

function _dft_file_content_old_state(e::CustomEvent, file::String)
    get!(e, file) do
        _file_content_hash(file)
    end
end

function _dft_file_content_new_state(e::CustomEvent, file::String)
    mtime_event = _file_content_mtime_event(e)
    if pull_event!(mtime_event, file)
        # Recompute only is file was modify (better performance)
        # And cached
        hash_ = _up_file_content_hash_cache!(e, file)
        return hash_
    end
    return _get_file_content_hash_cache(e)
end

function _dft_file_content_update!(e::CustomEvent, file::String)
    new_hash = new_state(e, file)
    setindex!(e, new_hash, file)
    # Update also the mtime event
    mtime_event = _file_content_mtime_event(e)
    update!(mtime_event, file)
    return e
end

function _dft_file_content_trigger(::CustomEvent, old_hash, new_hash)
    return (old_hash != new_hash)
end

function FileContentEvent()
    T = Union{CustomEvent{String, Float64}, UInt64}
    return CustomEvent{String, T}(;
        old_state = _dft_file_content_old_state,
        new_state = _dft_file_content_new_state,
        update! = _dft_file_content_update!,
        trigger = _dft_file_content_trigger
    )
end
