const DIRECTIONS = Set([:N, :W, :S, :E])
const CORNERS = Set([(:N, :W), (:W, :S), (:S, :E), (:E, :N)])

Config = Dict{Symbol, Vector{Bool}}
Tile = Set{Config}

function extract_tiles(args)
    body
end

function make_tile(C::Config)
    T = Tile()
    for _ in 1:2
        for _ in 1:4
            push!(T, copy(C))
            rotate!(C)
        end
        flip!(C)
    end
    return T
end

function rotate!(C::Config)
    D = Dict(:N => C[:E], :W => reverse(C[:N]),
             :S => C[:W], :E => reverse(C[:S]) )
    for d in DIRECTIONS
        C[d] .= D[d]
    end
end

function flip!(D::Dict{Symbol, Vector{Bool}})
    D = Dict(:N => reverse(C[:N]), :W => C[:E],
             :S => reverse(C[:S]), :E => C[:W] )
    for d in DIRECTIONS
        C[d] .= D[d]
    end
end

C = Config(:N => [false, false], :W => [false, true],
           :S => [true, false],  :E => [true, true])
T = make_tile(C)

println(T)
