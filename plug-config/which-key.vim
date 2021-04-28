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
let g:which_key_map[' '] = [ ':call SearchForMacroPlaceholder()', 'go to next '.g:macro_placeholder ]
let g:which_key_map['o'] = [ ':Goyo'                , 'goyo' ]


nnoremap <leader>l <C-w>l
nnoremap <leader>h <C-w>h
nnoremap <leader>j <C-w>j
nnoremap <leader>k <C-w>k
nnoremap <leader>H :vsplit<cr>
nnoremap <leader>J :bel split<cr>
nnoremap <leader>K :split<cr>
nnoremap <leader>L :vert bel split<cr>
nnoremap <leader>o :Goyo<cr>

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
      \ 'r' : ['<C-w>r'         , 'rotate'],
      \ 'o' : ['<C-w>o'         , 'make the only'],
      \ 't' : [':call ToggleMaximizedWindow()', 'maximize/minimize window'],
      \ }
nnoremap <leader>wq :q<cr>
nnoremap <leader>ww :w<cr>
nnoremap <leader>wr <C-w>r
nnoremap <leader>wo <C-w>o
nnoremap <leader>wt :call ToggleMaximizedWindow()<cr>

function! ToggleMaximizedWindow()
  if exists("g:custom_is_window_maximized")
    unlet g:custom_is_window_maximized
    wincmd =
  else
    let g:custom_is_window_maximized = 1
    wincmd _
    wincmd |
  endif
endfunction

function! OpenGrep(inCurrentFile)
  let command = "\<esc>:vimgrep//j "
  let tail = ""
  if a:inCurrentFile
    let tail = "%"
  else
    let tail = "**/*." . expand("%:e")
  endif
  call feedkeys(command . tail)
  for c in range(1, len(tail) + 3)
    call feedkeys("\<left>")
  endfor
endfunction


let g:which_key_map.s = {
      \ 'name' : '+search' ,
      \ 'f' : [':call feedkeys("\<esc>:find ")' , 'find file'],
      \ 'g' : [':call OpenGrep(0)'              , 'grep files'],
      \ 'G' : [':call OpenGrep(1)'              , 'grep this File'],
      \ }


let g:which_key_map.g = {
      \ 'name' : '+git' ,
      \ 'l' : [':G push'               , 'push'],
      \ 'h' : [':G pull'               , 'pull'],
      \ 'v' : [':bel vert G log'       , 'view log'],
      \ 'g' : [':bel vert G'           , 'status'],
      \ 'd' : [':Gdiffsplit'           , 'diff with index'],
      \ 'b' : [':G blame'              , 'status'],
      \ 'j' : [':GitGutterNextHunk'    , 'next hunk'],
      \ 'k' : [':GitGutterPrevHunk'    , 'previous hunk'],
      \ 'u' : [':GitGutterUndoHunk'    , 'undo hunk'],
      \ 's' : [':GitGutterStageHunk'   , 'stage hunk'],
      \ 'p' : [':GitGutterPreviewHunk' , 'preview hunk'],
      \ }

nnoremap <leader>gl :G push<cr>
nnoremap <leader>gh :G pull<cr>
nnoremap <leader>gv :bel vert G log<cr>
nnoremap <leader>gg :bel vert G<cr>
nnoremap <leader>gd :Gdiffsplit<cr>
nnoremap <leader>gb :G blame<cr>
nnoremap <leader>gj :GitGutterNextHunk<cr>
nnoremap <leader>gk :GitGutterPrevHunk<cr>
nnoremap <leader>gu :GitGutterUndoHunk<cr>
nnoremap <leader>gs :GitGutterStageHunk<cr>
nnoremap <leader>gp :GitGutterPreviewHunk<cr>

let g:which_key_map.r = {
      \ 'name' : '+refactor' ,
      \ 'r' : [':call RenameLocalVariable()'              , 'rename local'],
      \ 't' : [':call formatting#toggle_multiline_args()' , 'toggle args'],
      \ 's' : [':call formatting#go_snake_case(0)'        , 'go snake_case'],
      \ 'S' : [':call formatting#go_snake_case(1)'        , 'go SNAKE_CASE'],
      \ 'c' : [':call formatting#go_camel_case(0)'        , 'go camelCase'],
      \ 'C' : [':call formatting#go_camel_case(1)'        , 'go CamelCase'],
      \ 'd' : [':call AddDocString()'                     , 'add doc string'],
      \ }

nnoremap <leader>rr :call RenameLocalVariable()<cr>
nnoremap <leader>rt :call formatting#toggle_multiline_args()<cr>
nnoremap <leader>rs :call formatting#go_snake_case(0)<cr>
nnoremap <leader>rS :call formatting#go_snake_case(1)<cr>
nnoremap <leader>rc :call formatting#go_camel_case(0)<cr>
nnoremap <leader>rC :call formatting#go_camel_case(1)<cr>
nnoremap <leader>rd :call AddDocString()<cr>

let g:which_key_map.d = {
      \ 'name' : '+diff action' ,
      \ 'w'   : [':windo diffthis'                 , 'diff windows'],
      \ 's'   : [':DiffSaved'                      , 'diff saved'],
      \ 'h'   : [':diffget'                        , 'pull from other file'],
      \ 'l'   : [':diffput'                        , 'put to other file'],
      \ 'o'   : [':DiffOff'                        , 'close diff windows'],
      \ }

nnoremap <leader>dw :windo diffthis<cr>
nnoremap <leader>ds :DiffSaved<cr>
nnoremap <leader>dh :diffget<cr>
nnoremap <leader>dl :diffput<cr>
nnoremap <leader>do :DiffOff<cr>

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
      \ '<F3>' : [':AutoCorrectWord'               , 'auto correct'],
      \ }

let g:which_key_list_map = {
      \ '<F5>' : ['call feedkeys(":registers\<cr>")'  , 'list registers'],
      \ '<F6>' : ['call feedkeys(":buffers\<cr>")'    , 'list buffers'],
      \ '<F7>' : ['call feedkeys(":autocmd ")'        , 'list buffers'],
      \ '<F8>' : ['call feedkeys(":10messages\<cr>")' , 'list 10 last messages'],
      \ }

let g:which_key_util_map = {
      \ '<F4>' : [':CocCommand prettier.formatFile', 'format file'],
      \ '<F5>' : [':edit!'                         , 'refresh file'],
      \ '`'    : [':cd %:h'                        , 'cd to file'],
      \ '1'    : [':edit! ++enc=utf-8'             , 'open in UTF-8'],
      \ '2'    : [':edit! ++enc=cp1251'            , 'open in cp1251'],
      \ '3'    : [':set ff=dos'                    , 'set ff=dos'],
      \ '4'    : [':set ff=unix'                   , 'set ff=unix'],
      \ 's'    : [':UltiSnipsEdit'                 , 'edit snippets'],
      \ ' '   : ['call feedkeys("mm:%s/\\s\\+$//\<cr>`m")', 'remove trailing whitespaces'],
      \ }

let g:which_key_term_map = {
      \ '<F9>' : [':call OpenTerminal()'                 , 'open term'],
      \ '<F10>': [':call RunCommand("python", "")'       , 'open python'],
      \ }

" Filetype specific keymaps maps - starts via <leader>f
let g:which_key_vim_map = {
      \ 'h'    : [':vert bo split $vimruntime\syntax\hitest.vim | so % | wincmd p | wincmd q' , 'open hitest'],
      \ 'g'    : [':call feedkeys(":call SynStack()\<cr>")' , 'show hi group'],
      \ 'r'    : [':source %'                               , 'source %'],
      \ 'v'    : [':source $MYVIMRC'                        , 'source vimrc'],
      \}

let g:which_key_python_map = {
      \ 'i'    : [':call feedkeys("G?\\v^(import|from)\<cr>o")' , 'go to imports'],
      \ 'r'    : [':call RunCommand("python", expand("%"))' , 'run python script'],
      \}

function! SynStack()
  echom map(synstack(line('.'), col('.')), 'synIDattr(v:val, "name, fg, bg")')
endfunc
" Map leader to which_key
if v:version >= 800
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
endif

let g:which_key_php_map = {
      \}

