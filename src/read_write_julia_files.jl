function _read_julia_file(filename::String)
    file_contents::String = read(filename, String)::String
    block = Meta.parse("begin $(file_contents) end")
    return block
end

function _write_julia_file(filename::String, block::Expr)::Nothing
    always_assert( block.head == :block,
                  "block.head == :block")
    always_assert( block.args isa Vector,
                  "block.args isa Vector")
    rm(filename; force = true, recursive = true)
    open(filename, "w") do io
        for arg in block.args
            if arg isa LineNumberNode
            else
                println(io, arg)
            end
        end
    end
    return nothing
end
