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
