
vim.api.nvim_command [[
    highlight! link TSCurrentScope PmenuBg
    highlight! link TSDefinition PmenuBg
    highlight! link TSDefinitionUsage Underlined
]]

require 'nvim-treesitter.configs'.setup {
    query_linter = {
        enable = true,
        use_virtual_text = true,
        lint_events = {"BufWrite", "CursorHold"},
    },
    highlight = {
        enable = true,
        use_languagetree = false, -- Use this to enable language injection
    },
    indent = {
        enable = true,
        disable = { "go" }
    },
    refactor = {
        highlight_current_scope = {
            enable = false,
            disable = { "php" }
        },
        highlight_definitions = { enable = true },
        smart_rename = {
            enable = true,
            keymaps = {
                smart_rename = "<space>rr"
            }
        },
        navigation = {
            enable = true,
            keymaps = {
                list_definitions_toc = "gO"
            }
        }
    },
    textobjects = {
        select = {
            enable = true,
            -- Automatically jump forward to textobj, similar to targets.vim 
            lookahead = true,
            keymaps = {
                ["af"] = "@function.outer",
                ["if"] = "@function.inner",
                ["ac"] = "@class.outer",
                ["ic"] = "@class.inner",
                ["ie"] = "@expression.inner",
            },
        },
    },
    -- Use :TSPlaygroundToggle
    playground = {
        enable = true,
        disable = {},
        updatetime = 25, -- Debounced time for highlighting nodes in the playground from source code
        persist_queries = false, -- Whether the query persists across vim sessions
        keybindings = {
            toggle_query_editor = 'o',
            toggle_hl_groups = 'i',
            toggle_injected_languages = 't',
            toggle_anonymous_nodes = 'a',
            toggle_language_display = 'I',
            focus_language = 'f',
            unfocus_language = 'F',
            update = 'R',
            goto_node = '<cr>',
            show_help = '?',
        }
    }
}
