function tracker(filename::String, lnn::LineNumberNode)
    return lock(Main.MicroCoverage_lock) do
        new_tracker_length = length(Main.MicroCoverage_tracker) + 1
        @debug("Tracker length: $(new_tracker_length)")
        push!(Main.MicroCoverage_tracker, false)
        push!(Main.MicroCoverage_tracker_linenumbernodes,
              LineNumberNode(lnn.line, filename))
        return :(Main.MicroCoverage_tracker[$(new_tracker_length)] = true)
    end
end

function tracked_files()
    setup()
    return lock(Main.MicroCoverage_lock) do
        all_tracked_files = Vector{String}(undef, 0)
        for lnn in Main.MicroCoverage_tracker_linenumbernodes
            push!(all_tracked_files, lnn.file)
        end
        unique!(all_tracked_files)
        return all_tracked_files
    end
end

function _start_tracking_file(filename::AbstractString)
    _realpath::String = convert(String, realpath(filename))::String
    return _start_tracking_file(_realpath)
end

function _start_tracking_file(filename::String)::Nothing
    _realpath::String = convert(String, realpath(filename))::String
    original_block = _read_julia_file(_realpath)
    always_assert( length(original_block.args) >= 1,
                  "length(original_block.args) >= 1")
    always_assert( original_block.args[1] isa LineNumberNode,
                  "original_block.args[1] isa LineNumberNode")
    instrumented_block = instrument(_realpath, original_block)
    backup_filename = string(_realpath, ".backup")
    rm(backup_filename; force = true, recursive = true)
    @debug("Moving file from src to dst",
           src = _realpath,
           dst = backup_filename)
    mv(_realpath, backup_filename; force = true)
    _write_julia_file(_realpath, instrumented_block)
    return nothing
end
