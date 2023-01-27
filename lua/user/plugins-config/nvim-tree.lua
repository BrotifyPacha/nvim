local tree_cb = require'nvim-tree.config'.nvim_tree_callback


vim.cmd [[
    highlight! link NvimTreeGitDirty DiagnosticWarn
    highlight! link NvimTreeGitStaged Statement
]]

vim.cmd [[
    augroup pacha_nvim_tree
        autocmd!
        autocmd BufEnter * if &l:ft == "NvimTree" | setlocal cursorline | endif
    augroup end
]]

require'nvim-tree'.setup {
  disable_netrw       = false,
  hijack_netrw        = true,
  open_on_setup       = false,
  ignore_ft_on_setup  = {},
  open_on_tab         = false,
  hijack_cursor       = false,
  update_cwd          = false,
  respect_buf_cwd     = true,
  diagnostics = {
      enable = false,
      show_on_dirs = true,
  },
  git = {
      enable = true,
      ignore = false
  },
  renderer = {
      highlight_git = true,
      icons = {
          show = {
              git = false,
              folder_arrow = false,
          },
          glyphs = {
              default =        '',
              symlink =        '',
              git = {
                  unstaged =     "",
                  staged =       "",
                  unmerged =     "",
                  renamed =      "",
                  untracked =    "",
                  deleted =      "",
                  ignored =      "",
              },
              folder = {
                  arrow_open =   "",
                  arrow_closed = "",
                  default =      "",
                  open =         "",
                  empty =        "",
                  empty_open =   "",
                  symlink =      "",
                  symlink_open = "",
              },
          },
      },
  },
  view = {
    adaptive_size = true,
    hide_root_folder = true,
    side = 'left',
    mappings = {
      custom_only = false,
      list = {
          { key = 'l', cb = tree_cb('edit') },
          { key = 'l', cb = tree_cb('open') },
          { key = 'L', cb = tree_cb('vsplit') },
          { key = 'h', cb = tree_cb('close_node') },
          { key = 'H', cb = tree_cb('parent_node') },
          { key = '<cr>', cb = tree_cb('cd') },
          { key = '-', cb = tree_cb('dir_up') },
          -- { key = '<++>', cb = tree_cb('<++>') },
      }
    },
    number = false,
    relativenumber = false,
    signcolumn = "yes"
  },
  trash = {
    cmd = "trash",
    require_confirm = true
  }
}
