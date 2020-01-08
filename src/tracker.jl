function tracker(filename::String, lnn::LineNumberNode)
    return lock(Main.MicroCoverage_lock) do
        new_tracker_length = length(Main.MicroCoverage_tracker) + 1
        @debug("Tracker length: $(new_tracker_length)")
        push!(Main.MicroCoverage_tracker,
              false)
        push!(Main.MicroCoverage_tracker_linenumbernodes,
              LineNumberNode(lnn.line, filename))
        return :(Main.MicroCoverage_tracker[$(new_tracker_length)] = true)
    end
end
