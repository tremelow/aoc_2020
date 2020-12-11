function extract_instructions(filename)
    open(filename) do f
        data = split.(readlines(f))
        return [[inst, parse(Int,cnt)] for (inst, cnt) in data]
    end
end

function follow_instr1(instr)
    seen = Set{Int}()
    line, acc = 1, 0
    while !(line in seen)
        push!(seen, line)
        i = instr[line]
        line += (i[1] == "jmp") ? i[2] : 1
        acc  += (i[1] == "acc") ? i[2] : 0
    end
    return acc
end

function follow_instr2(instr)
    modif = findfirst(i -> (i[1] != "acc"), instr)
    acc = 0
    found = false
    while !found
        orig_instr = instr[modif][1]
        instr[modif][1] = (orig_instr == "jmp") ? "nop" : "jmp"

        seen = Set{Int}()
        line, acc = 1, 0
        while !(line in seen)
            push!(seen, line)
            i = instr[line]
            line += (i[1] == "jmp") ? i[2] : 1
            acc  += (i[1] == "acc") ? i[2] : 0

            if line > length(instr)
                found = true
                break
            end
        end

        instr[modif][1] = orig_instr
        modif = findnext(i -> (i[1] != "acc"), instr, modif+1)
    end
    return acc
end

instr = extract_instructions("day8_input")
println(follow_instr1(instr))
println(follow_instr2(instr))