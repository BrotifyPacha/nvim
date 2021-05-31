
" let g:ctrlp_extensions = ['quickfix', 'line', 'changes', 'mixed']
"
let g:ctrlp_show_hidden = 1
let g:ctrlp_custom_ignore = {
      \ 'dir':  '\v[\/](\.(git|hg|svn)|vendor)$',
      \ 'file': '\v\.(exe|so|dll)$',
      \ }
let g:ctrlp_open_multiple_files = 'vj'

nnoremap - :CtrlPLine<cr>
