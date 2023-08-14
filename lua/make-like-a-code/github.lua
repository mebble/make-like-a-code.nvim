local curl = require('plenary.curl')

local function commit_url(repo, sha)
    return "https://api.github.com/repos/" .. repo .. "/commits/" .. sha
end

local function raw_file_url(repo, sha, filename)
    return "https://raw.githubusercontent.com/" .. repo .. "/" .. sha .. "/" .. filename
end

local function fetch(url)
    local res = curl.get(url)
    if res.status ~= 200 then
        error()
    end
    return res.body
end

local function fetch_raw_files(repo, file_name, sha, parent_sha)
    local ok, raw_file = pcall(fetch, raw_file_url(repo, sha, file_name))
    if not ok then
        error()
    end

    local ok_parent, raw_file_parent = pcall(fetch, raw_file_url(repo, parent_sha, file_name))
    if not ok_parent then
        error()
    end

    return raw_file, raw_file_parent
end

local function fetch_snippets(repo, sha)
    local ok_commit, res_commit = pcall(fetch, commit_url(repo, sha))
    if not ok_commit then
        error()
    end

    local res_json = vim.json.decode(res_commit)
    local parent_sha = res_json.parents[1].sha
    local file_name = res_json.files[1].filename
    local file_ext = string.match(file_name, "[%a%d]+$")

    local ok_files, raw_file, raw_file_parent = pcall(fetch_raw_files, repo, file_name, sha, parent_sha)
    if not ok_files then
        error()
    end

    return file_ext, raw_file, raw_file_parent
end

return {
    raw_file_url = raw_file_url,
    fetch_snippets = fetch_snippets
}
