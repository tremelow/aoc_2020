function extract_data(filename)
    open(filename) do f
        return parse.(Int, readlines(f))
    end
end

data = vcat([0], extract_data("day10_input"))
sort!(data)
push!(data, data[end] + 3)

println(count(diff(data) .== 1)*(count(diff(data) .== 3) + 1) )

data .= data[end:-1:1]
function nb_arrangements(data)
    arr = ones(Int64, size(data))
    for i in 2:length(data)
        j = i-1
        while j > 2 && (data[j-1] - data[i] <= 3)
            j -= 1
        end
        arr[i] = sum(arr[j:i-1])
    end
    return arr[end]
end
nb_arrangements(data)