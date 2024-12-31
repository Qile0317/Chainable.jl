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

    # TODO future feature
    # @testset "Simple return type annotation" begin
    #     @chainable function add_typed(x::Int, y::Int)::Int
    #         return x + y
    #     end

    #     @test add_typed(1, 2) === 3
    #     @test 1 |> add_typed(2) === 3
    # end

    @testset "Simple default arguments" begin
        @chainable function add_default(x, y=1)
            return x + y
        end
        
        @test add_default(1) == 2
        @test 1 |> add_default() == 2
        @test 1 |> add_default(y=2) == 3

        @chainable add_default2(x, y=1) = x + y
        
        @test add_default2(1) == 2
        @test 1 |> add_default2() == 2
        @test 1 |> add_default2(y=2) == 3
    end

    # TODO simple defaults with return type annotations

    # TODO lots of defaults

    # TODO named args

    # TODO args and kwargs

end
