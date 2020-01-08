module MicroCoverage

include("types.jl")

include("public_interface.jl")

include("assert.jl")
include("clean.jl")
include("coverage_compute.jl")
include("coverage_write.jl")
include("instrument.jl")
include("read_write_julia_files.jl")
include("restore.jl")
include("start_tracking_file.jl")
include("tracked_files.jl")
include("tracker.jl")

end # end module MicroCoverage
