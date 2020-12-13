function compute_id(code)
    to_bin = c -> "$(Int(c in ['B', 'R']))"
    bin = "0b"*join(map(to_bin, collect.(code)))
    value = parse.(Int, bin)
    return value
end

data = readlines("day05_input")
ids = compute_id.(data)
println(maximum(ids))

sort!(ids)
println(ids[findfirst(x->(x==2), diff(ids))] + 1)