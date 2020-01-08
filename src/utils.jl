function with_temp_dir(f::Function)
    original_directory = pwd()
    _temp_dir = mktempdir()
    atexit(() -> rm(_temp_dir; force = true, recursive = true))
    cd(_temp_dir)
    result = f(_temp_dir)
    cd(original_directory)
    rm(_temp_dir; force = true, recursive = true)
    return result
end
