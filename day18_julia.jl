using Rematch

function extract_equations(filename::String)
    open(filename) do f
        # split every special character without splitting number
        sep = r"((?=\w+)\b)|(?=\W)\s?"
        return map(line -> split(line, sep), readlines(f) )
    end
end

function custom_parse1(expr)
    op = Dict("+" => +, "*" => *)
    if length(expr) == 1
        return parse(Int, first(expr))
    else
        left_expr, idx_sym = sub_expr(expr)
        left_term = custom_parse1(left_expr)
        while idx_sym < length(expr)
            symbol = expr[idx_sym]
            right_expr, incr_sym = sub_expr(expr[idx_sym+1:end])
            idx_sym += incr_sym
            right_term = custom_parse1(right_expr)
            left_term = op[symbol](left_term, right_term)
        end
        return left_term
    end

end

val_paren(char) = Int(char == "(") - Int(char == ")")

function sub_expr(expr)
    if first(expr) != "("
        return first(expr), 2
    else
        idx = findfirst(==(0), accumulate(+, val_paren.(expr)) )
        (idx == nothing) && @error "Panik: no closing paren found."
        return expr[2:idx-1], idx+1
    end
end


function custom_parse2_cheese(expr)
    expr .= replace(expr, "+" => "*", "*" => "+")
    e = Meta.parse(join(expr))
    e = swap_symbol(e)
    return eval(e)
end

swap_symbol(n::Int64)  = n
swap_symbol(s::Symbol) = (s == :+) ? :* : :+
function swap_symbol(e::Expr)
    for i in eachindex(e.args)
        e.args[i] = swap_symbol(e.args[i])
    end
    return e
end

eqs = extract_equations("day18_input")

println(sum(custom_parse1.(eqs)))
println(sum(custom_parse2_cheese.(eqs)))
