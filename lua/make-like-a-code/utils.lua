local function split_string(s)
    -- https://stackoverflow.com/a/32847589/5811761
    -- https://stackoverflow.com/a/832414/5811761
    local lines = {""}
    for char in string.gmatch(s, ".") do
        if char == "\n" then
           table.insert(lines, "")
        else
            local last_pos = (#lines == 0) and 1 or #lines
            local last_line = lines[last_pos] or ""
            lines[last_pos] = last_line .. char
        end
    end
    return lines
end

local function join_strings(str_table)
    return table.concat(str_table, "\n")
end

return {
    split_string = split_string,
    join_strings = join_strings,
}
