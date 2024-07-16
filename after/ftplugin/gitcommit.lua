local branch = vim.fn['FugitiveHead']()

-- matches
-- [prefix/]KEY-123[-suffix]
local rxBranch = "\\v(\\w+/)?(\\u+-\\d+)(-\\w+)*"

local prefix = ''

if vim.fn.match(branch, rxBranch) ~= -1 then
    prefix = vim.fn.substitute(branch, rxBranch, "\\=submatch(2)", "")
    prefix = '[' .. (prefix or '') .. '] '
end

if string.len(prefix) ~= 0 then
    local lines = vim.api.nvim_buf_get_lines(0, 0, 99999, false)
    vim.api.nvim_set_current_line(prefix)
    vim.api.nvim_win_set_cursor(0, { 1, string.len(prefix) - 1 })
    vim.api.nvim_command [[ startinsert! ]]
end
