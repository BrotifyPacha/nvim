lua << EOF
local branch = vim.fn['FugitiveHead']()
if string.match(branch, '%u+%-%d+') then
    local lines = vim.api.nvim_buf_get_lines(0, 0, 99999, false)
    local branch_line = branch .. ': '
    vim.api.nvim_set_current_line(branch_line)
    vim.api.nvim_win_set_cursor(0, { 1, string.len(branch_line) - 1 })
    vim.api.nvim_command [[ startinsert! ]]
end

