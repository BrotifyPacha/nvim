" Map leader to which_key
nnoremap <silent> <leader> :silent WhichKey '<Space>'<CR>
nnoremap <silent> <F2> :silent WhichKey '<F2>'<CR>
vnoremap <silent> <leader> :silent <c-u> :silent WhichKeyVisual '<Space>'<CR>

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
let g:which_key_hspace = 50

" Create map to add keys to
let g:which_key_map =  {}

let g:which_key_map['\'] = [ '<Plug>CommentaryLine'       , 'comment' ]
let g:which_key_map['e'] = [ ':CocCommand explorer'       , 'explorer' ]
let g:which_key_map['l'] = [ ':vert bel split'            , 'split right']
let g:which_key_map['h'] = [ ':bel split'            , 'split down']
let g:which_key_map['d'] = [ ':cd %:h'       , 'cwd to this' ]

let g:which_key_map.w = {
      \ 'name' : '+window' ,
      \ 'q' : [':q'        , 'quit'],
      \ 'w' : [':w'        , 'save'],
      \ 'r' : ['<C-w>r'    , 'rotate'],
      \ 'h' : ['<C-w>h'    , 'go left'],
      \ 'j' : ['<C-w>j'    , 'go down'],
      \ 'k' : ['<C-w>k'    , 'go up'],
      \ 'l' : ['<C-w>l'    , 'go right'],
      \ 'o' : ['<C-w>o'    , 'make the only'],
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
      \ 'f' : [':call feedkeys("\<esc>:find ") ' , 'find file'],
      \ 'g' : [':call OpenGrep(0)'               , 'grep files'],
      \ 'G' : [':call OpenGrep(1)'               , 'grep this File'],
      \ }

let g:which_key_map.g = {
      \ 'name' : '+git' ,
      \ 'j' : [':GitGutterNextHunk' , 'next hunk'],
      \ 'k' : [':GitGutterPrevHunk' , 'previous hunk'],
      \ 'u' : [':GitGutterUndoHunk' , 'undo hunk'],
      \ 's' : [':GitGutterStageHunk', 'stage hunk'],
      \ }


let g:which_key_map.b = {
      \ 'name' : '+buffer' ,
      \ '1' : ['b1'        , 'buffer 1']        ,
      \ '2' : ['b2'        , 'buffer 2']        ,
      \ 'd' : ['bd'        , 'delete-buffer']   ,
      \ 'f' : ['bfirst'    , 'first-buffer']    ,
      \ 'l' : ['blast'     , 'last-buffer']     ,
      \ 'n' : ['bnext'     , 'next-buffer']     ,
      \ 'p' : ['bprevious' , 'previous-buffer'] 
      \ }


let g:which_key_spell_map = {
      \ '<F2>' : [':set spell!', 'toggle spell'],
      \ 'g' : ['zg', 'spelled good'],
      \ 'b' : ['zw', 'spelled bad'],
      \ 'u' : [':spellundo', 'spell undo'],
      \ 'h' : ['[s', 'last misspelled'],
      \ 'l' : [']s', 'next misspelled'],
      \ }
call which_key#register('<F2>', "g:which_key_spell_map")


" Register which key map
call which_key#register('<Space>', "g:which_key_map")
