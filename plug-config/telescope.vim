
" Pre-populate Telescope command
nnoremap <C-t> :Telescope 

nnoremap <C-p> :Telescope find_files<cr>
nnoremap <C-b> :Telescope buffers<cr>
nnoremap <C-g> :Telescope live_grep<cr>
nnoremap <C-h> :Telescope git_status<cr>
nnoremap - :Telescope current_buffer_fuzzy_find<cr>

autocmd User TelescopeFindPre call s:TelescopeHighlight()


function! s:TelescopeHighlight()
    highlight TelescopeSelection      guifg=#F1F1F1
    highlight TelescopeSelectionCaret guifg=#F1F1F1
	highlight TelescopeMultiSelection guifg=#F1F1F1 guibg=#2C81FB
	highlight TelescopeNormal         guifg=#8E8E8E guibg=none

	" Border highlight groups
    highlight TelescopeBorder         guifg=#FFFFFF
    highlight TelescopePromptBorder   guifg=#FFFFFF gui=bold
    highlight TelescopeResultsBorder  guifg=#8E8E8E
    highlight TelescopePreviewBorder  guifg=#8E8E8E

	" Highlight characters your input matches
    highlight TelescopeMatching       guifg=#20BBFC

	" Color the prompt prefix
	highlight TelescopePromptPrefix   guifg=#8E8E8E
endfunction

lua << EOF
require "telescope".setup{
    defaults = {
        layout_strategy = 'vertical',
        layout_config = {
            mirror = true,
            width = 0.6,
        },
        winblend = 5,
        file_ignore_patterns = {
            'node_modules',
            'vendor',
            '\\.git',
            '\\.spl$',
            '\\.sug$',
        },
        selection_caret = ' > ',
        entry_prefix = '   ',
        prompt_prefix = ' > ',
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
                '!{vendor,.git,node_modules,.svn}',
                '--hidden'
            }
        }
    }
}
