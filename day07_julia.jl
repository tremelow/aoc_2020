mutable struct Node
    prv :: Dict{Node,Int} # origins with weights
    nxt :: Dict{Node,Int} # destinations with weigths
    Node() = new(Dict{String, Int}(), Dict{String, Int}())
end

function read_entry(line)
    root, other = split(line, " bags contain ")
    # build dictionary of ids and weight for each destination
    re_dests = eachmatch(r"(?<nb>\d+)\s(?<id>.*?)\sbag.?\b", other)
    re2node = n -> n[:id] => parse(Int, n[:nb])
    dests = Dict{String,Int}( [re2node(n) for n in re_dests]... )
    return root, dests
end

function extract_graph(filename)
    nodes = Dict{String,Node}()
    open(filename) do f
        for line in eachline(f)
            # get direct relationship between root and dest
            root, dests = read_entry(line)

            # if root does not exist, create root
            orig = get!(nodes, root, Node())
            
            ## invert the relationship, link 
            for (id, nb) in dests
                dest = get!(nodes, id, Node())
                push!(orig.nxt, dest => nb)
                push!(dest.prv, orig => nb)
            end
        end
    end
    return nodes
end

nodes = extract_graph("day07_input")

function all_origins(node)
    return union([p for (p,_) in node.prv], 
                    [all_origins(p) for (p,_) in node.prv]...)
end
println(length(all_origins(nodes["shiny gold"])))

function sum_dests(node)
    return reduce(+, [w*sum_dests(n) for (n,w) in node.nxt], init=1)
end
# -1 to not count the shiny gold bag
println(sum_dests(nodes["shiny gold"])-1)