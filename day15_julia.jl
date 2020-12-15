## My input: 15,5,1,4,7,0
start = parse.( Int, split("15,5,1,4,7,0" , ",") )

## Initialise
saidTurns = Dict{Int, Tuple{Int,Int}}()
for (i, fstSaid) in enumerate(start)
    # assume that every number in start is unique
    push!(saidTurns, fstSaid => (i, i))
end

## Loop
function loop_game(saidTurns, start, nbTurns)
    lstSaid = start[end]
    whenSaid = saidTurns[lstSaid]
    println(whenSaid)
    for i in length(start)+1:nbTurns
        lstSaid = whenSaid[1] - whenSaid[2]
        whenSaid = ( i, get!(saidTurns, lstSaid, (i,i))[1] )
        push!(saidTurns, lstSaid => whenSaid )
    end
    return lstSaid
end

nbTurns = 30000000 # 2020 for part 1, 30000000 for part 2
lstSaid = loop_game(saidTurns, start, nbTurns) 
println(lstSaid)