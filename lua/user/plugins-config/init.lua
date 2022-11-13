
require 'user.plugins-config.devicons'

require 'user.plugins-config.treesitter'
require 'user.plugins-config.colorizer'
require 'user.plugins-config.dap'
require 'user.plugins-config.gitsigns'
require 'user.plugins-config.nvim-tree'
require 'user.plugins-config.snippy'
require 'user.plugins-config.cmp'
require 'user.plugins-config.lualine'
require 'user.plugins-config.which-key'
require 'nvim-gps'.setup()
require 'user.plugins-config.sniprun'

require("scratch").setup {
	scratch_file_dir = vim.fn.stdpath("cache") .. "/scratch.nvim",  -- Where the scratch files will be saved
	filetypes = { "json", "xml", "go", "lua", "js", "py", "sh" },   -- filetypes to select from
}

