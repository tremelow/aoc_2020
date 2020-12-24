mutable struct Node
    str   :: AbstractString # (regex) string to match
    args  :: Vector{Vector{Int}} # dependencies
    depth :: Int

    function Node(rules::AbstractString)
        m = match(r"[a-z]+", rules)
        if isnothing(m)
            args = [parse.(Int, split(concat, " "))
                                for concat in split(rules, " | ")]
            return new("", args, 0)
        else
            return new(m.match, [[]], 0)
        end
    end
end


function extract_data(filename)
    nodes = Dict{Int, Node}()
    open(filename) do f
        line = readline(f)
        while !isempty(line)
            id, rules = split(line, ": ")
            push!(nodes, parse(Int, id) => Node(rules))
            line = readline(f)
        end

        return nodes, readlines(f)
    end
end

function set_depths(nodes, id, depth)
    nodes[id].depth = max(nodes[id].depth, depth)
    for rule in filter(!=(id), unique(vcat(nodes[id].args...)))
        set_depths(nodes, rule, depth+1)
    end
end

function set_string(nodes, init_id)
    set_depths(nodes, init_id, 1)
    used_nodes = filter(x -> last(x).depth != 0, collect(nodes))
    sort!(used_nodes, rev=true, by=x -> last(x).depth)
    for (id, _) in used_nodes
        node = nodes[id]
        if node.str == ""
            str = join([join(nodes[arg].str for arg in concat)
                                        for concat in node.args], "|")
            if length(node.args) > 1
                str = "("* str *")"
            end
            nodes[id].str = str
        end
        if id in [8, 11] && id in vcat(node.args...)
            str = join(nodes[arg].str for arg in first(node.args))
            nodes[id].str = "(" * str * ")+"
            #FIXME: the number of occurrences should be the same
        end
    end

    return nodes[init_id].str
end

val_paren(char) = Int(char == "(") - Int(char == ")")

filename = "day19_test2"
nodes, messages = extract_data(filename)
set_string(nodes, 0)
reg = Regex("^"*nodes[0].str*"\$")
println(sum(occursin(reg, m) for m in messages))


#FIXME part 2
nodes, messages = extract_data(filename) # reset problem
nodes[8].args = [[42], [42, 8]]
nodes[11].args = [[42, 31], [42, 11, 31]]
set_string(nodes, 0)
reg = Regex("^"*nodes[0].str*"\$")
# println( accumulate(+, val_paren.(split(nodes[8].str, ""))) )
# println( accumulate(+, val_paren.(split(nodes[11].str, ""))) )
println(sum(occursin(reg, m) for m in messages))
