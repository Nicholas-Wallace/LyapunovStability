using LyapunovStability
using Test

@testset "Polyhedron tests" begin

    @testset "types" begin
        include("type_test.jl")
    end

    @testset "is p-invariant" begin
        include("is_pinvariant_tests.jl")
    end

    @testset "p-invariant polyhedron" begin
        include("pinvariant_poly.jl")
    end

    @testset "utils" begin
        include("utils_test.jl")
    end

end
