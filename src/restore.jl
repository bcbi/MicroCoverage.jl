function _restore_original_julia_file(filename::Symbol)::Nothing
    _filename = string(filename)
    backup_filename = string(_filename, ".backup")
    always_assert(isfile(backup_filename),
                  "isfile(\"$(backup_filename)\")")
    rm(_filename; force = true, recursive = true)
    @debug("Moving file from src to dst",
           src = backup_filename,
           dst = _filename)
    mv(backup_filename, _filename; force = true)
    return nothing
end
