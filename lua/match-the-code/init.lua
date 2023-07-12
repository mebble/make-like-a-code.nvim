vim.cmd('vsplit')
local win = vim.api.nvim_get_current_win()
local buf = vim.api.nvim_create_buf(true, true)
vim.api.nvim_win_set_buf(win, buf)
vim.api.nvim_buf_set_lines(buf, 0, -1, false, {"Line one", "line 2"})

local function greet()
    print("Hello!")
end

return {
    greet = greet,
}

