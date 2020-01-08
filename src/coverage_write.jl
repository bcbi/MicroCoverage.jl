function _write_coverage(filename::String;
                         dump_coverage::Bool = false,
                         dump_coverage_io::IO = stdout)::Nothing
    coverage_filename = string(filename, ".microcov")
    coverage_lines = _compute_coverage_file_contents(filename)
    @debug("Writing coverage to file",
           source_file = filename,
           coverage_file = coverage_filename)
    rm(coverage_filename; force = true, recursive = true)
    open(coverage_filename, "w") do io
        for x in coverage_lines
            if dump_coverage
                println(dump_coverage_io, x)
            end
            println(io, x)
        end
    end
    return nothing
end
