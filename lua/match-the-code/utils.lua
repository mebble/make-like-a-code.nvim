local function split_string(s)
    -- https://stackoverflow.com/a/32847589/5811761
    local lines = {}
    for line in string.gmatch(s, "[^\r\n]+") do
        table.insert(lines, line)
    end
    return lines
end

local function join_strings(str_table)
    local joined = ""
    for _, line in ipairs(str_table) do
        joined = joined .. line .. "\n"
    end
    return joined
end

return {
    split_string = split_string,
    join_strings = join_strings,
}
