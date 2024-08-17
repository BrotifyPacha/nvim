
local servers = {
  'cssls',
  'html',
  'dockerls',
  'gopls',
  'pyright',
  'lua_ls',
  'tailwindcss',
  'vimls',
  'jsonls',
  'omnisharp',
}

require'mason'.setup()
require'mason-lspconfig'.setup {
  ensure_installed = servers
}

-- vim.lsp.inlay_hint.enable(true)

local function on_attach(client, bufnr)
  -- Set up buffer-local keymaps (vim.api.nvim_buf_set_keymap()), etc.
  local opts = { noremap = true, silent = true }
  vim.api.nvim_buf_set_keymap(bufnr, "n", "gD", "<cmd>lua vim.lsp.buf.declaration()<CR>", opts)
  vim.api.nvim_buf_set_keymap(bufnr, "n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>", opts)
  vim.api.nvim_buf_set_keymap(bufnr, "n", "K", "<cmd>lua vim.lsp.buf.hover()<CR>", opts)
  vim.api.nvim_buf_set_keymap(bufnr, "n", "<C-k>", "<cmd>lua vim.lsp.buf.code_action()<CR>", opts)
  vim.api.nvim_buf_set_keymap(bufnr, "v", "<C-k>", "<cmd>lua vim.lsp.buf.code_action()<CR>", opts)
  vim.api.nvim_buf_set_keymap(bufnr, "n", "gi", "<cmd>lua vim.lsp.buf.implementation()<CR>", opts)
  -- vim.api.nvim_buf_set_keymap(bufnr, "n", "<leader>s", "<cmd>lua vim.lsp.buf.signature_help()<CR>", opts)
  vim.api.nvim_buf_set_keymap(bufnr, "n", "<leader>rr", "<cmd>lua vim.lsp.buf.rename()<CR>", opts)
  vim.api.nvim_buf_set_keymap(bufnr, "n", "gr", "<cmd>lua vim.lsp.buf.references()<CR>", opts)
  -- vim.api.nvim_buf_set_keymap(bufnr, "n", "<leader>f", "<cmd>lua vim.diagnostic.open_float()<CR>", opts)
  vim.api.nvim_buf_set_keymap(bufnr, "n", "[d", '<cmd>lua vim.diagnostic.goto_prev({ border = "single" })<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, "n", "]d", '<cmd>lua vim.diagnostic.goto_next({ border = "single" })<CR>', opts)
  -- vim.api.nvim_buf_set_keymap(bufnr, "n", "<leader>q", "<cmd>lua vim.diagnostic.setloclist()<CR>", opts)
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
  }, bufnr)
  -- require 'lsp-inlayhints'.on_attach(client, bufnr)
end

-- Always on mappings
local opts = { noremap = true, silent = true }
vim.api.nvim_set_keymap(
  "n",
  "gl",
  '<cmd>lua vim.diagnostic.open_float()<cr>',
  opts
)

local signs = {
  { name = "DiagnosticSignError", text = "" },
  { name = "DiagnosticSignWarn", text = "" },
  { name = "DiagnosticSignHint", text = "" },
  { name = "DiagnosticSignInfo", text = "" },
}

for _, sign in ipairs(signs) do
  vim.fn.sign_define(sign.name, { texthl = sign.name, text = sign.text, numhl = "" })
end

vim.diagnostic.config({
  virtual_text = false,
  signs = false, --disable signs here to customly display them later
  update_in_insert = true,
  underline = true,
  severity_sort = true,
  float = {
    focusable = false,
    style = "minimal",
    border = "single",
    source = "always",
    header = "Diagnostics:",
  }
})

-- Create a namespace. This won't be used to add any diagnostics,
-- only to display them.
local ns = vim.api.nvim_create_namespace("my_namespace")

-- Create a reference to the original function
local show = vim.diagnostic.show

local function contains_diagnostic_with_severity(diagnostics, diagnostic)
  for _, present_diag in pairs(diagnostics) do
    if present_diag.severity == diagnostic.severity then
      return true
    end
  end
  return false
end

local function set_signs(bufnr)
  -- Get all diagnostics from the current buffer
  local diagnostics = vim.diagnostic.get(bufnr)
  -- Find the "worst" diagnostic per line
  local one_sign_per_severity_per_line = {}
  for _, d in pairs(diagnostics) do
    if one_sign_per_severity_per_line[d.lnum] then
      local present_diags = one_sign_per_severity_per_line[d.lnum]
      if contains_diagnostic_with_severity(present_diags, d) ~= true then
        one_sign_per_severity_per_line[d.lnum] = table.insert(present_diags, d)
      end
    else
      one_sign_per_severity_per_line[d.lnum] = {d}
    end
  end
  local filtered_diagnostics = {}
  for _, v in pairs(one_sign_per_severity_per_line) do
    for _, j in pairs(v) do
      table.insert(filtered_diagnostics, j)
    end
  end
  -- Show the filtered diagnostics using the custom namespace. Use the
  -- reference to the original function to avoid a loop.
  show(ns, bufnr, filtered_diagnostics, {
    virtual_text = false,
    signs = {
      active = signs
    },
    update_in_insert = true,
    underline = true,
    severity_sort = true,
    float = {
      focusable = false,
      style = "minimal",
      border = "single",
      source = "always",
      header = "",
      prefix = "",
    }
  })
end

function vim.diagnostic.show(namespace, bufnr, ...)
  show(namespace, bufnr, ...)
  set_signs(bufnr)
end

vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
  border = "single",
})

vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
  border = "single",
})


local capabilities = require'cmp_nvim_lsp'.default_capabilities(vim.lsp.protocol.make_client_capabilities())
local lspconfig = require('lspconfig')
local util = require('lspconfig/util')

for _, server in ipairs(servers) do
  server = vim.tbl_get(lspconfig, server)
  server.setup{
    on_attach = on_attach,
    capabilities = capabilities
  }
end

require('mason-lspconfig').setup_handlers({
  function(server)
    lspconfig[server].setup({
      on_attach = on_attach,
      capabilities = capabilities
    })
  end,
})

lspconfig.pyright.setup {
  on_attach = on_attach,
  capabilities = capabilities,
  settings = {
    python = {
      venvPath = '.'
    }
  }
}

lspconfig.jsonls.setup {
  on_attach = on_attach,
  capabilities = capabilities,
}

lspconfig.phpactor.setup {
  on_attach = on_attach,
  capabilities = capabilities,
  cmd = { 'phpactor', 'language-server' },
  root_dir = util.root_pattern("composer.json")
}

lspconfig.gopls.setup {
  on_attach = on_attach,
  capabilities = capabilities,
  cmd = {"gopls", "serve"},
  filetypes = {"go", "gomod"},
  root_dir = util.root_pattern("go.work", "go.mod", ".git"),
  settings = {
    gopls = {
      hints = {
        -- assignVariableTypes = true,
        -- compositeLiteralFields = true,
        -- compositeLiteralTypes = true,
        -- constantValues = true,
        -- functionTypeParameters = true,
        parameterNames = true,
        -- rangeVariableTypes = true,
      },
    },
  },
}

require("neodev").setup({
  library = {
    enabled = true, -- when not enabled, neodev will not change any settings to the LSP server
    -- these settings will be used for your Neovim config directory
    runtime = true, -- runtime path
    types = true, -- full signature, docs and completion of vim.api, vim.treesitter, vim.lsp and others
    -- plugins = true, -- installed opt or start plugins in packpath
    -- you can also specify the list of plugins to make available as a workspace library
    plugins = { "nvim-treesitter", "plenary.nvim", "telescope.nvim" },
  },
  setup_jsonls = true, -- configures jsonls to provide completion for project specific .luarc.json files
  -- for your Neovim config directory, the config.library settings will be used as is
  -- for plugin directories (root_dirs having a /lua directory), config.library.plugins will be disabled
  -- for any other directory, config.library.enabled will be set to false
  override = function(root_dir, options) end,
  -- With lspconfig, Neodev will automatically setup your lua-language-server
  -- If you disable this, then you have to set {before_init=require("neodev.lsp").before_init}
  -- in your lsp start options
  lspconfig = true,
  -- much faster, but needs a recent built of lua-language-server
  -- needs lua-language-server >= 3.6.0
  pathStrict = true,
})

local runtime_path = vim.split(package.path, ';')
table.insert(runtime_path, "lua/?.lua")
table.insert(runtime_path, "lua/?/init.lua")
lspconfig.lua_ls.setup{
  on_attach = on_attach,
  capabilities = capabilities,
  settings = {
    Lua = {
      runtime ={
        version = 'LuaJIT',
        path = runtime_path,
      },
      diagnostics = {
        globals = { 'vim' },
      },
      workspace = {
        -- library = vim.api.nvim_get_runtime_file("", true),
        -- library = {
        --     [ vim.fn.expand("$VIMRUNTIME") ] = true,
        --     [ vim.fn.expand("$VIMRUNTIME/lua/jit") ] = true,
        --     [ vim.fn.expand("$VIMRUNTIME/lua/vim") ] = true,
        --     [ vim.fn.expand("$VIMRUNTIME/lua/vim/lsp") ] = true,
        --     [ vim.fn.stdpath("config") .. '/lua' ] = true,
        -- }
      }
    }
  }
}

require'lspconfig'.omnisharp.setup {
  on_attach = on_attach,
  capabilities = capabilities,
}
