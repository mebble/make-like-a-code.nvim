local g = require('make-like-a-code.github')
local s = require('make-like-a-code.storage')

local sentinal = '\n--mlac--\n'

local function format_resource_name(repo, sha)
    local username = string.match(repo, '^([%a%d]+)/')
    local projectname = string.match(repo, '/([%a%d]+)$')

    return ('%s-%s-%s'):format(username, projectname, sha)
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
    local path = format_resource_name(repo, sha)
    local ok, contents = pcall(s.lookup_cache, path, function()
        local ok, ext, _, raw_file, raw_file_parent = pcall(g.fetch_snippets, repo, sha)
        if not ok then
            error()
        end
        local contents = format_contents(ext, raw_file, raw_file_parent)
        return contents
    end)
    if ok then
        return parse_contents(contents)
    end
    error()
end

return {
    get_snippets = get_snippets,
}
