function _dft_filesize_old_state(e::CustomEvent, file::String)
    get!(e, file, 0.0)
end

function _dft_filesize_new_state(::CustomEvent, file::String)
    filesize(file)
end

function _dft_filesize_update!(e::CustomEvent, file::String)
    new_size = new_state(e, file)
    setindex!(e, new_size, file)
    return e
end

function _dft_filesize_trigger(::CustomEvent, old_size, new_size)
    return old_size < new_size
end

function FileSizeEvent()
    return CustomEvent{String, Float64}(;
        old_state = _dft_filesize_old_state,
        new_state = _dft_filesize_new_state,
        update! = _dft_filesize_update!,
        trigger = _dft_filesize_trigger,
    )
end
