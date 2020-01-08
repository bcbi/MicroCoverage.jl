function _restore_original_julia_file(filename::String)::Nothing
    backup_filename = string(filename, ".backup")
    always_assert(isfile(backup_filename),
                  "isfile(\"$(backup_filename)\")")
    rm(filename; force = true, recursive = true)
    @debug("Moving file from src to dst",
           src = backup_filename,
           dst = filename)
    mv(backup_filename, filename; force = true)
    return nothing
end
