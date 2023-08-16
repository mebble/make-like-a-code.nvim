local std_dir = ('%s/make-like-a-code'):format(vim.fn.stdpath('data'))
local ok, msg, code = os.execute('mkdir -p ' .. std_dir)
if not ok then
    print(('Creating snippets directory failed: [%s] [%s]'):format(code, msg))
    os.exit(1)
end

local function lookup_cache(resource, original)
    local path = ('%s/%s'):format(std_dir, resource)
    local f = io.open(path, 'r')
    if f ~= nil then
        local contents = f:read('*a')
        f:close()
        return contents
    end

    local contents
    ok, contents = pcall(original, resource)
    if not ok then
        error()
    end

    f = io.open(path, 'w')
    if f == nil then
        error()
    end

    f:write(contents)
    f:close()

    return contents
end

return {
    lookup_cache = lookup_cache,
}
