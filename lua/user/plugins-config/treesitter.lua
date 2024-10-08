
vim.api.nvim_command [[
    highlight! link TSCurrentScope PmenuBg
    highlight! link TSDefinition PmenuBg
    highlight! link TSDefinitionUsage Underlined
    highlight! link @variable @text
    highlight! link @namespace @text
]]

require 'nvim-treesitter.configs'.setup {
  ensure_installed = {
    'lua',
    'go',
    'vim',
  },
  query_linter = {
    enable = true,
    use_virtual_text = true,
    lint_events = {"BufWrite", "CursorHold"},
  },
  highlight = {
    enable = true,
    use_languagetree = true, -- Use this to enable language injection
    disable = { "vimdoc" }
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
    highlight_definitions = {
      enable = false,
      disable = { "markdown" },
    },
    smart_rename = {
      enable = true,
      keymaps = {
        smart_rename = "<space>rR"
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
