function extract_data(filename)
    open(filename) do f
        return parse.(Int, readlines(f))
    end
end

function ex1(data, tgt)
    for (n1, n2) in Iterators.product(data, data)
        n1 + n2 == tgt && return n1*n2
    end
    return -1
end

function ex2(data, tgt)
    for (n1,n2,n3) in Iterators.product(data, data, data)
        n1 + n2 + n3 == tgt && return n1*n2*n3
    end
    return -1
end

data = extract_data("day01_input")
ex1(data, 2020)
ex2(data, 2020)