using MicroCoverage
using Test

module MicroCoverageTestSuite

using MicroCoverage
using Test

@testset "MicroCoverage.jl" begin
    @testset "public_interface.jl" begin
        MicroCoverage.with_temp_dir() do tmp_depot
            MicroCoverage.with_temp_dir() do tmp_src_directory
                foo_jl_filename = joinpath(tmp_src_directory,
                                           "foo.jl")
                test_foo_jl_filename = joinpath(tmp_src_directory,
                                                "test_foo.jl")
                foo_jl_microcov_filename = joinpath(tmp_src_directory,
                                                    "foo.jl.microcov")
                open(foo_jl_filename, "w") do io
                    println(io, "function foo(x)")
                    println(io, "    if x == 1 || x == 100")
                    println(io, "        return \"hello\"")
                    println(io, "    else")
                    println(io, "        return \"goodbye\"")
                    println(io, "    end")
                    println(io, "end")
                end
                open(test_foo_jl_filename, "w") do io
                    println(io, "using Test")
                    println(io, "")
                    println(io, "@test foo(1) == \"hello\"")
                end
                MicroCoverage.start(foo_jl_filename)
                include(foo_jl_filename)
                MicroCoverage.preview_coverage(; dump_coverage_io = devnull)
                include(test_foo_jl_filename)
                MicroCoverage.preview_coverage(; dump_coverage_io = devnull)
                @test !isfile(foo_jl_microcov_filename)
                @test !ispath(foo_jl_microcov_filename)
                @test Main.MicroCoverage_tracker == Bool[1,0,1,1,0,0,1,1,1,1]
                MicroCoverage.stop(; dump_coverage = true,
                                     dump_coverage_io = devnull)
                @test isfile(foo_jl_microcov_filename)
                @test ispath(foo_jl_microcov_filename)
                foo_jl_microcov_filecontents = read(foo_jl_microcov_filename, String)
                @test foo_jl_microcov_filecontents == string("[1,1,1]                 function foo(x)\n",
                                                             "[1,0,1,0,1]                 if x == 1 || x == 100\n",
                                                             "[1]                             return \"hello\"\n",
                                                             "-                           else\n",
                                                             "[0]                             return \"goodbye\"\n",
                                                             "-                           end\n",
                                                             "-                       end\n",
                                                             "-                       \n")
            end
        end
    end
end

end # end module MicroCoverageTestSuite
