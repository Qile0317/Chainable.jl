module Chainable

@doc read(joinpath(dirname(@__DIR__), "README.md"), String) Chainable

export @chainable

unpipe(x) = x

function unpipe(expr::Expr)
    _, x, f = expr.args
    return :($(f.args[1])($(unpipe(x)), $(f.args[2:end]...)))
end

macro chainable(expr::Expr)
    unpipe(expr)
end

end
