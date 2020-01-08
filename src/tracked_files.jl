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
