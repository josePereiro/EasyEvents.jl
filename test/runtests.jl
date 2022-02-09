using EasyEvents
using Test

include("utils.jl")

@testset "EasyEvents.jl" begin
    include("FileMTimeEvent_tests.jl")
    include("FileSizeEvent_tests.jl")
    include("FileContentEvent_tests.jl")
    include("PropertyChangedEvent_test.jl")
end
