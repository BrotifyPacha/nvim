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

function WhichKeyByFiletype()
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
      \ 'b' : [':G blame'              , 'status'],
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

let g:which_key_map.d = {
      \ 'name' : '+diff action' ,
      \ 'w'   : [':windo diffthis'                 , 'diff windows'],
      \ 's'   : [':DiffSaved'                      , 'diff saved'],
      \ 'h'   : [':diffget'                        , 'pull from other file'],
      \ 'l'   : [':diffput'                        , 'put to other file'],
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

let g:which_key_list_map = {
      \ '<F5>' : ['call feedkeys(":registers\<cr>")'  , 'list registers'],
      \ '<F6>' : ['call feedkeys(":buffers\<cr>")'    , 'list buffers'],
      \ '<F7>' : ['call feedkeys(":autocmd ")'        , 'list buffers'],
      \ '<F8>' : ['call feedkeys(":10messages\<cr>")' , 'list 10 last messages'],
      \ }

let g:which_key_util_map = {
      \ '<F4>' : [':edit!'                         , 'refresh file'],
      \ '1'    : [':edit! ++enc=utf-8'             , 'open in UTF-8'],
      \ '2'    : [':edit! ++enc=cp1251'            , 'open in cp1251'],
      \ '3'    : [':set ff=dos'                    , 'set ff=dos'],
      \ '4'    : [':set ff=unix'                   , 'set ff=unix'],
      \ '-'    : [':cd %:h'                        , 'cd to file'],
      \ '='    : [':CocCommand prettier.formatFile', 'format file'],
      \ ' '    : [':call RemoveTrailingWhitespaces()', 'go to trailing whitespace'],
      \ }
function RemoveTrailingWhitespaces()
  normal! mm
  execute "%s/\\s\\+$//"
  normal! `m
endfunction

let g:which_key_term_map = {
      \ '<F9>' : [':term'                          , 'open term'],
      \ '<F10>': [':call LaunchTermInGitDir()'     , 'open term in root'],
      \ '<F11>': [':term python'                   , 'open python'],
      \ }

function LaunchTermInGitDir()
  let path = FugitiveGitDir()[0:-5]
  if (len(path) != 0)
    call feedkeys("\<esc>:term\<cr>acd /D ".path."\<cr>")
  else
    call feedkeys("\<esc>:term\<cr>acd /D ".expand("%:h"))
  endif
endfunction

" Register which key map
call which_key#register('<Space>'                 , "g:which_key_map")
call which_key#register('spell_menu'              , "g:which_key_spell_map")
call which_key#register('list_menu'               , "g:which_key_list_map")
call which_key#register('file_menu'               , "g:which_key_util_map")
call which_key#register('display_menu'            , "g:which_key_display_map")
call which_key#register('term_menu'               , "g:which_key_term_map")

" Map leader to which_key
nnoremap <silent> <leader> :silent WhichKey '<Space>'<CR>
nnoremap <silent> <F2> :silent WhichKey 'spell_menu'<CR>
nnoremap <silent> <F3> :silent WhichKey 'list_menu'<CR>
nnoremap <silent> <F4> :silent WhichKey 'file_menu'<CR>
nnoremap <silent> <F9> :silent WhichKey 'term_menu'<CR>
vnoremap <silent> <leader> :silent <C-u>WhichKeyVisual '<Space>'<CR>

" Filetype specific keymaps maps - starts via <leade>f
let g:which_key_vim_map = {
      \ 'h'    : [':vert bo split $vimruntime\syntax\hitest.vim | so % | wincmd p | wincmd q' , 'open hitest'],
      \ 'g'    : [':call feedkeys(":call SynStack()\<cr>")' , 'show hi group'],
      \ 's'    : [':source $MYVIMRC'                       , 'source vimrc'],
      \}

function! SynStack()
  echom map(synstack(line('.'), col('.')), 'synIDattr(v:val, "name, fg, bg")')
endfunc
call which_key#register('vim', "g:which_key_vim_map")

let g:which_key_php_map = {
      \}

