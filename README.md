# MicroCoverage

[![Build Status](https://travis-ci.com/bcbi/MicroCoverage.jl.svg?branch=master)](https://travis-ci.com/bcbi/MicroCoverage.jl/branches)
[![Codecov](https://codecov.io/gh/bcbi/MicroCoverage.jl/branch/master/graph/badge.svg)](https://codecov.io/gh/bcbi/MicroCoverage.jl)
[![Coveralls](https://coveralls.io/repos/github/bcbi/MicroCoverage.jl/badge.svg?branch=master)](https://coveralls.io/github/bcbi/MicroCoverage.jl?branch=master)

MicroCoverage.jl is a code coverage tool for Julia, implemented in pure Julia.

## Installation

```julia
julia> using Pkg; Pkg.add(Pkg.PackageSpec(url = "https://github.com/bcbi/MicroCoverage.jl"))
```

## Example

**Step 1:** Create a file named `foo.jl` with the following contents:
```julia
function foo(x)
    if x == 1 || x == 100
        return "hello"
    else
        return "goodbye"
    end
end
```

**Step 2:** Create a file named `test_foo.jl` with the following contents:
```julia
using Test

@test foo(1) == "hello"
```

**Step 3:** Open `julia` and run the following commands:
```julia
julia> using MicroCoverage

julia> MicroCoverage.start("foo.jl")

julia> include("foo.jl")

julia> include("test_foo.jl")

julia> MicroCoverage.stop()
```

When you run `MicroCoverage.stop()`, MicroCoverage will create
a file named `foo.jl.microcov` with the following contents:
```julia
[1,1,1]                 function foo(x)
[1,0,1,0,1]                 if x == 1 || x == 100
[1]                             return "hello"
-                           else
[0]                             return "goodbye"
-                           end
-                       end
-
```

## Acknowledgements

- This work was supported in part by National Institutes of Health grants U54GM115677, R01LM011963, and R25MH116440. The content is solely the responsibility of the authors and does not necessarily represent the official views of the National Institutes of Health.

## Related Work

1. [https://github.com/StephenVavasis/microcoverage](https://github.com/StephenVavasis/microcoverage)
2. [https://github.com/JuliaCI/Coverage.jl](https://github.com/JuliaCI/Coverage.jl)
3. [https://github.com/JuliaCI/CoverageTools.jl](https://github.com/JuliaCI/CoverageTools.jl)
