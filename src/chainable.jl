export @chainable

"""
    @chainable

A macro that makes functions pipeline-friendly by generating method definitions that work seamlessly
with Julia's `|>` operator. For any function `f(x, args...)`, creates a factory method `f(args...)`
that returns a function `x -> f(x, args...)`, enabling natural use in pipelines.

This supports both types of function assignment syntax:
```julia
@chainable function f(x, y) ... end
@chainable f(x, y) = ...
```

Note that in cases where there are default *positional* arguments, in order to avoid
method dispatch conflicts, the factory method will only accept keyword arguments. This is
to ensure that the factory method can be called with no arguments, which would otherwise
be ambiguous. For example, the following function:
```julia
@chainable LeakyRelu(x, alpha=0.01)::Real = max.(x, alpha*x)
```
By default, julia will create the methods `LeakyRelu(x, alpha)` and `LeakyRelu(x)`. The
method created by `@chainable` will then be `LeakyRelu(; alpha)::Function`. This
allows both the syntax `1 |> LeakyRelu()` and `1 |> LeakyRelu(alpha = 0.02)` to work,
but **not** `1 |> LeakyRelu(0.02)` because the right-hand side of the pipe operator
now calls the default `LeakyRelu(x)` method.

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

@chainable increment(x, inc = 1) = x + inc
1 |> increment() # works
1 |> increment(2) # this is undefined behaviour. In this case it fails because increment(x::Int) is defined.
1 |> increment(inc = 2) # works
```
"""
macro chainable(expr)
    # Extract function components based on syntax type
    function extract_function_parts(expr)
        if expr.head == :function
            func_def = expr.args[1]
            func_body = expr.args[2]
        elseif expr.head == :(=)
            func_def = expr.args[1]
            func_body = expr.args[2]
        else
            error("@chainable must be used with a function definition")
        end
        
        return func_def, func_body
    end
    
    # Helper to analyze arguments and find ones with defaults
    function analyze_args(args)
        required_args = []
        optional_args = Dict()
        
        for arg in args
            if isa(arg, Symbol)
                push!(required_args, arg)
            elseif arg.head == :(::)
                push!(required_args, arg)
            elseif arg.head == :kw  # Handle default arguments
                optional_args[arg.args[1]] = arg.args[2]
            else
                error("Unexpected argument form: $(arg.head)")
            end
        end
        
        return required_args, optional_args
    end
    
    # Get function parts
    func_def, func_body = extract_function_parts(expr)
    func_name = func_def.args[1]
    all_args = func_def.args[2:end]
    
    # Separate first argument and analyze remaining args
    first_arg = all_args[1]
    remaining_args = all_args[2:end]
    required_args, optional_args = analyze_args(remaining_args)
    
    # Create the original function (preserve the original expression)
    original_function = expr
    
    # Create factory methods
    factory_methods = []
    
    # Factory method with all optional arguments as keywords
    if !isempty(optional_args)
        optional_pairs = [Expr(:kw, k, v) for (k, v) in optional_args]
        push!(factory_methods, :(
            function $func_name($(required_args...); $(optional_pairs...))
                return function($first_arg)
                    $func_name($first_arg, $(required_args...), $(keys(optional_args)...))
                end
            end
        ))
        
        # Factory method with no arguments
        push!(factory_methods, :(
            function $func_name()
                return function($first_arg)
                    $func_name($first_arg)
                end
            end
        ))
    end
    
    # Generate base factory method if there are required args
    if !isempty(required_args)
        push!(factory_methods, :(
            function $func_name($(required_args...))
                return function($first_arg)
                    $func_name($first_arg, $(required_args...))
                end
            end
        ))
    end
    
    return esc(quote
        $original_function
        $(factory_methods...)
    end)
end
