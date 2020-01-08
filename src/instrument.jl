# This is the generic fallback
# function instrument(filename::String,
#                     expr::Expr,
#                     ::Val,
#                     lnn::LineNumberNode;
#                     prepend_tracker::Bool = true)
#     return insert_prepended_tracker(filename,
#                                     expr,
#                                     lnn;
#                                     prepend_tracker = prepend_tracker)
# end

function instrument(filename::String,
                    lnn_1::LineNumberNode,
                    lnn_2::LineNumberNode;
                    prepend_tracker::Bool = true)
    always_assert(lnn_1 == lnn_2, "lnn_1 == lnn_2")
    return lnn_1
end

function instrument(filename::String,
                    expr::Expr;
                    prepend_tracker::Bool = true)
    return instrument(filename,
                      expr,
                      Val(expr.head);
                      prepend_tracker = prepend_tracker)
end

function instrument(filename::String,
                    expr::Expr,
                    lnn::LineNumberNode;
                    prepend_tracker::Bool = true)
    return instrument(filename,
                      expr,
                      Val(expr.head),
                      lnn;
                      prepend_tracker = prepend_tracker)
end

function instrument(filename::String,
                    expr::Expr,
                    ::Val{:block};
                    prepend_tracker::Bool = true)
    original_args = expr.args
    always_assert(original_args isa Vector, "original_args isa Vector")
    if length(original_args) == 0
        return expr
    end
    always_assert(length(original_args) >= 1, "length(original_args) >= 1")
    always_assert( original_args[1] isa LineNumberNode,
                  "original_args[1] isa LineNumberNode")
    return instrument(filename,
                      expr,
                      Val(:block),
                      original_args[1];
                      prepend_tracker = prepend_tracker)
end

function instrument(filename::String,
                    expr::Expr,
                    ::Val{:block},
                    lnn::LineNumberNode;
                    prepend_tracker::Bool = true)
    original_args = expr.args
    num_args = length(original_args)
    arg_to_lnn = Vector{LineNumberNode}(undef, num_args)
    current_lnn = lnn
    arg_to_lnn[1] = current_lnn
    for i = 1:num_args
        if original_args[i] isa LineNumberNode
            current_lnn = original_args[i]
        end
        arg_to_lnn[i] = current_lnn
    end
    new_args = Vector{Any}(undef, num_args)
    for i = 1:num_args
        new_args[i] = instrument(filename, original_args[i], arg_to_lnn[i])
    end
    return insert_prepended_tracker(filename,
                                    Expr(:block, new_args...),
                                    lnn;
                                    prepend_tracker = prepend_tracker)
end

function instrument(filename::String,
                    expr::Expr,
                    ::Val{:function},
                    lnn::LineNumberNode;
                    prepend_tracker::Bool = true)
    original_args = expr.args
    num_args = length(original_args)
    new_args = Vector{Any}(undef, num_args)
    new_args[1] = original_args[1]
    for i = 2:num_args
        new_args[i] = instrument(filename, original_args[i], lnn)
    end
    return insert_prepended_tracker(filename,
                                    Expr(:function, new_args...),
                                    lnn;
                                    prepend_tracker = prepend_tracker)
end

function instrument(filename::String,
                    expr::Expr,
                    ::Val{:if},
                    lnn::LineNumberNode;
                    prepend_tracker::Bool = true)
    original_args = expr.args
    num_args = length(original_args)
    new_args = Vector{Any}(undef, num_args)
    new_args[1] = instrument(filename,
                             original_args[1],
                             lnn;
                             prepend_tracker = false)
    for i = 2:num_args
        new_args[i] = instrument(filename,
                                 original_args[i],
                                 lnn;
                                 prepend_tracker = prepend_tracker)
    end
    return insert_prepended_tracker(filename,
                                    Expr(:if, new_args...),
                                    lnn;
                                    prepend_tracker = prepend_tracker)
end

function instrument(filename::String,
                    expr::Expr,
                    ::Val{:||},
                    lnn::LineNumberNode;
                    prepend_tracker::Bool = true)
    original_args = expr.args
    num_args = length(original_args)
    new_args = Vector{Any}(undef, num_args)
    for i = 1:num_args
        new_args[i] = instrument(filename, original_args[i], lnn)
    end
    return insert_prepended_tracker(filename,
                                    Expr(:||, new_args...),
                                    lnn;
                                    prepend_tracker = prepend_tracker)
end

function instrument(filename::String,
                    expr::Expr,
                    ::Val{:call},
                    lnn::LineNumberNode;
                    prepend_tracker::Bool = true)
    original_args = expr.args
    num_args = length(original_args)
    new_args = Vector{Any}(undef, num_args)
    new_args[1] = original_args[1]
    for i = 2:num_args
        new_args[i] = instrument(filename, original_args[i], lnn)
    end
    return insert_prepended_tracker(filename,
                                    Expr(:call, new_args...),
                                    lnn;
                                    prepend_tracker = prepend_tracker)
end

function instrument(filename::String,
                    sym::Symbol,
                    lnn::LineNumberNode)
    return sym
end

function instrument(filename::String,
                    str::AbstractString,
                    lnn::LineNumberNode)
    return str
end

function instrument(filename::String,
                    n::Number,
                    lnn::LineNumberNode)
    return n
end

function instrument(filename::String,
                    expr::Expr,
                    ::Val{:return},
                    lnn::LineNumberNode;
                    prepend_tracker::Bool = true)
    original_args = expr.args
    num_args = length(original_args)
    new_args = Vector{Any}(undef, num_args)
    for i = 1:num_args
        new_args[i] = instrument(filename, original_args[i], lnn)
    end
    return insert_prepended_tracker(filename,
                                    Expr(:return, new_args...),
                                    lnn;
                                    prepend_tracker = prepend_tracker)
end
