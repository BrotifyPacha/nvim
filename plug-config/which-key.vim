" Define a separator
let g:which_key_sep = ''

" Not a fan of floating windows for this
let g:which_key_use_floating_win = 0

" Change the colors if you want
highlight default link WhichKey           ErrorMsg
highlight default link WhichKeySeperator  MoreMsg
highlight default link WhichKeyGroup      Identifier
highlight default link WhichKeyDesc       Function


" Hide status line
augroup which_key
  autocmd!
  autocmd FileType which_key set laststatus=0 noshowmode noruler
        \|autocmd BufLeave <buffer> set laststatus=2 noshowmode ruler
augroup end

let g:which_key_max_size = 0
let g:which_key_hspace = 40

" Create map to add keys to
let g:which_key_map =  {}

" Make useless keybind invisible
let g:which_key_map['+'] = 'which_key_ignore'

let g:which_key_map['e'] = [ ':CocCommand explorer' , 'explorer' ]
let g:which_key_map['f'] = [ ':call WhichKeyByFiletype()', '+filetype action' ]
let g:which_key_map['l'] = [ '<C-w>l'               , 'which_key_ignore']
let g:which_key_map['h'] = [ '<C-w>h'               , 'which_key_ignore']
let g:which_key_map['j'] = [ '<C-w>j'               , 'which_key_ignore']
let g:which_key_map['k'] = [ '<C-w>k'               , 'which_key_ignore']
let g:which_key_map['H'] = [ ':vsplit'              , 'which_key_ignore']
let g:which_key_map['J'] = [ ':bel split'           , 'which_key_ignore']
let g:which_key_map['K'] = [ ':split'               , 'which_key_ignore']
let g:which_key_map['L'] = [ ':vert bel split'      , 'which_key_ignore']
let g:which_key_map['o'] = [ ':let g:goyo_preset=1 \|Goyo' , 'goyo' ]
let g:which_key_map['p'] = [ ':let g:goyo_preset=2 \|Goyo' , 'goyo' ]
let g:which_key_map['i'] = [ ':let g:goyo_preset=3 \|Goyo' , 'goyo' ]

nnoremap <leader>l <C-w>l
nnoremap <leader>h <C-w>h
nnoremap <leader>j <C-w>j
nnoremap <leader>k <C-w>k
nnoremap <leader>H :vsplit<cr>
nnoremap <leader>J :bel split<cr>
nnoremap <leader>K :split<cr>
nnoremap <leader>L :vert bel split<cr>
nnoremap <leader>o :let g:goyo_preset=1 \|Goyo<cr>
nnoremap <leader>p :let g:goyo_preset=2 \|Goyo<cr>
nnoremap <leader>i :let g:goyo_preset=3 \|Goyo<cr>

function! WhichKeyByFiletype()
  if (len(&ft) == 0)
    WhichKey "vim"
    return
  endif
  WhichKey &ft
endfunction

let g:which_key_map.w = {
      \ 'name' : '+window' ,
      \ 'q' : [':q'             , 'quit'],
      \ 'w' : [':w'             , 'save'],
      \ 'd' : [':windo diffthis', 'diff windows'],
      \ 'r' : ['<C-w>r'         , 'rotate'],
      \ '3' : [':call ChangeWindowSize(3)', 'resize window to 1/3'],
      \ '4' : [':call ChangeWindowSize(4)', 'resize window to 1/4'],
      \ }

nnoremap <leader>wq :q<cr>
nnoremap <leader>ww :w<cr>
nnoremap <leader>wd :windo diffthis<cr>
nnoremap <leader>wr <C-w>r
nnoremap <leader>w2 :call ChangeWindowSize(2)<cr>
nnoremap <leader>w3 :call ChangeWindowSize(3)<cr>
nnoremap <leader>w4 :call ChangeWindowSize(4)<cr>
nnoremap <leader>w5 :call ChangeWindowSize(5)<cr>

function! ChangeWindowSize(size)
  execute 'vert resize ' &columns / a:size
endfunction


let g:which_key_map.g = {
      \ 'name' : '+git' ,
      \ 'l' : [':G push'               , 'push'],
      \ 'h' : [':G pull'               , 'pull'],
      \ 'v' : [':bel vert G log --oneline --graph --decorate --branches', 'view log'],
      \ 'g' : [':bel vert G'           , 'status'],
      \ 'c' : [':bel vert G'           , 'commit'],
      \ 'a' : [':bel vert G'           , 'amend'],
      \ 'd' : [':Gdiffsplit'           , 'diff with index'],
      \ 'b' : [':lua require\"gitsigns\".blame_line(true)' , 'status'],
      \ 'u' : [':lua require\"gitsigns\".reset_hunk()'     , 'undo hunk'],
      \ 's' : [':lua require\"gitsigns\".stage_hunk()'     , 'stage hunk'],
      \ 'p' : [':lua require\"gitsigns\".preview_hunk()'   , 'preview hunk'],
      \ }

nnoremap <leader>gl :G push<cr>
nnoremap <leader>gh :G pull<cr>
nnoremap <leader>gv :bel vert G log --oneline --graph --decorate --branches<cr>
nnoremap <leader>gg :bel vert G<cr>:wincmd L<cr>
nnoremap <leader>gc :G commit<cr>
nnoremap <leader>gd :Gdiffsplit<cr>
nnoremap <leader>gb :lua require'gitsigns'.blame_line(true)<cr>
nnoremap <leader>gu :lua require'gitsigns'.reset_hunk()<cr>
nnoremap <leader>gs :lua require'gitsigns'.stage_hunk()<cr>
nnoremap <leader>gp :lua require'gitsigns'.preview_hunk()<cr>

let g:which_key_map.r = {
      \ 'name' : '+refactor' ,
      \ 'r' : [':call RenameLocalVariable()'              , 'rename local'],
      \ 't' : [':call formatting#toggle_multiline_args()' , 'toggle args'],
      \ 's' : [':call formatting#go_snake_case(0)'        , 'go snake_case'],
      \ 'S' : [':call formatting#go_snake_case(1)'        , 'go SNAKE_CASE'],
      \ 'c' : [':call formatting#go_camel_case(0)'        , 'go camelCase'],
      \ 'C' : [':call formatting#go_camel_case(1)'        , 'go CamelCase'],
      \ 'm' : [':call formatting#squash_blank_lines()'    , 'merge blanks'],
      \ 'd' : [':call AddDocString()'                     , 'add doc string'],
      \ }

nnoremap <leader>rr :call RenameLocalVariable()<cr>
nnoremap <leader>rt :call formatting#toggle_multiline_args()<cr>
nnoremap <leader>rs :call formatting#go_snake_case(0)<cr>
nnoremap <leader>rS :call formatting#go_snake_case(1)<cr>
nnoremap <leader>rc :call formatting#go_camel_case(0)<cr>
nnoremap <leader>rC :call formatting#go_camel_case(1)<cr>
nnoremap <leader>rd :call AddDocString()<cr>


let g:which_key_map.t = {
      \ 'name' : '+tab' ,
      \ 'd' : [':tcd %:h'                           , 'change tab dir to file'],
      \ 't' : [':tabnew'                            , 'create new tab'],
      \ 'c' : [':tabclose'                          , 'close current tab'],
      \ 'l' : [':tabmove +1'                        , 'move tab right'],
      \ 'h' : [':tabmove -1'                        , 'move tab left'],
      \ }

let g:which_key_map.b = {
      \ 'name' : '+buffer' ,
      \ 'b' : [':bw!'                              , 'wipe buffer'],
      \ 'l' : ['buffers'                           , 'list buffers'],
      \ 'n' : ['bnext'                             , 'next buffer'],
      \ 'p' : ['bprevious'                         , 'previous buffer'],
      \ }

let g:which_key_spell_map = {
      \ 'g' :    ['zg'                             , 'spelled good'],
      \ 'b' :    ['zw'                             , 'spelled bad'],
      \ 'u' :    [':spellundo'                     , 'spell undo'],
      \ '<F2>' : [':ToggleSpell'                   , 'toggle spell'],
      \ }

let g:which_key_list_map = {
      \ '<F5>' : ['call feedkeys(":registers\<cr>")'  , 'list registers'],
      \ '<F6>' : ['call feedkeys(":buffers\<cr>")'    , 'list buffers'],
      \ '<F7>' : ['call feedkeys(":autocmd ")'        , 'list autocmds'],
      \ '<F8>' : ['call feedkeys(":10messages\<cr>")' , 'list 10 last messages'],
      \ }

let g:which_key_util_map = {
      \ '<F4>' : [':CocCommand prettier.formatFile', 'format file'],
      \ '3'    : [':set ff=dos'                    , 'set ff=dos'],
      \ '4'    : [':set ff=unix'                   , 'set ff=unix'],
      \ }

let g:which_key_util_map.e = {
            \ 'name' : '+edit in enc',
            \ 'e' : [':edit!' , 'edit as is'],
            \ 'c' : [':edit! ++enc=cp1251' , 'edit as cp1251'],
            \ 'u' : [':edit! ++enc=utf-8' , 'edit as utf8'],
            \ 'l' : [':edit! ++enc=latin1' , 'edit as latin1'],
            \ }

let g:which_key_util_map.c = {
            \ 'name' : '+convert',
            \ 'c' : [':set fileencoding=cp1251 | w!' , 'convert to cp1251'],
            \ 'u' : [':set fileencoding=utf8 | w!'   , 'convert to utf8'],
            \ 'l' : [':set fileencoding=latin1 | w!' , 'convert to latin1'],
            \ }

let g:which_key_term_map = {
      \ '<F9>' : [':call ReopenTerminal()'         , 're-open term'],
      \ '<F10>': [':call NewTerminal()'            , 'open new term'],
      \ 'p': [':call RunCommand("python", "")'     , 'open python'],
      \ 'q': [':setlocal syntax='                  , 'clear syntax'],
      \ 'l': [':setlocal syntax=log'               , 'log syntax'],
      \ }

" Filetype specific keymaps maps - starts via <leader>f
let g:which_key_vim_map = {
      \ 'h'    : [':vert bo split $vimruntime\syntax\hitest.vim | so % | wincmd p | wincmd q' , 'open hitest'],
      \ 'g'    : [':call feedkeys(":call SynStack()\<cr>")' , 'show hi group'],
      \ 'r'    : [':source %'                               , 'source %'],
      \ 'v'    : [':source $MYVIMRC'                        , 'source vimrc'],
      \ 'c'    : {
          \ 'name' : 'change filetype',
          \ 'p' : ['set ft=php', 'php']
          \}
      \}

let g:which_key_python_map = {
      \ 'i'    : [':call feedkeys("G?\\v^(import|from)\<cr>o")' , 'go to imports'],
      \ 'r'    : [':call RunCommand("python", expand("%"))' , 'run python script'],
      \}

let g:which_key_markdown_map = {
      \ 'p'    : [':MarkdownPreviewToggle' , 'toggle preview'],
      \}

function! SynStack()
  echom map(synstack(line('.'), col('.')), 'synIDattr(v:val, "name, fg, bg")')
endfunc
" Map leader to which_key
" Register which key map
call which_key#register('<Space>'                 , "g:which_key_map")
call which_key#register('spell_menu'              , "g:which_key_spell_map")
call which_key#register('list_menu'               , "g:which_key_list_map")
call which_key#register('file_menu'               , "g:which_key_util_map")
call which_key#register('display_menu'            , "g:which_key_display_map")
call which_key#register('term_menu'               , "g:which_key_term_map")


nnoremap <silent> <leader> :silent WhichKey '<Space>'<CR>
nnoremap <silent> <F2> :silent WhichKey 'spell_menu'<CR>
nnoremap <silent> <F3> :silent WhichKey 'list_menu'<CR>
nnoremap <silent> <F4> :silent WhichKey 'file_menu'<CR>
nnoremap <silent> <F9> :silent WhichKey 'term_menu'<CR>
vnoremap <silent> <leader> :silent <C-u>WhichKeyVisual '<Space>'<CR>

call which_key#register('vim', "g:which_key_vim_map")
call which_key#register('python', "g:which_key_python_map")
call which_key#register('markdown', "g:which_key_markdown_map")

let g:which_key_php_map = {
      \}

