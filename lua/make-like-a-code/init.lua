local u = require('make-like-a-code.utils')
local snippet = require('make-like-a-code.snippet')

local function handle_scroll(buf_to_handle, win_to_handle, win_to_sync)
    vim.api.nvim_create_autocmd('WinScrolled', {
        buffer = buf_to_handle,
        callback = function()
            local cursor = vim.api.nvim_win_get_cursor(win_to_handle)
            vim.api.nvim_win_set_cursor(win_to_sync, cursor)
        end
    })
end

local function start(github_repo, commit_hash)
    local ok, file_ext, new_snippet, old_snippet = pcall(snippet.get_snippets, github_repo, commit_hash)
    if not ok then
        error('Failed to fetch commit from github')
    end
    print('Got file ext' .. file_ext)

    local new_snippet_lines = u.split_string(new_snippet)
    local old_snippet_lines = u.split_string(old_snippet)

    -- HACK. TODO = ensure that when player_buf's lines are joined, they're the same as they were before splitting 
    new_snippet = u.join_strings(new_snippet_lines)

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
    vim.api.nvim_win_set_option(player_win, 'diff', true)
    vim.api.nvim_win_set_option(prompt_win, 'diff', true)

    vim.api.nvim_set_current_win(player_win)

    handle_scroll(player_buf, player_win, prompt_win)
    handle_scroll(prompt_buf, prompt_win, player_win)

    local start_time = vim.fn.localtime()
    print('Starting game at buffer:', player_buf)
    vim.api.nvim_buf_attach(player_buf, true, {
        on_lines = function(_, buf)
            local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
            local typed = u.join_strings(lines)
            if typed == new_snippet then
                local end_time = vim.fn.localtime()
                local secs = end_time - start_time
                print('Finished in ' .. secs .. " seconds")
                vim.api.nvim_win_set_option(prompt_win, 'diff', false)
                vim.api.nvim_win_set_option(player_win, 'diff', false)
                return true
            end
        end
    })
end

return {
    start = start,
}
