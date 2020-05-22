function _write_coverage(filename::Symbol;
                         dump_coverage::Bool = false,
                         dump_coverage_io::IO = stdout,
                         min_padding::Integer,
                         max_padding::Integer)::Nothing
    coverage_filename = string(filename, ".microcov")
    coverage_lines = _compute_coverage_file_contents(filename;
                                                     min_padding = min_padding,
                                                     max_padding = max_padding)
    @debug("Writing coverage to file",
           source_file = filename,
           coverage_file = coverage_filename)
    rm(coverage_filename; force = true, recursive = true)
    open(coverage_filename, "w") do io
        if dump_coverage
            # println(dump_coverage_io, "\n")
            println(dump_coverage_io, "# $(coverage_filename):")
        end
        for x in coverage_lines
            if dump_coverage
                println(dump_coverage_io, x)
            end
            println(io, x)
        end
        if dump_coverage
            # println(dump_coverage_io, "\n")
        end
    end
    return nothing
end
