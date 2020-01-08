abstract type MicroCoverageException <: Exception
end

struct AlwaysAssertionError <: MicroCoverageException
    msg::String
end
