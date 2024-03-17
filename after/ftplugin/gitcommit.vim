lua << EOF
local branch = vim.fn['FugitiveHead']()
local prefix = ''
if string.match(branch, '%u+%-%d+') then
    prefix = branch .. ': '
end

if string.match(branch, 'GOHW%-%d+') then
    branch = string.match(branch, 'GOHW%-%d+')
    prefix = '[' .. branch .. ']: '
end

local lines = vim.api.nvim_buf_get_lines(0, 0, 99999, false)
vim.api.nvim_set_current_line(prefix)
vim.api.nvim_win_set_cursor(0, { 1, string.len(prefix) - 1 })
vim.api.nvim_command [[ startinsert! ]]
