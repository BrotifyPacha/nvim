
nnoremap <C-p> :Telescope find_files<cr>
nnoremap <C-b> :Telescope buffers<cr>
nnoremap - :Telescope current_buffer_fuzzy_find<cr>

autocmd User TelescopeFindPre call s:TelescopeHighlight()


function! s:TelescopeHighlight()
	highlight TelescopeSelection      guifg=#2C81FB gui=bold
	highlight TelescopeSelectionCaret guifg=#2C81FB
	highlight TelescopeMultiSelection guifg=#fff guibg=#2C81FB
	highlight TelescopeNormal         guibg=#00000

	" Border highlight groups
    highlight TelescopeBorder         guifg=#FFFFFF gui=bold
    highlight TelescopePromptBorder   guifg=#FFFFFF gui=bold
    highlight TelescopeResultsBorder  guifg=#FFFFFF gui=bold
    highlight TelescopePreviewBorder  guifg=#FFFFFF gui=bold

	" Highlight characters your input matches
	highlight TelescopeMatching       guifg=#E32791

	" Color the prompt prefix
	highlight TelescopePromptPrefix   guifg=#2C81FB
endfunction

lua << EOF
require "telescope".setup{
    defaults = {
        layout_strategy = 'vertical',
    },
    pickers = {
        buffers = {
            initial_mode = 'normal',
            theme = 'dropdown',
            previewer = false
        },
        -- find_files = { theme = 'dropdown' }
    }
}
