using Base.Iterators
using Rematch

mutable struct Spot
    isSeat :: Bool
    isFull :: Bool
    toSwitch :: Bool

    Spot(spot) = new(spot, false, !spot)
end

function extract_spots(filename)
    open(filename) do f
        data = hcat( split.( readlines(f), "")... )
        spots = permutedims( Spot.( map(==("L"), data) ) )
        return spots
    end
end

function build_neighbours1(spots)
    nghbrs = [Set{Spot}() for _ in spots]
    # tutorial: https://julialang.org/blog/2016/02/iteration/#a_multidimensional_boxcar_filter
    R = CartesianIndices(spots)
    If, Il = first(R), last(R)
    for I in R
        if spots[I].isSeat
            adj = filter(!=(I), max(If, I-If):min(Il, I+If))
            push!(nghbrs[I], [spots[J] for J in adj]...)
        end
    end
    return nghbrs
end

function build_neighbours2(spots)
    nghbrs = [Set{Spot}() for _ in spots]
    R = CartesianIndices(spots)
    tR = Tuple.(R)
    If, Il, I1 = first(R), last(R), oneunit(first(R))
    for I in R

        if spots[I].isSeat
            adj = filter(!=(I), max(If, I-If):min(Il, I+If))
            directions = [J - I for J in adj]

            for d in directions
                # workaround to not iterate on CartesianIndices 
                allVis1 = Iterators.accumulate(+, cycle(d[1]), init=I[1])
                allVis2 = Iterators.accumulate(+, cycle(d[2]), init=I[2])
                allVis = Iterators.zip(allVis1, allVis2)
                isFloor = J -> (J in tR && !spots[J...].isSeat)

                J = CartesianIndex( first( dropwhile( isFloor, allVis ) ) )
                J in R && push!(nghbrs[I], spots[J])
            end
        end

    end
    return nghbrs
end

function switch!(spots, nghbrs, threshold)

    for (s, setNghbr) in zip(spots, nghbrs)
        nbFullNghbrs = count(a.isFull for a in setNghbr)

        s.toSwitch = @match (s.isSeat, s.isFull) begin
            (true, true)  => ( nbFullNghbrs >= threshold )
            (true, false) => ( nbFullNghbrs == 0 )
            (false, _ )   => false
        end
    end

    for s in spots
        s.isFull ⊻= s.toSwitch
    end

end


function print_spots(spots)
    str = ""
    for i in axes(spots, 1)
        for j in axes(spots, 2)
            s = spots[i,j]
            str *= @match (s.isSeat, s.isFull) begin
                (true, true)   => "#"
                (true, false)  => "L"
                (false, false) => "."
                (false, true)  => "?"
                end
        end
        str *= "\n"
    end
    println(str)
end

spots1 = extract_spots("day11_input")
nghbrs1 = build_neighbours1(spots1)
threshold1 = 4
while any(s.toSwitch for s in spots1)
    switch!(spots1, nghbrs1, threshold1)
end
println( count(s.isFull for s in spots1) )

spots2 = extract_spots("day11_input")
nghbrs2 = build_neighbours2(spots2)
threshold2 = 5
while any(s.toSwitch for s in spots2)
    switch!(spots2, nghbrs2, threshold2)
end
println( count(s.isFull for s in spots2) )
