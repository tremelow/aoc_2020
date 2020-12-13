function extract_data(filename)
    open(filename) do f
        treat_line = s -> (first(s), parse(Int, s[2:end]))
        return treat_line.(readlines(f))
    end
end

function follow_instructions1(data)
    p, d = [0, 0], [1, 0] # position, direction
    rot90 = [0 -1 ; 1 0]

    dirs = Dict('E' => [1, 0], 'N' => [0, 1], 'W' => [-1, 0], 
                'S' => [0, -1], 'F' => d)
    rots = Dict('L' => rot90, 'R' => -rot90)
    turn = inst -> (inst in ['L', 'R'])

    for (inst, dist) in data
        d .= turn(inst) ? (rots[inst]^div(dist, 90))*d : d
        p += turn(inst) ? [0, 0] : dist*dirs[inst]
    end
    return p
end

function follow_instructions2(data)
    rot90 = [0 -1 ; 1 0]

    p, w = [0, 0], [10, 1] # position, waypoint
    dirs = Dict('E' => [1, 0], 'N' => [0, 1], 'W' => [-1, 0], 
                'S' => [0, -1])
    rots = Dict('L' => rot90, 'R' => -rot90)

    for (inst, dist) in data
        if inst in ['L', 'R']
            w .= rots[inst]^div(dist, 90) * w
        elseif inst == 'F'
            p += dist*w
        else
            w += dist*dirs[inst]
        end
    end
    return p
end

data = extract_data("day12_input")

println(sum(map(abs, follow_instructions1(data))))
println(sum(map(abs, follow_instructions2(data))))
