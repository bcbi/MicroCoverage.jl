using MicroCoverage
using Test

@testset "MicroCoverage.jl" begin
    @test MicroCoverage.greet() === nothing
end
