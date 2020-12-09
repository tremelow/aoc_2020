mutable struct Node
    id :: String
    l  :: Dict{Node,Int}
    p  :: Dict{Node,Int} # parents
    Node() = new("", Dict{String, Int}(), Dict{String, Int}())
    function Node(s::AbstractString)
        new(s, Dict{String, Int}(), Dict{String, Int}())
    end
end

function read_entry(line)
    root, other = split(line, " bags contain ")
    # build dictionary of ids and number for each leaf
    re_leaves = eachmatch(r"(?<nb>\d+)\s(?<id>.*?)\sbag.?\b", other)
    r2l = l -> l[:id] => parse(Int, l[:nb])
    leaves = Dict{String,Int}([r2l(l) for l in re_leaves]... )
    return root, leaves
end

function extract_nodes(filename)
    nodes = Dict{String,Node}()
    open(filename) do f
        for line in eachline(f)
            # get direct relationship between root and leaves
            root, leaves = read_entry(line)

            # if root does not exist, create root
            parent = get!(nodes, root, Node(root))
            
            ## invert the relationship, link 
            for (id, nb) in leaves
                leaf = get!(nodes, id, Node(id))
                push!(parent.l, leaf => nb)
                push!(leaf.p, parent => nb)
            end
        end
    end
    return nodes
end

nodes = extract_nodes("day7_input")

function all_parents(node)
    return union([p.first.id for p in node.p], 
                    [all_parents(p.first) for p in node.p]...)
end
println(length(all_parents(nodes["shiny gold"])))

function sum_leaves(node)
    return 1 + reduce(+, [w*sum_leaves(l) for (l,w) in node.l], init=0)
end
# -1 to not count the shiny gold bag
println(sum_leaves(nodes["shiny gold"])-1)