" Map leader to which_key
nnoremap <silent> <leader> :silent WhichKey '<Space>'<CR>
nnoremap <silent> <F2> :silent WhichKey '<F2>'<CR>
nnoremap <silent> <F8> :silent WhichKey '<F8>'<CR>
vnoremap <silent> <leader> :silent <C-u>WhichKeyVisual '<Space>'<CR>

" Define a separator
let g:which_key_sep = '→'

" Not a fan of floating windows for this
let g:which_key_use_floating_win = 0

" Change the colors if you want
highlight default link WhichKey          Operator
highlight default link WhichKeySeperator DiffAdded
highlight default link WhichKeyGroup     Identifier
highlight default link WhichKeyDesc      Function


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
let g:which_key_map['l'] = [ '<C-w>l'               , 'which_key_ignore']
let g:which_key_map['h'] = [ '<C-w>h'               , 'which_key_ignore']
let g:which_key_map['j'] = [ '<C-w>j'               , 'which_key_ignore']
let g:which_key_map['k'] = [ '<C-w>k'               , 'which_key_ignore']
let g:which_key_map['H'] = [ ':vsplit'              , 'which_key_ignore']
let g:which_key_map['J'] = [ ':bel split'           , 'which_key_ignore']
let g:which_key_map['K'] = [ ':split'               , 'which_key_ignore']
let g:which_key_map['L'] = [ ':vert bel split'      , 'which_key_ignore']
let g:which_key_map[' '] = [ ':call SearchForMacroPlaceholder()', 'go to next '.g:macro_placeholder ]

let g:which_key_map.w = {
      \ 'name' : '+window' ,
      \ 'q' : [':q'             , 'quit'],
      \ 'w' : [':w'             , 'save'],
      \ 'r' : ['<C-w>r'         , 'rotate'],
      \ 'o' : ['<C-w>o'         , 'make the only'],
      \ }

function OpenGrep(inCurrentFile)
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
      \ 'j' : [':GitGutterNextHunk'    , 'next hunk'],
      \ 'k' : [':GitGutterPrevHunk'    , 'previous hunk'],
      \ 'u' : [':GitGutterUndoHunk'    , 'undo hunk'],
      \ 's' : [':GitGutterStageHunk'   , 'stage hunk'],
      \ 'p' : [':GitGutterPreviewHunk' , 'preview hunk'],
      \ }


let g:which_key_map.r = {
      \ 'name' : '+refactor' ,
      \ 'r' : [':call RenameLocalVariable()' , 'rename local'],
      \ 't' : [':call ToggleMultilineArgs()' , 'toggle args'],
      \ 'd' : [':call AddDocString()'        , 'add doc string'],
      \ }
vnoremap <leader>re :<C-u>call ExtractMethod()<cr>


let g:which_key_map.f = {
      \ 'name' : '+filetype action',
      \ }

let g:which_key_map.d = {
      \ 'name' : '+diff action' ,
      \ 'w'   : [':windo diffthis'                 , 'diff windows'],
      \ 's'   : [':DiffSaved'                      , 'diff saved'],
      \ 'o'   : [':DiffOff'                        , 'close diff windows'],
      \ }


let g:which_key_map.b = {
      \ 'name' : '+buffer' ,
      \ 'd' : ['bd'                                , 'delete-buffer'],
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
let g:which_key_util_map = {
      \ '<F8>' : [':edit!'                         , 'refresh file'],
      \ '1'    : [':edit! ++enc=utf-8'             , 'open in UTF-8'],
      \ '2'    : [':edit! ++enc=cp1251'            , 'open in cp1251'],
      \ '3'    : [':set ff=dos'                    , 'set ff=dos'],
      \ '4'    : [':set ff=unix'                   , 'set ff=unix'],
      \ '-'    : [':cd %:h'                        , 'cd to file'],
      \ '='    : [':CocCommand prettier.formatFile', 'format file'],
      \ }

call which_key#register('<F2>', "g:which_key_spell_map")
call which_key#register('<F8>', "g:which_key_util_map")

" Register which key map
call which_key#register('<Space>', "g:which_key_map")
