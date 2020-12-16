function extract_mem(filename, output_routine)
    mem = Dict{Int,Int}()
    open(filename) do f
        mask = "X"
        for line in eachline(f)
            inst, val = split(line, " = ")
            if inst == "mask"
                mask = val
            else
                slot = parse(Int, match(r"\d+", inst).match )
                val = parse(Int, val)
                push!( mem, output_routine(mask, slot, val)... )
            end
        end
        return mem
    end
    return mem
end

function compute_output1(mask, slot, val)
    and = parse(Int, "0b"*replace(mask, "X" => "1") )
    or  = parse(Int, "0b"*replace(mask, "X" => "0") )
    new_val = (val & and) | or
    return [slot => new_val]
end

function compute_output2(mask, slot, val)
    # new_slot is 1 if mask is 1 or X, and unchanged otherwise
    new_slot = parse(Int, "0b"*replace(mask, "X" => "1")) | slot

    # create array of mask with 0s replaced by 1s
    arr_mask = replace(split(mask, ""), "0" => "1")
    indX, nbX = findall(==('X'), mask), count(==('X'), mask)

    slots = []
    for i in 1:(1 << nbX)
        # replace Xs by 0 or 1 in depending on bit writing of i
        arr_mask[indX] .= split(string(i-1, base=2, pad=nbX), "")
        # because new_slot has 1s where Xs are, & replaces these bits 
        # by those of arr_mask
        push!(slots, new_slot & parse(Int, "0b"*join(arr_mask)) )
    end

    return [s => val for s in slots]

    """
    Remark: this procedure can be made fairly more efficient by 
    1) using a struct Mask which would store "and" and "or" (of 
    compute_output1), as well as storing every "arr_mask"
    2) using bit shifts to compute "arr_mask"
    """
end


mem1 = extract_mem("day14_input", compute_output1)
println( sum(values(mem1)) )
mem2 = extract_mem("day14_input", compute_output2)
println( sum(values(mem2)) )
