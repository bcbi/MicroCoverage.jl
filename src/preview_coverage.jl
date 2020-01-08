function preview_coverage(; dump_coverage_io::IO = stdout,
                            min_padding::Integer = 1,
                            max_padding::Integer = 24)
    setup()
    all_tracked_files = tracked_files()
    for x in all_tracked_files
        backup_filename = string(x, ".backup")
        coverage_filename = string(x, ".microcov")
        coverage_lines = _compute_coverage_file_contents(x;
                                                         min_padding = min_padding,
                                                         max_padding = max_padding,
                                                         source_code_filename = backup_filename)
        # println(dump_coverage_io, "\n")
        println(dump_coverage_io, "# Preview of $(coverage_filename):")
        for x in coverage_lines
            println(dump_coverage_io, x)
        end
        # println(dump_coverage_io, "\n")
    end
    return nothing
end
