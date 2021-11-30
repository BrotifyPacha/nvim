
let g:vdebug_options = {
            \ 'break_on_open' : 0,
            \ 'path_maps' : {
                \'/home/pgusev/workspace/retorr': '/home/pgusev/workspace/servers/devel2/workspace/retorr'
                \}
            \}

let g:vdebug_keymap = {
\    'run'               : '<leader>ds',
\    'run_to_cursor'     : '<F13>',
\    'step_over'         : '<leader>dj',
\    'step_into'         : '<leader>dl',
\    'step_out'          : '<leader>dh',
\    'close'             : '<leader>dc',
\    'detach'            : '<F13>',
\    'set_breakpoint'    : '<leader>dd',
\    'get_context'       : '<leader>dp',
\    'eval_under_cursor' : '<leader>de',
\    'eval_visual'       : '<F13>'
\}
" let g:vdebug_keymap_defaults = {}

nnoremap <F12> :BreakpointToggle<cr>
