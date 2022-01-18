
require 'user.plugins-config.treesitter'
require 'user.plugins-config.colorizer'
require 'user.plugins-config.dap'
require 'user.plugins-config.gitsigns'
require 'user.plugins-config.nvim-tree'
require 'user.plugins-config.cmp'
require 'user.plugins-config.lualine'

local null_ls = require 'null-ls'

-- local sources = {
--     -- willl show code and source name
--     null_ls.builtins.diagnostics.shellcheck.with({
--         diagnostics_format = "[#{c}] #{m} (#{s})"
--     }),
-- }

-- local lua_src = {
--     method = null_ls.methods.DIAGNOSTICS,
--     filetypes = { 'lua' }
-- }

-- local spellcheck_src = {
--     method = null_ls.methods.DIAGNOSTICS,
--     filetypes = {}
-- }
local sources = {
    null_ls.builtins.diagnostics.phpcs.with({
        extra_args = { '--standard=psr12' },
        diagnostics_format = "#{m}"
    })
}

require 'null-ls'.setup({ sources = sources })
