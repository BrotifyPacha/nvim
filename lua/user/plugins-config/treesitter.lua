
vim.api.nvim_command [[
    highlight! link TSCurrentScope PmenuBg
    highlight! link TSDefinition PmenuBg
    highlight! link TSDefinitionUsage Underlined
    highlight! link @variable @text
    highlight! link @namespace @text
]]

local highlight_filetypes = {
  'go',
  'lua',
  'vim',
  'yaml',
}

vim.api.nvim_create_autocmd('FileType', {
  pattern = highlight_filetypes,
  callback = function() vim.treesitter.start() end,
})

vim.keymap.set({ "x", "o" }, "af", function()
  require "nvim-treesitter-textobjects.select".select_textobject("@function.outer", "textobjects")
end)
vim.keymap.set({ "x", "o" }, "if", function()
  require "nvim-treesitter-textobjects.select".select_textobject("@function.inner", "textobjects")
end)
vim.keymap.set({ "x", "o" }, "ie", function()
  require "nvim-treesitter-textobjects.select".select_textobject("@expression.inner", "textobjects")
end)
