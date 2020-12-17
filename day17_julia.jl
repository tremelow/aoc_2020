"""
    active = extract_plane(filename)

Returns the set of coordinates where active cells are.
"""
function extract_plane(filename)
    open(filename) do f
        data = hcat( split.( readlines(f), "")... )
        cells = permutedims( map(==("#"), data) )
        R = CartesianIndices(cells)
        return filter(I -> cells[I], R)
    end
end

function update!(active)
    # tutorial: https://julialang.org/blog/2016/02/iteration/#a_multidimensional_boxcar_filter
    # oneunit(first(active)) should work but only from Julia 1.1
    I1 = CartesianIndex(Tuple(1 for _ in Tuple(first(active))))
    cells = Dict(I => 0 for I in active)
    # (I-I1):(I+I1) from Julia 1.1
    around = I -> Tuple( f:l for (f,l) in zip(Tuple(I-I1), Tuple(I+I1)) )
    for I in active
        adj = filter( J -> (J != I), CartesianIndices(around(I)) )
        for J in adj
            get!(cells, J, 0)
            cells[J] += 1
        end
    end

    activate = I -> (cells[I] == 3)
    to_activate = filter( activate, setdiff(keys(cells), active) )
    filter!(I -> (2 <= cells[I] <= 3), active )
    push!(active, to_activate... )
end


active = extract_plane("day17_input")
active1 = Set(CartesianIndex(I, 0) for I in active)
active2 = Set(CartesianIndex(I, 0, 0) for I in active)
for _ in 1:6
    update!(active1)
    update!(active2)
end
println(length(active1))
println(length(active2))
