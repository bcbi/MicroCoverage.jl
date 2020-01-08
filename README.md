# MicroCoverage

[![Build Status](https://travis-ci.com/bcbi/MicroCoverage.jl.svg?branch=master)](https://travis-ci.com/bcbi/MicroCoverage.jl/branches)
[![Codecov](https://codecov.io/gh/bcbi/MicroCoverage.jl/branch/master/graph/badge.svg)](https://codecov.io/gh/bcbi/MicroCoverage.jl)
[![Coveralls](https://coveralls.io/repos/github/bcbi/MicroCoverage.jl/badge.svg?branch=master)](https://coveralls.io/github/bcbi/MicroCoverage.jl?branch=master)

## Example

`foo.jl`:
```julia
function foo(x)
    if x == 1 || x == 100
        return "hello"
    else
        return "goodbye"
    end
end
```

`test_foo.jl`:
```julia
using Test

@test foo(1) == "hello"
```

```julia
julia> using MicroCoverage

julia> MicroCoverage.start("foo.jl")

julia> include("foo.jl")

julia> include("test_foo.jl")

julia> MicroCoverage.stop()
```

## Acknowledgements

- This work was supported in part by National Institutes of Health grants U54GM115677, R01LM011963, and R25MH116440. The content is solely the responsibility of the authors and does not necessarily represent the official views of the National Institutes of Health.

## Related Work

1. [https://github.com/StephenVavasis/microcoverage](https://github.com/StephenVavasis/microcoverage)
2. [https://github.com/JuliaCI/Coverage.jl](https://github.com/JuliaCI/Coverage.jl)
3. [https://github.com/JuliaCI/CoverageTools.jl](https://github.com/JuliaCI/CoverageTools.jl)
