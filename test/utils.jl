function _append(file, txt)
    open(file, "a") do io
        print(io, txt)
    end
end