function extract_data(filename)
    cond = Dict{String, Tuple{UnitRange{Int}, UnitRange{Int}}}()
    my_ticket = []
    tickets = []
    open(filename) do f
        ## Extract conditions
        while true
            line = readline(f)
            isempty(line) && break # do ... while 

            field_name, conditions = split(line, ": ")
            cond1, cond2 = split(conditions, " or ")
            a1, b1 = parse.(Int, split(cond1, "-"))
            a2, b2 = parse.(Int, split(cond2, "-"))
            push!(cond, field_name => (a1:b1, a2:b2))
        end

        ## Extract my ticket
        if startswith(readline(f), "your ticket")
            my_ticket = parse.(Int, split(readline(f), ","))
        end

        ## Extract other tickets
        readline(f) # empty line
        if startswith(readline(f), "nearby tickets")
            while !eof(f)
                push!(tickets, parse.(Int, split(readline(f), ",")) )
            end
        end

        return cond, my_ticket, tickets
    end
    return cond, my_ticket, tickets
end

function isin(r, val)
    return ((val in r[1]) || (val in r[2]))
end

function error_rate(ticket, cond)
    error = 0
    for val in ticket
        if !any(isin(r, val) for r in values(cond))
            error += val
        end
    end
    return error
end

function find_possible_positions(fields, cond)
    pos = Dict(f => [0] for f in keys(cond))
    is_pos = (e, r) -> all(isin(r, val) for val in e)
    for (f, r) in cond
        f_indices = findall([is_pos(entries, r) for entries in fields])
        push!(pos, f => f_indices)
    end
    return pos
end

cond, my_ticket, tickets = extract_data("day16_input")
println("Error rate: ", sum(error_rate(t, cond) for t in tickets))

valid_tickets = filter(t->(error_rate(t,cond) == 0), tickets)
merged_tickets = hcat(valid_tickets...)
unordered_fields = [merged_tickets[i,:] for i in axes(merged_tickets, 1)]

possible_positions = find_field_positions(unordered_fields, cond)
## ^ need to clean up possible_positions