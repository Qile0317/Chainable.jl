# Chainable.jl

Exports the `@chainable` macro to make any Julia function pipeline-friendly. `@chainable` Defines a new method for the function that takes the first argument as the data and the rest as parameters. The chainable function definition is directly done in the namespace so there are potential issues with namespace pollution, need for documentation, linter/static analysis errors, and memory overhead. However, for simple research code and pipelines it can be a useful utility to quickly produce code.

## Installation

```julia
using Pkg
Pkg.add("Chainable")
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

## Roadmap

- [ ] Add support for broadcasting with `.`

## Contributing

Any contributions and suggestions are welcome.
