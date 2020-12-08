struct Password
    cmin :: Int
    cmax :: Int
    char :: Char
    pass :: String
end

function match1(p)
    cnb = count(c->(c == p.char), p.pass)
    return (p.cmin <= cnb <= p.cmax)
end

function match2(p)
    return xor( p.pass[p.cmin] == p.char , p.pass[p.cmax] == p.char )
end

function extract_data(filename)
    data = []
    open(filename) do f
        for line in eachline(f)
            vline = split(line, ['-', ' '])
            cmin, cmax = parse.(Int,vline[1:2])
            char, pass = first(vline[3]), vline[4]
            push!(data, Password(cmin, cmax, char, pass))
        end
    end
    return data
end


data = extract_data("day2_input")
println(count(ex1.(data)))
println(count(ex2.(data)))