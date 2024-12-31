push!(LOAD_PATH,"../src/")

using Documenter, Chainable

makedocs(sitename="Chainable.jl", modules = [Chainable])

deploydocs(;
    repo="github.com/Qile0317/Chainable.jl.git", branch = "gh-pages", devbranch = "main"
)
