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

local function strip(str)
    local stripped_end = string.gsub(str, '%s+$', '')
    local stripped_begin = string.gsub(stripped_end, '^%s+', '')
    return stripped_begin
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

    local file_ext = strip(string.sub(contents, 1, sent1_start))
    local raw_file = strip(string.sub(contents, sent1_end, sent2_start))
    local raw_file_parent = strip(string.sub(contents, sent2_end))

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
        return contents
    end
    error()
end

local function get_languages()
    local path = 'linguist-languages.json'
    local ok, contents = pcall(s.lookup_cache, path, function()
        local ok, languages = pcall(g.fetch, 'https://raw.githubusercontent.com/blakeembrey/language-map/main/languages.json')
        if not ok then
            error()
        end
        return languages
    end)
    if not ok then
        error()
    end

    return vim.json.decode(contents)
end

local function extension_to_language(languages_tbl, extension)
    for lang_name, lang_data in pairs(languages_tbl) do
        if lang_data.extensions then
            for _, ext in pairs(lang_data.extensions) do
                if ext == '.'..extension then
                    return string.lower(lang_name)
                end
            end
        end
    end
    return nil
end

return {
    get_languages = get_languages,
    get_snippets = get_snippets,
    parse_contents = parse_contents,
    extension_to_language = extension_to_language,
}
