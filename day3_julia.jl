function cnt_trees(d, slope)
    I,J = size(slope)

    ii = 1:d[1]:I
    jj = mod.( ((1:length(ii)) .- 1)*d[2], J ) .+ 1

    return count(map((i,j)->slope[i,j], ii, jj))
end

f = readlines("day3_input")
slope = transpose( map( x->(x=='#'), hcat(collect.(f)...) ) )

println(cnt_trees((1,3), slope))
dirs = [(1,1), (1,3), (1,5), (1,7), (2,1)]
println( prod( [ cnt_trees(d, slope) for d in dirs ] ) )