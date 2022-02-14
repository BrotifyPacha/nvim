
local kind_icons = {
  Text = "",
  Method = "m",
  Function = "",
  Constructor = "",
  Field = "",
  Variable = "",
  Class = "",
  Interface = "",
  Module = "",
  Property = "",
  Unit = "",
  Value = "",
  Enum = "",
  Keyword = "",
  Snippet = "",
  Color = "",
  File = "",
  Reference = "",
  Folder = "",
  EnumMember = "",
  Constant = "",
  Struct = "",
  Event = "",
  Operator = "",
  TypeParameter = "",
}

vim.api.nvim_command [[

    highlight link CmpItemKindFunction Identifier
    highlight link CmpItemKindMethod CmpItemKindFunction
    highlight link CmpItemKindProperty CmpItemKindFunction

    highlight link CmpItemKindField Type
    highlight link CmpItemKindVariable CmpItemKindField
    highlight link CmpItemKindEnumMember CmpItemKindField
    highlight link CmpItemKindEnum CmpItemKindField
    highlight link CmpItemKindClass CmpItemKindField
    highlight link CmpItemKindInterface CmpItemKindField

    highlight link CmpItemKindConstant Constant
    highlight link CmpItemKindKeyword CmpItemKindConstant

    highlight link CmpItemKindText Comment
    highlight link CmpItemKindSnippet Comment

    highlight link CmpItemKindFolder Normal

]]

local t = function(str)
    return vim.api.nvim_replace_termcodes(str, true, true, true)
end

-- local luasnip = require 'luasnip'
-- require 'luasnip.loaders.from_vscode'.lazy_load({ paths = './' }) -- opts can be ommited
-- require 'luasnip.loaders.from_snipmate'.lazy_load({ './UltiSnips' }) -- opts can be ommited
local cmp = require 'cmp'
cmp.setup({
    snippet = {
        expand = function(args)
            vim.fn["UltiSnips#Anon"](args.body) -- For `ultisnips` users.
            -- require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
        end,
    },
    mapping = {
        ['<C-b>'] = cmp.mapping(cmp.mapping.scroll_docs(-4), { 'i', 'c' }),
        ['<C-f>'] = cmp.mapping(cmp.mapping.scroll_docs(4), { 'i', 'c' }),
        ['<C-Space>'] = cmp.mapping(cmp.mapping.complete(), { 'i', 'c' }),
        ['<C-y>'] = cmp.config.disable, -- Specify `cmp.config.disable` if you want to remove the default `<C-y>` mapping.
        ['<C-e>'] = cmp.mapping({
            i = cmp.mapping.abort(),
            c = cmp.mapping.close(),
        }),
        ['<Tab>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_next_item({ behavior = cmp.SelectBehavior.Insert })
            elseif vim.fn["UltiSnips#CanJumpForwards"]() == 1 then
                vim.api.nvim_feedkeys(t("<Plug>(ultisnips_jump_forward)"), 'm', true)
            else
                fallback()
            end
        end, { 'i', 's' }),
        ['<S-Tab>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_prev_item({ behavior = cmp.SelectBehavior.Insert })
            elseif vim.fn["UltiSnips#CanJumpBackwards"]() == 1 then
                vim.api.nvim_feedkeys(t("<Plug>(ultisnips_jump_backward)"), 'm', true)
            else
                fallback()
            end
        end, { 'i', 's' }),
        ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
    },

    formatting = {
        fields = { 'kind', 'abbr', 'menu' },
        format = function(entry, vim_item)
            -- Kind icons
            vim_item.kind = string.format('%s ', kind_icons[vim_item.kind], vim_item.kind) -- This concatonates the icons with the name of the item kind
            -- Source
            vim_item.menu = ({
                buffer    = "[Buffer]",
                nvim_lsp  = "[LSP]",
                ultisnips = "[UltiSnip]",
                luasnip   = "[LuaSnip]",
                -- nvim_lua = "[Lua]",
                -- latex_symbols = "[LaTeX]",
            })[entry.source.name]
            return vim_item
        end
    },
    sources = {
        { name = 'nvim_lsp' },
        { name = 'ultisnips' },
        -- { name = 'luasnip' },
        { name = 'buffer' },
        { name = 'path' },
    },
    documentation = {
        border = { "┌", "─", "┐", "│", "┘", "─", "└", "│" },
    },
    experimental = {
        native_menu = false,
        ghost_text = false,
    }
})

-- Use buffer source for `/` (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline('/', {
    sources = {
        { name = 'buffer' }
    }
})

-- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline(':', {
    sources = {
        { name = 'path' },
        { name = 'cmdline' }
    }
})
