function instrument(filename::String,
                    expr::Expr,
                    ::Val{:function},
                    lnn::LineNumberNode)
    # original_args = expr.args
    # num_args = length(original_args)
    # new_args = Vector{Any}(undef, num_args)
    # new_args[1] = original_args[1]
    # for i = 2:num_args
    #     new_args[2] = instrument(filename,
    #                              original_args[2],
    #                              lnn)
    # end
    # return [tracker(filename, lnn),
    #         Expr(:function, new_args...)]
end

function instrument(filename::String,
                    expr::Expr,
                    ::Val{:block},
                    lnn::LineNumberNode)
    # original_args = expr.args
    # num_args = length(original_args)
    # arg_to_lnn = Vector{LineNumberNode}(undef,
    #                                     num_args)
    # current_lnn = lnn
    # arg_to_lnn[1] = current_lnn
    # for i = 1:num_args
    #     if original_args[i] isa LineNumberNode
    #         current_lnn = original_args[i]
    #     end
    #     arg_to_lnn[i] = current_lnn
    # end
    # new_args = Vector{Any}(undef, 0)
    # for i = 1:num_args
    #     args_to_add = instrument(filename,
    #                              original_args[i],
    #                              arg_to_lnn[i])
    #     append!(new_args, args_to_add)
    # end
    # return Expr(:block, new_args...)
end

function instrument(filename::String,
                    expr::Expr,
                    ::Val{:block})
    # original_args = expr.args
    # always_assert( original_args isa Vector,
    #               "original_args isa Vector")
    # if length(original_args) == 0
    #     return expr
    # end
    # always_assert( length(original_args) >= 1,
    #               "length(original_args) >= 1")
    # always_assert( original_args[1] isa LineNumberNode,
    #               "original_args[1] isa LineNumberNode")
    # return instrument(filename,
    #                   expr,
    #                   Val(:block),
    #                   original_args[1])
end

function instrument(filename::String,
                    lnn_1::LineNumberNode,
                    lnn_2::LineNumberNode)
    # always_assert( lnn_1 == lnn_2,
    #               "lnn_1 == lnn_2")
    # return [lnn_1]
end

function instrument(filename::String,
                    expr::Expr)
    # return instrument(filename,
    #                   expr,
    #                   Val(expr.head))
end

function instrument(filename::String,
                    expr::Expr,
                    lnn::LineNumberNode)
    # return instrument(filename,
    #                   expr,
    #                   Val(expr.head),
    #                   lnn)
end
