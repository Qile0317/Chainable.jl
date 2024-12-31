var documenterSearchIndex = {"docs":
[{"location":"chainable/#The-@chainable-Macro","page":"The @chainable Macro","title":"The @chainable Macro","text":"","category":"section"},{"location":"chainable/","page":"The @chainable Macro","title":"The @chainable Macro","text":"Modules = [Chainable]\nOrder = [:macro]","category":"page"},{"location":"chainable/#Chainable.@chainable-Tuple{Any}","page":"The @chainable Macro","title":"Chainable.@chainable","text":"@chainable\n\nA macro that makes functions pipeline-friendly by generating method definitions that work seamlessly with Julia's |> operator. For any function f(x, args...), creates a factory method f(args...) that returns a function x -> f(x, args...), enabling natural use in pipelines.\n\nThis supports both types of function assignment syntax:\n\n@chainable function f(x, y) ... end\n@chainable f(x, y) = ...\n\nNote that in cases where there are default positional arguments, in order to avoid method dispatch conflicts, the factory method will only accept keyword arguments. This is to ensure that the factory method can be called with no arguments, which would otherwise be ambiguous. For example, the following function:\n\n@chainable LeakyRelu(x, alpha=0.01)::Real = max.(x, alpha*x)\n\nBy default, julia will create the methods LeakyRelu(x, alpha) and LeakyRelu(x). The method created by @chainable will then be LeakyRelu(; alpha)::Function. This allows both the syntax 1 |> LeakyRelu() and 1 |> LeakyRelu(alpha = 0.02) to work, but not 1 |> LeakyRelu(0.02) because the right-hand side of the pipe operator now calls the default LeakyRelu(x) method.\n\nExamples\n\n# Make a function pipeline-friendly\n@chainable function transform(data, factor, offset)\n    return data * factor + offset\nend\n\n# Use in a pipeline\n1 |> transform(2, 3)  # Same as: transform(1, 2, 3)\n\n# Chain multiple operations\n[1, 2, 3] |> \n    transform(2, 0) |>   # multiply by 2\n    transform(1, 1)      # add 1\n\n# Works with any number of arguments\n@chainable function process(x, a, b, c)\n    return x + a + b + c\nend\n\n10 |> process(1, 2, 3)  # Returns 16\n\n@chainable increment(x, inc = 1) = x + inc\n1 |> increment() # works\n1 |> increment(2) # this is undefined behaviour. In this case it fails because increment(x::Int) is defined.\n1 |> increment(inc = 2) # works\n\n\n\n\n\n","category":"macro"},{"location":"#Chainable.jl","page":"Chainable.jl","title":"Chainable.jl","text":"","category":"section"},{"location":"","page":"Chainable.jl","title":"Chainable.jl","text":"Chainable","category":"page"},{"location":"#Chainable","page":"Chainable.jl","title":"Chainable","text":"Chainable.jl\n\n(Image: Build Status) (Image: Codecov test coverage) (Image: MIT license)\n\n<!– (Image: Latest Release) (Image: Documentation) –>\n\nExports the @chainable macro to make any Julia function pipeline-friendly. @chainable Defines a new method for the function that takes the first argument as the data and the rest as parameters. The chainable function definition is directly done in the namespace so there are potential issues with namespace pollution, need for documentation, linter/static analysis errors, and memory overhead.\n\nThis macro almost certainly should ***not*** be used in a package or large project. However, for quick & simple research scripts it can be a useful utility to quickly produce clean code.\n\nInstallation\n\nusing Pkg\nPkg.add(PackageSpec(name=\"Chainable\", url = \"https://github.com/Qile0317/Chainable.jl.git\"))\n\nUsage\n\nusing Chainable\n\n@chainable function transform(data, factor, offset)\n    return (data * factor) .+ offset\nend\n\n# Use it in pipelines\n1 |> transform(2, 3)        # Same as: transform(1, 2, 3)\n\n# Chain multiple operations\n[1, 2, 3] |> \n    transform(2, 0) |>     # multiply by 2\n    transform(1, 1)        # add 1\n\n# if default positional args are used, a named version must be used for piping\n@chainable increment(x, inc = 1) = x + inc\n1 |> increment() # works\n1 |> increment(2) # this is undefined behaviour and will fail here.\n1 |> increment(inc = 2) # works\n# note that if increment(; inc = 1) is defined, then this will override the existing definition.\n\nAt the moment, only positional arguments are supported. Function return type annotation is not supported.\n\nRoadmap\n\n[x] setup gh actions\n[ ] Add support for function return type annotation\n[x] Add support for default arguments (especially when there is argument type ambiguity in cases such as @chainable LeakyRelu(x, a = 0.01) = max.(x * a, x)\n[ ] Handle potential method overriding\n[ ] Add support for named arguments\n[ ] Add support for args and kwargs.\n[ ] Add support for broadcasting with .\n[ ] docsite\n[ ] register\n\nContributing\n\nAny contributions and suggestions are welcome.\n\n\n\n\n\n","category":"module"}]
}
