function always_assert(condition::Bool,
                       msg::AbstractString = "")::Nothing
    _msg::String = convert(String, msg)::String
    if !condition
        throw(AlwaysAssertionError(_msg))
    end
    return nothing
end
