
local h = require 'ui.helpers'

h.link('TelescopeSelection',      'WinBar')
h.link('TelescopeSelectionCaret', 'String')
h.link('TelescopeMultiSelection', 'Title')
h.link('TelescopeNormal',         'Normal')
h.link('TelescopeMatching',       'DiffText')
h.link('TelescopePromptPrefix',   'String')


require "telescope".setup{
  defaults = {
    layout_strategy = 'vertical',
    layout_config = {
      mirror = true,
      width = 0.6,
    },
    winblend = -1,
    file_ignore_patterns = {
      'node_modules',
      'vendor',
      '\\.git',
      '\\.spl$',
      '\\.sug$',
    },
    multi_icon = '   ',
    selection_caret = '   ',
    entry_prefix = '    ',
    prompt_prefix = '   ',
    vimgrep_arguments = {
      'rg',
      '--color=never',
      '--no-heading',
      '--with-filename',
      '--line-number',
      '--column',
      '--smart-case',
      '--hidden',
      '--glob',
      '!{.git,node_modules,.svn}',
    },
    mappings = {
      i = {
        ["<C-q>"] = require('telescope.actions').smart_send_to_qflist + require('telescope.actions').open_qflist,
        ["<C-t>"] = require('telescope.actions').toggle_selection + require('telescope.actions').move_selection_next,
        ["<Tab>"] = require('telescope.actions').toggle_selection
      },
      n = {
        ["<C-q>"] = require('telescope.actions').smart_send_to_qflist + require('telescope.actions').open_qflist,
        ["<C-t>"] = require('telescope.actions').toggle_selection + require('telescope.actions').move_selection_next,
        ["<Tab>"] = require('telescope.actions').toggle_selection
      }
    }
  },
  pickers = {
    buffers = {
      theme = 'dropdown',
      previewer = false
    },
    live_grep = {
      only_sort_text = true,
      mappings = {
        i = {
          ["<C-f>"] = require('telescope.actions').to_fuzzy_refine,
        },
        n = {
          ["<C-f>"] = require('telescope.actions').to_fuzzy_refine,
        },
      },
    },
    find_files = {
      -- theme = 'dropdown'
      find_command = {
        'rg',
        '--files',
        '--glob',
        '!{.git,node_modules,.svn,zsh-hist}',
        '--no-ignore',
        '--hidden'
      }
    },
    git_branches = {
      mappings = {
        i = {
          ["<C-f>"] = function(bufnr) 
            local action_state = require "telescope.actions.state"
            local current_picker = action_state.get_current_picker(bufnr)

            local current = action_state.get_current_line()

            local looplist = {
              "release/COREMON-",
              "COREMON-",
              "feature/COREMON-",
              "hotfix/COREMON-",
              "release/" .. vim.fn.strftime("%Y-%m-%d-01"),
            }

            local idx = require("user.helpers").contains(looplist, current)
            print("len = ", #looplist, "found = ", idx)
            if idx == nil or idx == #looplist then
              current_picker:set_prompt(looplist[1])
              return
            end

            current_picker:set_prompt(looplist[(idx + 1)])

          end,
        }
      }
    }
  }
}
