local g = require('make-like-a-code.github')

local sentinal = '\n--mlac--\n'
local std_dir = ('%s/make-like-a-code'):format(vim.fn.stdpath('data'))
local ok, msg, code = os.execute('mkdir -p ' .. std_dir)
if not ok then
    print(('Creating snippets directory failed: [%s] [%s]'):format(code, msg))
    os.exit(1)
end

local function format_path(repo, sha)
    local username = string.match(repo, '^([%a%d]+)/')
    local projectname = string.match(repo, '/([%a%d]+)$')

    return ('%s/%s-%s-%s'):format(std_dir, username, projectname, sha)
end

local function format_contents(file_extension, raw_file, raw_file_parent)
    return ('%s%s%s%s%s'):format(file_extension, sentinal, raw_file, sentinal, raw_file_parent)
end

local function parse_contents(contents)
    local sent1_start, sent1_end = string.find(contents, sentinal, 1, true)
    if sent1_start == nil or sent1_end == nil then
        error()
    end


    local sent2_start, sent2_end = string.find(contents, sentinal, sent1_end, true)
    if sent2_start == nil or sent2_end == nil then
        error()
    end

    local file_ext = string.sub(contents, 1, sent1_start)
    local raw_file = string.sub(contents, sent1_end, sent2_start)
    local raw_file_parent = string.sub(contents, sent2_end)

    return file_ext, raw_file, raw_file_parent
end

local function get_snippets(repo, sha)
    local path = format_path(repo, sha)
    local f = io.open(path, 'r')
    if f ~= nil then
        local contents = f:read('*a')
        f:close()
        return parse_contents(contents)
    end

    local ok, ext, full_sha, raw_file, raw_file_parent = pcall(g.fetch_snippets, repo, sha)
    if not ok then
        error()
    end

    path = format_path(repo, full_sha)
    f = io.open(path, 'w')
    if f == nil then
        error()
    end

    local contents = format_contents(ext, raw_file, raw_file_parent)
    f:write(contents)
    f:close()

    return ext, raw_file, raw_file_parent
end

return {
    get_snippets = get_snippets,
}
