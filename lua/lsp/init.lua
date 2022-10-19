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
    vim.api.nvim_buf_set_keymap(bufnr, "v", "<C-k>", "<cmd>lua vim.lsp.buf.range_code_action()<CR>", opts)
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
        -- prefix = function (d, i, win_total)
        --     local highlight = 'DiagnosticSignHint'
        --     if d.severity == 1 then
        --         highlight = 'DiagnosticSignError'
        --     elseif d.severity == 2 then
        --         highlight = 'DiagnosticSignWarn'
        --     elseif d.severity == 3 then
        --         highlight = 'DiagnosticSignInfo'
        --     end
        --     return i .. '. ', highlight
        -- end,
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


local enhance_server_opts = {
    ["sumneko_lua"] = require('lsp.settings.sumneko_lua'),
}

local capabilities = require'cmp_nvim_lsp'.default_capabilities(vim.lsp.protocol.make_client_capabilities())
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

