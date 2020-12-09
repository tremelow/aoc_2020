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
valid1 = p -> all( x -> (x in keys(p)) , req_keys)
println(count(valid1, data))


function valid2(p)
    return valid1(p) && 
            (1920 <= parse(Int,p["byr"]) <= 2002) &&
            (2010 <= parse(Int,p["iyr"]) <= 2020) &&
            (2020 <= parse(Int,p["eyr"]) <= 2030) &&
            (   ( !isnothing(match(r"\d{3}cm", p["hgt"])) && 
                    150 <= parse.(Int, p["hgt"][1:3]) <= 193) ||
                ( !isnothing(match(r"\d{2}in", p["hgt"])) &&
                    59 <= parse.(Int, p["hgt"][1:2]) <= 76) 
            ) && 
            !isnothing(match(r"#[0-9a-f]{6}$", p["hcl"])) &&
            (p["ecl"] in valid_ecl) && 
            !isnothing(match(r"^\d{9}$", p["pid"]))
end

println(count(valid2, data))
