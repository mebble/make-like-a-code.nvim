local u = require('make-like-a-code.utils')
local snippet = require('make-like-a-code.snippet')

local function activate_game_panes(player_win, prompt_win)
    vim.api.nvim_win_set_option(player_win, 'diff', true)
    vim.api.nvim_win_set_option(prompt_win, 'diff', true)
    vim.api.nvim_win_set_option(player_win, 'scrollbind', true)
    vim.api.nvim_win_set_option(prompt_win, 'scrollbind', true)
end

local function deactivate_game_panes(player_win, prompt_win)
    vim.api.nvim_win_set_option(player_win, 'diff', false)
    vim.api.nvim_win_set_option(prompt_win, 'diff', false)
    vim.api.nvim_win_set_option(player_win, 'scrollbind', false)
    vim.api.nvim_win_set_option(prompt_win, 'scrollbind', false)
end


local function create_game_panes(old_snippet_lines, new_snippet_lines)
    local player_win = vim.api.nvim_get_current_win()
    local player_buf = vim.api.nvim_create_buf(true, true)
    vim.api.nvim_buf_set_name(player_buf, "Type here")
    vim.api.nvim_buf_set_lines(player_buf, 0, -1, false, old_snippet_lines)

    vim.cmd('vsplit')

    local prompt_win = vim.api.nvim_get_current_win()
    local prompt_buf = vim.api.nvim_create_buf(true, true)
    vim.api.nvim_buf_set_name(prompt_buf, "Prompt")
    vim.api.nvim_buf_set_lines(prompt_buf, 0, -1, false, new_snippet_lines)

    vim.api.nvim_win_set_buf(player_win, player_buf)
    vim.api.nvim_win_set_buf(prompt_win, prompt_buf)

    return player_win, player_buf, prompt_win, prompt_buf
end

local function start(github_repo, commit_hash)
    local ok, languages = pcall(snippet.get_languages)
    if not ok then
        error('Failed to get languages')
    end

    local ok, snippet_contents = pcall(snippet.get_snippets, github_repo, commit_hash)
    if not ok then
        error('Failed to fetch commit from github')
    end
    local file_ext, new_snippet, old_snippet = snippet.parse_contents(snippet_contents)

    local new_snippet_lines = u.split_string(new_snippet)
    local old_snippet_lines = u.split_string(old_snippet)

    local player_win, player_buf, prompt_win  = create_game_panes(old_snippet_lines, new_snippet_lines);
    activate_game_panes(player_win, prompt_win)

    -- HACK. TODO = ensure that when player_buf's lines are joined, they're the same as they were before splitting 
    new_snippet = u.join_strings(new_snippet_lines)

    local lang = snippet.extension_to_language(languages, file_ext)
    if lang ~= nil then
        print('Language: '..lang)
    end


    vim.api.nvim_set_current_win(player_win)

    local start_time = vim.fn.localtime()
    print('Listening for changes at buffer:', player_buf)
    vim.api.nvim_buf_attach(player_buf, true, {
        on_lines = function(_, buf)
            local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
            local typed = u.join_strings(lines)
            if typed == new_snippet then
                local end_time = vim.fn.localtime()
                local secs = end_time - start_time
                print('Finished in ' .. secs .. " seconds")
                deactivate_game_panes(player_win, prompt_win)
                return true
            end
        end
    })
end

return {
    start = start,
}
