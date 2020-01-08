function setup()::Nothing
    if !isdefined(Main, :MicroCoverage_lock)
        @eval Main const MicroCoverage_lock = ReentrantLock()
        lock(Main.MicroCoverage_lock) do
            @eval Main const MicroCoverage_tracker = Vector{Bool}(undef, 0)
            @eval Main const MicroCoverage_tracker_linenumbernodes = Vector{LineNumberNode}(undef, 0)
        end
    end
    return nothing
end

function start(path::AbstractString)
    setup()
    if isfile(path)
        return _start_tracking_file(path)
    else
        throw(ArgumentError("Path must be an existing file"))
    end
end

function stop(; dump_coverage::Bool = false,
                dump_coverage_io::IO = stdout,
                min_padding::Integer = 1,
                max_padding::Integer = 24)
    setup()
    all_tracked_files = tracked_files()
    for x in all_tracked_files
        _restore_original_julia_file(x)
    end
    for x in all_tracked_files
        _write_coverage(x; dump_coverage = dump_coverage,
                           dump_coverage_io = dump_coverage_io,
                           min_padding = min_padding,
                           max_padding = max_padding)
    end
    return nothing
end

function clean(path::AbstractString = pwd())
    if isfile(path)
        return _clean_file(convert(String, realpath(path)))
    elseif isdir(path)
        return _clean_directory(convert(String, realpath(path)))
    else
        throw(ArgumentError("Path must be an existing file or directory"))
    end
end
