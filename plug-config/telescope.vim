
" Pre-populate Telescope command
nnoremap <C-t> :Telescope 

nnoremap <C-p> :Telescope find_files<cr>
nnoremap <C-g> :Telescope live_grep<cr>
nnoremap <C-h> :Telescope git_status<cr>
nnoremap - :Telescope current_buffer_fuzzy_find<cr>

" autocmd User TelescopeFindPre call TelescopeHighlight()


highlight! link TelescopeSelection      WinBar
highlight! link TelescopeSelectionCaret String
highlight! link TelescopeMultiSelection Title
highlight! link TelescopeNormal         Normal
highlight! link TelescopeMatching       Question
highlight! link TelescopePromptPrefix   String

lua << EOF
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
                ["<C-t>"] = require('telescope.actions').toggle_selection + require('telescope.actions').move_selection_next,
                ["<Tab>"] = require('telescope.actions').toggle_selection
            },
            n = {
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
        find_files = {
            -- theme = 'dropdown'
            find_command = {
                'rg',
                '--files',
                '--glob',
                '!{.git,node_modules,.svn}',
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
