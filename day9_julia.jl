using Base.Iterators

function extract_data(filename)
    open(filename) do f
        return parse.(Int, readlines(f))
    end
end

data = extract_data("day9_input")
stencil = 25

function valid(val, preamble)
    for (n1, n2) in product(preamble, preamble)
        (n1 != n2) && (n1 + n2 == val) && return true
    end
    return false
end

function first_invalid(data, stencil)
    preamble = [0 for _ in 1:stencil]
    for (i,val) in enumerate(data[stencil+1:end])
        preamble .= data[(1:stencil).+(i-1)]
        !valid(val, preamble) && return val
    end
    return -1
end

key = first_invalid(data, stencil)
println(key)

function contig_set(data, tgt)
    i = 0
    dataSum = filter(<=(tgt), accumulate(+, drop(data, i)))
    while last(dataSum) < tgt
        i += 1
        dataSum = filter(<=(tgt), accumulate(+, drop(data, i)))
    end
    
    return data[( 1:length(dataSum) ) .+ i]
end
set = contig_set(data, key)
println(minimum(set) + maximum(set))