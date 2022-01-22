vim.g.nvim_tree_respect_buf_cwd = 1

local tree_cb = require'nvim-tree.config'.nvim_tree_callback

vim.cmd [[
    let g:nvim_tree_icons = {
      \ 'default':        '',
      \ 'symlink':        '',
      \ 'git': {
      \   'unstaged':     "U",
      \   'staged':       "S",
      \   'unmerged':     "",
      \   'renamed':      "➜",
      \   'untracked':    "T",
      \   'deleted':      "",
      \  },
      \ 'folder': {
      \   'arrow_open':   "",
      \   'arrow_closed': "",
      \   'default':      "",
      \   'open':         "",
      \   'empty':        "",
      \   'empty_open':   "",
      \   'symlink':      "",
      \   'symlink_open': "",
      \  },
      \  'lsp': {
      \    'hint': "",
      \    'info': "",
      \    'warning': "",
      \    'error': "",
      \  }
      \ }
]]

require'nvim-tree'.setup {
  disable_netrw       = true,
  hijack_netrw        = true,
  open_on_setup       = false,
  ignore_ft_on_setup  = {},
  auto_close          = false,
  open_on_tab         = false,
  hijack_cursor       = false,
  update_cwd          = false,
  update_to_buf_dir   = {
      enable = true,
      auto_open = true,
  },
  diagnostics = {
      enable = true,
      show_on_dirs = true,
  },
  git = {
      enable = true
  },
  view = {
    height = 30,
    hide_root_folder = true,
    side = 'left',
    auto_resize = true,
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
