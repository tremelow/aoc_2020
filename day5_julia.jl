function compute_id(code)
    to_bin = c -> "$(Int(c in ['B', 'R']))"
    bin = "0b"*prod(map(to_bin, collect.(code)))
    value = parse.(Int, bin)
    return value
end

data = readlines("day5_input")
println(maximum(ids))

sort!(ids)
println(ids[findfirst(x->(x==2), diff(ids))] + 1)