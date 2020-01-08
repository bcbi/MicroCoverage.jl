using MicroCoverage
using Test

module MicroCoverageTestSuite

using MicroCoverage
using Test

function get_test_directory()::String
    return dirname(@__FILE__)
end

function get_filename(parts...)::String
    return joinpath(get_test_directory(), parts...)
end

function readstring_filename(parts...)::String
    _filename = get_filename(parts...)
    return read(_filename, String)
end

@testset "MicroCoverage.jl" begin
    @testset "assert.jl" begin
        @test MicroCoverage.always_assert(true, "") == nothing
        @test_throws MicroCoverage.AlwaysAssertionError MicroCoverage.always_assert(false, "")
    end
    @testset "instrument.jl" begin
        MicroCoverage.instrument("", Expr(:block), Val(:block)) == Expr(:block)
    end
    @testset "public_interface.jl" begin
        MicroCoverage.with_temp_dir() do tmp_depot
            MicroCoverage.with_temp_dir() do tmp_src_directory
                nonexistent_filename = joinpath(tmp_src_directory, "nonexistent.jl")
                foo_jl_filename = joinpath(tmp_src_directory, "foo.jl")
                test_foo_jl_filename = joinpath(tmp_src_directory, "test_foo.jl")
                foo_jl_microcov_filename = joinpath(tmp_src_directory, "foo.jl.microcov")
                bar_jl_filename = joinpath(tmp_src_directory, "bar.jl")
                test_bar_jl_filename = joinpath(tmp_src_directory, "test_bar.jl")
                bar_jl_microcov_filename = joinpath(tmp_src_directory, "bar.jl.microcov")

                open(foo_jl_filename, "w") do io
                    print(io, readstring_filename("inputs", "foo.jl"))
                end
                open(test_foo_jl_filename, "w") do io
                    print(io, readstring_filename("inputs", "test_foo.jl"))
                end
                open(bar_jl_filename, "w") do io
                    print(io, readstring_filename("inputs", "bar.jl"))
                end
                open(test_bar_jl_filename, "w") do io
                    print(io, readstring_filename("inputs", "test_bar.jl"))
                end

                @test_throws ArgumentError MicroCoverage.start(nonexistent_filename)
                @test_throws ArgumentError MicroCoverage.clean(nonexistent_filename)
                MicroCoverage.start(strip(foo_jl_filename))
                MicroCoverage.start(bar_jl_filename)

                MicroCoverage.preview_coverage(; dump_coverage_io = devnull)
                include(foo_jl_filename)
                MicroCoverage.preview_coverage(; dump_coverage_io = devnull)
                include(bar_jl_filename)
                MicroCoverage.preview_coverage(; dump_coverage_io = devnull)
                include(test_foo_jl_filename)
                MicroCoverage.preview_coverage(; dump_coverage_io = devnull)
                include(test_bar_jl_filename)
                MicroCoverage.preview_coverage(; dump_coverage_io = devnull)

                @test !isfile(foo_jl_microcov_filename)
                @test !ispath(foo_jl_microcov_filename)
                @test !isfile(bar_jl_microcov_filename)
                @test !ispath(bar_jl_microcov_filename)

                MicroCoverage.stop(; dump_coverage = true, dump_coverage_io = devnull)

                @test isfile(foo_jl_microcov_filename)
                @test ispath(foo_jl_microcov_filename)
                @test isfile(bar_jl_microcov_filename)
                @test ispath(bar_jl_microcov_filename)

                @test read(foo_jl_microcov_filename, String) == readstring_filename("expected_outputs", "foo.jl.microcov.expected")
                @test read(bar_jl_microcov_filename, String) == readstring_filename("expected_outputs", "bar.jl.microcov.expected")
                touch(foo_jl_microcov_filename)
                MicroCoverage.clean(foo_jl_filename)
                touch(foo_jl_microcov_filename)
                MicroCoverage.clean(tmp_src_directory)
            end
        end
    end
end

end # end module MicroCoverageTestSuite
