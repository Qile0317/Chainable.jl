using Chainable
using Test

@testset "Chainable.jl" begin

    @test (@chainable pi |> *(2) |> sin()) == sin(2 * pi)
    @test (@chainable 1 |> sin() |> cos()) == cos(sin(1))
    @test (@chainable 1 |> +(2) |> *(3)) == 9
    @test (@chainable [1, 2] |> push!(3, 4)) == [1, 2, 3, 4]
    @test (@chainable [0, 0, 0] |> cumsum!([1, 2, 3], dims=1)) == [1, 3, 6]

end
