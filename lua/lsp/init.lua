local lsp_installer = require 'nvim-lsp-installer'

-- Insatlling servers
local servers = {
    'cssls',
    'html',
    'dockerls',
    'gopls',
    'phpactor',
    'pyright',
    'sumneko_lua',
    -- 'tailwindcss',
    'vimls',
}
for _, name in pairs(servers) do
    local server_is_found, server = lsp_installer.get_server(name)
    if server_is_found then
        if not server:is_installed() then
            print("Installing " .. name)
            server:install()
        end
    end
end

local function on_attach(client, bufnr)
    -- Set up buffer-local keymaps (vim.api.nvim_buf_set_keymap()), etc.
    local opts = { noremap = true, silent = true }
    vim.api.nvim_buf_set_keymap(bufnr, "n", "gD", "<cmd>lua vim.lsp.buf.declaration()<CR>", opts)
    vim.api.nvim_buf_set_keymap(bufnr, "n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>", opts)
    vim.api.nvim_buf_set_keymap(bufnr, "n", "K", "<cmd>lua vim.lsp.buf.hover()<CR>", opts)
    vim.api.nvim_buf_set_keymap(bufnr, "n", "<C-k>", "<cmd>lua vim.lsp.buf.code_action()<CR>", opts)
    vim.api.nvim_buf_set_keymap(bufnr, "n", "gi", "<cmd>lua vim.lsp.buf.implementation()<CR>", opts)
    -- vim.api.nvim_buf_set_keymap(bufnr, "n", "<leader>s", "<cmd>lua vim.lsp.buf.signature_help()<CR>", opts)
    -- vim.api.nvim_buf_set_keymap(bufnr, "n", "<leader>lr", "<cmd>lua vim.lsp.buf.rename()<CR>", opts)
    vim.api.nvim_buf_set_keymap(bufnr, "n", "gr", "<cmd>lua vim.lsp.buf.references()<CR>", opts)
    -- vim.api.nvim_buf_set_keymap(bufnr, "n", "<leader>f", "<cmd>lua vim.diagnostic.open_float()<CR>", opts)
    vim.api.nvim_buf_set_keymap(bufnr, "n", "[d", '<cmd>lua vim.diagnostic.goto_prev({ border = "single" })<CR>', opts)
    vim.api.nvim_buf_set_keymap(bufnr, "n", "]d", '<cmd>lua vim.diagnostic.goto_next({ border = "single" })<CR>', opts)
    -- vim.api.nvim_buf_set_keymap(bufnr, "n", "<leader>q", "<cmd>lua vim.diagnostic.setloclist()<CR>", opts)
    vim.cmd [[ command! Format execute 'lua vim.lsp.buf.formatting()' ]]

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
end

-- Always on mappings
local opts = { noremap = true, silent = true }
vim.api.nvim_set_keymap(
    "n",
    "gl",
    '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics({ border = "single" })<CR>',
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

vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
    border = "single",
})

vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
    border = "single",
})


local enhance_server_opts = {
    ["sumneko_lua"] = require('lsp.settings.sumneko_lua'),
}

local capabilities = require'cmp_nvim_lsp'.update_capabilities(vim.lsp.protocol.make_client_capabilities())
lsp_installer.on_server_ready(function(server)
    -- Specify the default options which we'll use to setup all servers
    local opts = {
        on_attach = on_attach,
        capabilities = capabilities,
    }

    if enhance_server_opts[server.name] then
        opts = vim.tbl_deep_extend('force', enhance_server_opts[server.name], opts)
    end

    server:setup(opts)
end)

-- null_ls
local null_ls = require 'null-ls'
local sources = {
    null_ls.builtins.diagnostics.phpcs.with({
        extra_args = { '--standard=psr12' },
        diagnostics_format = "#{m}"
    })
}

require 'null-ls'.setup({ sources = sources })

