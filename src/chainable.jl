export @chainable

"""
    @chainable

A macro that makes functions pipeline-friendly by generating method definitions that work seamlessly
with Julia's `|>` operator. For any function `f(x, args...)`, creates a factory method `f(args...)`
that returns a function `x -> f(x, args...)`, enabling natural use in pipelines.

The macro supports both function syntax and assignment syntax:
```julia
@chainable function f(x, y) ... end
@chainable f(x, y) = ...
```

# Examples
```julia
# Make a function pipeline-friendly
@chainable function transform(data, factor, offset)
    return data * factor + offset
end

# Use in a pipeline
1 |> transform(2, 3)  # Same as: transform(1, 2, 3)

# Chain multiple operations
[1, 2, 3] |> 
    transform(2, 0) |>   # multiply by 2
    transform(1, 1)      # add 1

# Works with any number of arguments
@chainable function process(x, a, b, c)
    return x + a + b + c
end

10 |> process(1, 2, 3)  # Returns 16
```
"""
macro chainable(expr)

    if expr.head == :function
        func_name = expr.args[1].args[1]
        func_args = expr.args[1].args[2:end]
        func_body = expr.args[2]
    elseif expr.head == :(=)
        func_def = expr.args[1]
        func_name = func_def.args[1]
        func_args = func_def.args[2:end]
        func_body = expr.args[2]
    else
        error("@chainable must be used with a function definition")
    end

    original_function = if expr.head == :function
        :(function $func_name($(func_args...))
            $func_body
        end)
    else
        :($func_name($(func_args...)) = $func_body)
    end

    first_arg = func_args[1]
    remaining_args = func_args[2:end]
    factory_function = :(
        function $func_name($(remaining_args...))
            return function($first_arg)
                $func_name($first_arg, $(remaining_args...))
            end
        end
    )

    return esc(quote
        $original_function
        $factory_function
    end)

end
