using Rematch

function new_passport(entry)
    p = Dict{String,Any}()
    for (key, val) in split.(split(entry), ":")
        if key != "cid"
            p[key] = val
        end
    end
    return p
end

function extract_passports(filename)
    data = []
    open(filename) do f
        entry = ""
        for line in eachline(f)

            if isempty(line)
                push!(data, new_passport(entry))
                entry = ""
            else
                entry *= line*" "
            end

        end
        # last entry
        push!(data, new_passport(entry))
    end
    return data
end

req_keys = ["byr", "iyr", "eyr", "hgt", "hcl", "ecl", "pid"]
valid_ecl = ["amb", "blu", "brn", "gry", "grn", "hzl", "oth"]

data = extract_passports("day4_input")
valid1 = p -> all( x -> (x ∈ keys(p)) , req_keys)
println(count(valid1, data))



function valid_entry(e)
    @match e[1] begin
        "byr" => (1920 <= parse(Int,e[2]) <= 2002)
        "iyr" => (2010 <= parse(Int,e[2]) <= 2020)
        "eyr" => (2020 <= parse(Int,e[2]) <= 2030)
        "hgt" => ( ( !isnothing(match(r"\d{3}cm", e[2])) && 
                        150 <= parse.(Int, e[2][1:3]) <= 193) ||
                   ( !isnothing(match(r"\d{2}in", e[2])) &&
                        59 <= parse.(Int, e[2][1:2]) <= 76) 
                )
        "hcl" => !isnothing(match(r"#[0-9a-f]{6}$", e[2]))
        "ecl" => (e[2] ∈ valid_ecl)
        "pid" => !isnothing(match(r"^\d{9}$", e[2]))
        "cid" => true
        _     => false
    end
end
valid2 = p -> valid1(p) && all( valid_entry.( collect(p) ) )
println(count(valid2, data))
