"""
    data = extract_plane(filename)

Returns boolean 2D matrix containing data.
"""
function extract_plane(filename)
    open(filename) do f
        data = hcat( split.( readlines(f), "")... )
        cells = permutedims( map(==("#"), data) )
        return cells
    end
end

function game_of_life(cells, nb_iter, dim)
    ## INITIALISATION
    dims = (size(cells, i) for i in 1:dim) .+ 2*nb_iter
    lattice = repeat( [false], dims... )
    around = repeat( [0], dims... ) # number of active cells around
    lattice[map(i -> (1:i) .+ nb_iter, dims .- 2*nb_iter)...] .= cells
    coords = CartesianIndices(lattice)

    ## ITERATE
    for _ in 1:nb_iter
        around  .= update_around!(lattice, around, coords)
        lattice .= update_lattice!(lattice, around, coords)
    end
    return lattice
end

function update_around!(lattice, around, coords)
    around *= 0 # reset adjacency
    If, Il = first(coords), last(coords)
    # oneunit(first(active)) should work but only from Julia 1.1
    I1 = CartesianIndex(Tuple(1 for _ in Tuple(If)))
    # loop on active cells
    for (I, s) in Iterators.filter(last, zip(coords, lattice))
        # max(If, I-I1):min(Il, I+I1) in Julia 1.1
        box = ( f:l for (f,l) in zip(Tuple(max(If, I-I1)), Tuple(min(Il, I+I1))) )
        adj = filter(J -> (J != I), CartesianIndices(Tuple(box))) # nearby cells
        around[adj] .+= 1 # one more active cell for all neighbours
    end
    return around
end

function update_lattice!(lattice, around, coords)
    for I in coords
        if lattice[I]
            lattice[I] = (2 <= around[I] <= 3)
        else
            lattice[I] = (around[I] == 3)
        end
    end
    return lattice
end


cells = extract_plane("day17_input")
println(count(game_of_life(cells, 6, 3)))
println(count(game_of_life(cells, 6, 4)))
