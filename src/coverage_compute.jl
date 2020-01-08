function _compute_lnn_to_coverage()
    lock(Main.MicroCoverage_lock) do
        lnn_to_tracker_indices = Dict{LineNumberNode, Vector{Int}}()
        for tracker_idx = 1:length(Main.MicroCoverage_tracker_linenumbernodes)
            lnn = Main.MicroCoverage_tracker_linenumbernodes[tracker_idx]
            if !haskey(lnn_to_tracker_indices, lnn)
                lnn_to_tracker_indices[lnn] = Vector{Int}()
            end
            push!(lnn_to_tracker_indices[lnn], tracker_idx)
        end
        lnn_to_coverage = Dict{LineNumberNode, Vector{Bool}}()
        for k in keys(lnn_to_tracker_indices)
            tracker_indices = lnn_to_tracker_indices[k]
            lnn_to_coverage[k] = Main.MicroCoverage_tracker[tracker_indices]
        end
        return lnn_to_coverage
    end
end

function _compute_coverage_file_contents(filename::String;
                                         min_padding::Integer,
                                         max_padding::Integer,
                                         source_code_filename::AbstractString = filename)::Vector{String}
    original_source_string::String = read(source_code_filename, String)::String
    original_source_lines = split(original_source_string, '\n')
    num_lines = length(original_source_lines)
    lnn_to_coverage = _compute_lnn_to_coverage()
    coverage_lines_prefixes = Vector{String}(undef, num_lines)
    for i = 1:num_lines
        coverage_lines_prefixes[i] = _coverage_boolvector_to_string(get(lnn_to_coverage,
                                                                        LineNumberNode(i,
                                                                        filename), Bool[]))
    end
    coverage_lines = Vector{String}(undef, num_lines)
    for i = 1:num_lines
        this_line_coverage_prefix = coverage_lines_prefixes[i]
        this_line_padding_length = max(min_padding,
                                       max_padding - length(this_line_coverage_prefix))
        this_line_padding = repeat(" ",
                                   max(1, this_line_padding_length))
        coverage_lines[i] = string(this_line_coverage_prefix,
                                   this_line_padding,
                                   original_source_lines[i])
    end
    return coverage_lines
end

function _coverage_boolvector_to_string(line_coverage::Vector{Bool})
    if length(line_coverage) < 1
        return "-"
    end
    return string("[", join(string.(convert(Vector{Int}, line_coverage)), ","), "]")
end
