using Chainable
using Test

@testset "Chainable.jl" begin
    @testset "Pipeline operations" begin
        @chainable function transform(x, factor, offset)
            return x * factor .+ offset
        end
        
        @test 1 |> transform(2, 3) == 5
        @test ([1, 2, 3] |> transform(2, 0) |> transform(1, 1)) == [3, 5, 7]
    end

    @testset "Basic two-argument function" begin
        @chainable function add(x, y)
            return x + y
        end
        
        @test add(1, 2) == 3
        @test 1 |> add(2) == 3
    end

    @testset "Multiple arguments" begin
        @chainable function combine(x, y, z)
            return x + y + z
        end
        
        @test combine(1, 2, 3) == 6
        @test 1 |> combine(2, 3) == 6
    end

    @testset "Assignment syntax" begin
        @chainable mult(x, y) = x * y
        
        @test mult(2, 3) == 6
        @test 2 |> mult(3) == 6
    end

    @testset "String operations" begin
        @chainable function concat(x, y, z)
            return x * y * z
        end
        
        @test concat("a", "b", "c") == "abc"
        @test "a" |> concat("b", "c") == "abc"
    end

    @testset "Complex types" begin
        struct Point
            x::Int
            y::Int
        end
        
        @chainable function add_points(p1::Point, p2::Point)
            return Point(p1.x + p2.x, p1.y + p2.y)
        end
        
        p1 = Point(1, 2)
        p2 = Point(3, 4)
        @test (p1 |> add_points(p2)).x == 4
    end
end
