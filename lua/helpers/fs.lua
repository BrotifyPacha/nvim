
local M = {}

function M.change_tab_dir_to_root()

  local root = vim.fs.root(0, {'.git', 'go.mod', 'go.sum', 'README.md'})

  vim.cmd { cmd = 'tcd', args = { root } }

end

return M
