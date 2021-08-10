
nnoremap <C-p> :Telescope find_files<cr>
nnoremap <C-b> :Telescope buffers<cr>
nnoremap - :Telescope current_buffer_fuzzy_find<cr>

autocmd User TelescopeFindPre call s:TelescopeHighlight()


function! s:TelescopeHighlight()
    highlight TelescopeSelection      guifg=#20BBFC gui=bold
	highlight TelescopeSelectionCaret guifg=#20BBFC gui=bold
	highlight TelescopeMultiSelection guifg=#fff guibg=#2C81FB
	highlight TelescopeNormal         guibg=#00000

	" Border highlight groups
    highlight TelescopeBorder         guifg=#FFFFFF
    highlight TelescopePromptBorder   guifg=#FFFFFF gui=bold
    highlight TelescopeResultsBorder  guifg=#D4D4D4
    highlight TelescopePreviewBorder  guifg=#D4D4D4

	" Highlight characters your input matches
    highlight TelescopeMatching       guifg=#20BBFC gui=italic

	" Color the prompt prefix
	highlight TelescopePromptPrefix   guifg=#20BBFC
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
            '.git',
            '.spl$',
            '.sug$',
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
                '!{vendor,.git,node_modules}',
                '--hidden'
            }
        }
    }
}
