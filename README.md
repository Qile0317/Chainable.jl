# Chainable.jl

[![Build Status](https://github.com/Qile0317/Chainable.jl/actions/workflows/CI.yml/badge.svg?branch=main)](https://github.com/Qile0317/Chainable.jl/actions/workflows/CI.yml?query=branch%3Amain)
[![Codecov test coverage](https://codecov.io/gh/Qile0317/Chainable.jl/branch/main/graph/badge.svg)](https://app.codecov.io/gh/Qile0317/Chainable.jl?branch=main)
<!-- [![Latest Release](https://img.shields.io/github/release/Qile0317/Chainable.jl.svg)](https://github.com/Qile0317/Chainable.jl/releases/latest)
[![Documentation](https://img.shields.io/badge/docs-stable-blue.svg)](https://qile0317.github.io/Chainable) -->
[![MIT license](https://img.shields.io/badge/license-MIT-green.svg)](https://github.com/Qile0317/Chainable.jl/LICENSE)

Exports the `@chainable` macro to make any Julia function pipeline-friendly. `@chainable` Defines a new method for the function that takes the first argument as the data and the rest as parameters. The chainable function definition is directly done in the namespace so there are potential issues with namespace pollution, need for documentation, linter/static analysis errors, and memory overhead. However, for simple research code and pipelines it can be a useful utility to quickly produce code.

## Installation

```julia
using Pkg
Pkg.add(PackageSpec(name="Chainable", url = "https://github.com/Qile0317/Chainable.jl.git"))
```

## Usage

```julia
using Chainable

@chainable function transform(data, factor, offset)
    return (data * factor) .+ offset
end

# Use it in pipelines
1 |> transform(2, 3)        # Same as: transform(1, 2, 3)

# Chain multiple operations
[1, 2, 3] |> 
    transform(2, 0) |>     # multiply by 2
    transform(1, 1)        # add 1
```

At the moment, only positional arguments are supported, *excluding* default arguments. Function return type annotation is also not supported.

## Roadmap

- [ ] setup gh actions
- [ ] Add support for function return type annotation
- [ ] Add support for default arguments (especially when there is argument type ambiguity in cases such as `@chainable LeakyRelu(x, a = 0.01) = max.(x * a, x`)
- [ ] Add support for named arguments
- [ ] Add support for broadcasting with `.`
- [ ] docsite
- [ ] register

## Contributing

Any contributions and suggestions are welcome.
