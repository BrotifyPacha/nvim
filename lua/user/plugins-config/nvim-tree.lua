vim.g.nvim_tree_respect_buf_cwd = 1

local tree_cb = require'nvim-tree.config'.nvim_tree_callback

vim.cmd [[
    let g:nvim_tree_git_hl = 1
    let g:nvim_tree_icons = {
      \ 'default':        '',
      \ 'symlink':        '',
      \ 'git': {
      \   'unstaged':     "",
      \   'staged':       "",
      \   'unmerged':     "",
      \   'renamed':      "",
      \   'untracked':    "",
      \   'deleted':      "",
      \   'ignored':      "",
      \  },
      \ 'folder': {
      \   'arrow_open':   "",
      \   'arrow_closed': "",
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

vim.cmd [[
    highlight! link NvimTreeGitDirty DiffChange
    highlight! link NvimTreeGitStaged DiffAdd
]]

vim.cmd [[
    augroup pacha_nvim_tree
        autocmd!
        autocmd BufEnter * if &l:ft == "NvimTree" | setlocal cursorline | endif
    augroup end
]]

require'nvim-tree'.setup {
  disable_netrw       = true,
  hijack_netrw        = true,
  open_on_setup       = false,
  ignore_ft_on_setup  = {},
  open_on_tab         = false,
  hijack_cursor       = false,
  update_cwd          = false,
  diagnostics = {
      enable = false,
      show_on_dirs = true,
  },
  git = {
      enable = true,
      ignore = false
  },
  view = {
    height = 30,
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
