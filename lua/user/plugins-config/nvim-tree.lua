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

local function my_on_attach(bufnr)
    local api = require('nvim-tree.api')

    local function opts(desc)
        return { desc = 'nvim-tree: ' .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
    end

    -- use all default mappings
    api.config.mappings.default_on_attach(bufnr)

    -- delete some default mappings
    vim.keymap.del('n', '>', { buffer = bufnr })
    vim.keymap.del('n', '<', { buffer = bufnr })
    vim.keymap.del('n', '<bs>', { buffer = bufnr })
    vim.keymap.del('n', '<C-x>', { buffer = bufnr })
    vim.keymap.del('n', '<C-e>', { buffer = bufnr })
    vim.keymap.del('n', '<C-v>', { buffer = bufnr })

    -- override a default
    vim.keymap.set('n', 'L', api.node.open.vertical, opts('Open: Vertical Split'))
    vim.keymap.set('n', 'l', api.node.open.edit, opts('Open'))
    vim.keymap.set('n', 'h',  api.node.navigate.parent_close,        opts('Close Directory'))

    -- add your mappings
    vim.keymap.set('n', '?', api.tree.toggle_help, opts('Help'))
    ---
end

require'nvim-tree'.setup {
  on_attach = my_on_attach,
  disable_netrw       = false,
  hijack_netrw        = true,
  open_on_tab         = false,
  hijack_cursor       = false,
  update_cwd          = false,
  reload_on_bufenter = true,
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
      root_folder_label = false,
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
    side = 'left',
    number = false,
    relativenumber = false,
    signcolumn = "yes"
  },
  trash = {
    cmd = "trash",
    require_confirm = true
  }
}
