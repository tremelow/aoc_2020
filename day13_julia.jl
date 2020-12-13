function extract_data(filename)
    open(filename) do f
        timestamp = parse(Int,readline(f))
        busses = split(readline(f), ",")
        return timestamp, busses
    end
end

"""
    x = solve_congruences(mods, res)

Solve system of congruences mod(x, n) = a for (n,a) in zip(mods,res)
with the existence construction method using Bezout coefficients. This
is the unique solution x between 0 and N = prod(n for n in mods), 
meaning it is the smallest positive integer solution. 
https://en.wikipedia.org/wiki/Chinese_remainder_theorem#Using_the_existence_construction

Right now, this implementation uses BigInts to avoid overflows, but a 
recursive implementation may be possible. Indeed, here at iteration k+1, 
n1 stores mods[1]*...*mods[k] while n2 is much smaller at mods[k+1]. 
Splitting the problem into solving on two subsets mod1, res1 on one side 
and mod2, res2 on the other would be more stable. The method would 
return a1 = mod(x, prod(mod1)) (resp. a2 with mod2), allowing the 
computation of mod(x, prod(mods)). However, finding suitable subsets 
(which minimise prod(mod1) - prod(mod2)) is somewhat tricky. 
"""
function solve_congruences(mods, res)
    mods, res = BigInt.(mods), BigInt.(res)
    res .= broadcast(mod, res, mods)
    n1, a1 = mods[1], res[1]
    x = 0
    for (n2, a2) in zip(mods[2:end], res[2:end])
        _, m1, m2 = gcdx(n1, n2)
        x = a2*m1*n1 + a1*m2*n2
        n1, a1 = n1*n2, mod(x, n1*n2)
    end
    N = prod(mods)
    return mod(x, N)
end

t0, bus = extract_data("day13_input")
valBus = parse.(Int, filter(!=("x"), bus))

tMin, indMin = findmin(map(n -> (n - mod(t0, n)), valBus))
println(valBus[indMin]*tMin)

zipBus = collect( Iterators.filter(z->(z[2] != "x"), enumerate(bus)) )
delays, busIds = 1 .- first.(zipBus), parse.(Int, last.(zipBus))
t = solve_congruences(busIds, delays)
println(t)