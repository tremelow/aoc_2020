function extract_groups(filename)
    groups = []
    open(filename) do f
        g = [] # current group
        for line in eachline(f)
            if isempty(line)
                push!(groups, g)
                g = []
            else
                push!(g, line)
            end
        end
        push!(groups, g)
    end
    return groups
end

score1 = g -> length( unique( vcat( split.(g, "")... ) ) )
score2 = g -> length( intersect( hcat( split.(g, "") )... ) )

groups = extract_groups("day06_input")
println(sum(score1.(groups)))
println(sum(score2.(groups)))