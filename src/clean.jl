function _clean_file(filename::String)
    coverage_filename = string(filename, ".microcov")
    rm(coverage_filename; force = true, recursive = true)
    return nothing
end

function _clean_directory(path::String)
    microcov_file_suffix = ".microcov"
    for (root, dirs, files) in walkdir(".")
        for file in files
            if endswith(file, microcov_file_suffix)
                rm(joinpath(root, file); force = true, recursive = true)
            end
        end
    end
    return nothing
end
