using Test
using Template  

include("cover.jl")
include("prof.jl")

@testset "Template test" begin
    Template.main()
    @test true
end
