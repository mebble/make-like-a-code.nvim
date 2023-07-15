local u = require('make-like-a-code.utils')
local github = require('make-like-a-code.github')

local ok, new_snippet, old_snippet = pcall(github.fetch_snippets, 'mebble/mcj', '8f091afc5d60a5a231ec05b7c1ae86a31a4bd9cb')

local player_win = vim.api.nvim_get_current_win()
local player_buf = vim.api.nvim_create_buf(true, true)
vim.api.nvim_buf_set_name(player_buf, "Type here")
vim.api.nvim_buf_set_lines(player_buf, 0, -1, false, u.split_string(old_snippet))

vim.cmd('vsplit')

local prompt_win = vim.api.nvim_get_current_win()
local prompt_buf = vim.api.nvim_create_buf(true, true)
vim.api.nvim_buf_set_name(prompt_buf, "Prompt")
vim.api.nvim_buf_set_lines(prompt_buf, 0, -1, false, u.split_string(new_snippet))

vim.api.nvim_win_set_buf(player_win, player_buf)
vim.api.nvim_win_set_buf(prompt_win, prompt_buf)
vim.api.nvim_set_current_win(player_win)

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
            return true
        end
    end
})

local function greet()
    print("Hello!")
end

return {
    greet = greet,
}

