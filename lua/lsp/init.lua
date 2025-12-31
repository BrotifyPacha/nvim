
require "lsp.signs"

local server_install_cmds = {
  -- gopls
  "go install golang.org/x/tools/gopls@latest",
  -- vim-ls
  "npm install -g vim-language-server",
  -- lua-ls
  "brew install lua-language-server",
  -- dockerls
  "go install github.com/docker/docker-language-server/cmd/docker-language-server@latest"
}

vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('my.lsp', {}),
  callback = function(args)
    local client = assert(vim.lsp.get_client_by_id(args.data.client_id))

    local opts = { buffer = true }

    vim.keymap.set("n", "gl", vim.diagnostic.open_float, opts)
    vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
    vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
    vim.keymap.set("n", "ge", function ()
      vim.cmd [[ tab split ]]
      vim.cmd [[ normal gd ]]
      vim.lsp.buf.definition({ on_list = function () require 'helpers.fs'.change_tab_dir_to_root() end })
    end, opts)
    vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
    vim.keymap.set("n", "<C-k>", vim.lsp.buf.code_action, opts)
    vim.keymap.set("v", "<C-k>", vim.lsp.buf.code_action, opts)
    vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
    vim.keymap.set("n", "<leader>rr", vim.lsp.buf.rename, opts)
    vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
    vim.cmd [[ command! Format execute 'lua vim.lsp.buf.format(nil)' ]]

    require 'lsp_signature'.on_attach({
      bind = true,
      floating_window_above_cur_line = true,
      max_width = 120,
      hi_parameter = 'Cursor',
      hint_enable = false,
      handler_opts = {
        border = 'single'
      }
    }, args.buf)

  end,
})


local capabilities = require'cmp_nvim_lsp'.default_capabilities(vim.lsp.protocol.make_client_capabilities())

vim.lsp.config('*', { capabilities = capabilities })

vim.lsp.enable({
  "gopls",
  "vimls",
  "lua_ls",
  -- "ts_ls",
})

local runtime_path = vim.split(package.path, ';')
table.insert(runtime_path, "lua/?.lua")
table.insert(runtime_path, "lua/?/init.lua")

vim.lsp.config('lua_ls', {
  settings = {
    Lua = {
      runtime ={ version = 'LuaJIT', path = runtime_path },
      workspace = {
        library = {
          vim.fn.expand("~/.local/share/nvim/site/pack/packer/start/telescope.nvim/lua"),
          vim.fn.expand("~/.local/share/nvim/site/pack/packer/start/plenary.nvim/lua"),
        }
      },
      diagnostics = { globals = { 'vim' } },
    }
  }
})
