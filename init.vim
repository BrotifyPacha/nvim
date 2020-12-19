"" Specify a directory for plugins
"plug.vim file should be placed under:
"~/.config/nvim/autoload/plug.vim - for unix
"~/AppData/Local/nvim/autoload/plug.vim for windows
call plug#begin(stdpath('config').'/plugged')
"call plug#begin(stdpath('data').'/plugged')
"
Plug 'tpope/vim-surround'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-fugitive'
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'tpope/vim-vinegar'
Plug 'reedes/vim-colors-pencil'
"Plug 'vim-airline/vim-airline'
Plug 'psliwka/vim-smoothie'

Plug 'neoclide/coc.nvim', {'branch': 'release'}
"
call plug#end()

set nocompatible

source $HOME\AppData\Local\nvim\plug-config\netrw.vim

filetype plugin on
set omnifunc=syntaxcomplete#Complete
set nu

set expandtab
set tabstop=2
set softtabstop=2
set shiftwidth=2
set listchars=eol:$,tab:<->,trail:~,nbsp:+

set t_Co=256
set termguicolors
set showmatch
set inccommand=nosplit
set incsearch
set hlsearch
set laststatus=2
set path+=**

set hidden

set wildmenu
set wildoptions+=pum " Enable pop up menu 

set smartcase


set langmap=ФИСВУАПРШОЛДЬТЩЗЙКЫЕГМЦЧНЯЁЖ;
      \ABCDEFGHIJKLMNOPQRSTUVWXYZ~:,
      \фисвуапршолдьтщзйкыегмцчня;
      \abcdefghijklmnopqrstuvwxyz

colo pencil
set bg=dark "Or bg=light if you feeling moody
syntax on

let mapleader=' '
let jumpvar='<++>'


"Abbreviations {{{1

cnoreabbrev h vertical botright help

cnoreabbrev sp bel sp
cnoreabbrev vsp bel vsp

" }}}1

"Mappings {{{1
inoremap ' ''<left>
inoremap ` ``<left>
inoremap " ""<left>
inoremap ( ()<left>
inoremap ) ()<left>
inoremap [ []<left>
inoremap ] []<left>
inoremap { {}<left>
inoremap } {}<left>


nnoremap <leader><leader> /<++><cr>c4l
tnoremap <Esc> <C-\><C-n>

nnoremap <C-w>s :bel sp<CR>
nnoremap <C-w>S :bel vsp<CR>

"GoTo code navigation.
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Use K to show documentation in preview window.
nnoremap <silent> K :call <SID>show_documentation()<CR>

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'vert bel h '.expand('<cword>')
  elseif (coc#rpc#ready())
    call CocActionAsync('doHover')
  else
    execute '!' . &keywordprg . " " . expand('<cword>')
  endif
endfunction

" }}}1

""//Auto Commands {{{1
"autocmd BufWritePost *.vim call SourceWhenWriting()
"if !exists('*SourceWhenWriting')
"    function! SourceWhenWriting()
"        source %
"    endfunction
"endif


augroup help_filetype
  autocmd!
  autocmd BufWinEnter * if &l:buftype ==# 'help' | vert resize 80 | endif
augroup end

augroup folding_group
  autocmd!
  autocmd BufWinEnter *.vim set foldmethod=marker
augroup end

"}}}1


set foldtext=Custnnnnldnext()
function CustomFoldText()
  let line = getline(v:foldstart)
  let sub = substitute(line, '"\|\/\|{{{\d\?', '', 'g') "}}}
  echom v:sub
  let tabs = repeat("    ",(v:foldlevel-1))
  return tabs.trim(sub, ' ').tabs
endfunction




omap af :call SelectAFunction()<cr>
omap if :call SelectInFunction()<cr>
vnoremap af :call SelectAFunction()<cr>
vnoremap if :call SelectInFunction()<cr>

nnoremap [m :call MoveOneFunction(1)<cr>
nnoremap ]m :call MoveOneFunction(0)<cr>
function! MoveOneFunction(direction) " True - up, false - down
  let ft=expand('%:t')
  if ft =~ '.py$'
    execute "normal! ".(a:direction ? "?":"/"). "^\\s*#*\\s*def\<cr>"
  elseif ft =~ '.vim$'
    execute "normal! ".(a:direction ? "?":"/"). "^function\<cr>"
  endif
  noh
  echo ' '
endfunction

function! SelectAFunction()
  let ft=expand('%:t')
  " file type = Python
  if ft =~ '.py$'
    let func_begin_signature = "^\\(\\s\\|\\#\\)*def"
    let func_end_signature = "^\\(\\s\\|\\#\\)*\\(def\\|class\\)"
    let has_def_before = search(func_begin_signature, "bWn")
    if getline('.') =~ func_begin_signature
    elseif has_def_before == 0
      execute "normal! /\s*def\<cr>"
    else
      let cmd = "normal " . has_def_before . "G\<cr>"
      echom cmd
      execute cmd
    endif

    let has_def_forward = search(func_end_signature, "nW")
    if has_def_forward == 0
      execute "normal! VG"
    else
      let cmd = "normal! V". has_def_forward . "Gk\<cr>"
      echom cmd
      execute cmd
    endif

    while getline('.') =~ "^\\s*$"
      execute "normal! k"
    endwhile
    " file type = Vim
  elseif ft =~ '.vim$'
    if getline('.') =~ '^function'
      execute "normal! V/endfunction$\<cr>"
    else
      execute "normal! ?^function\<cr>V/endfunction$\<cr>"
    endif
  endif
  noh
  echo ' '
endfunction

function! SelectInFunction()
  let ft=expand('%:t')
  if ft =~ '.py$'
    if getline('.') =~ "^\\s*#*\\s*def"
      execute "normal jV]mk"
    else
      execute "normal [mjV]mk"
    endif
    while getline('.') =~ "^\\s*$"
      execute "normal! k"
    endwhile
  elseif ft =~ '.vim$'
    if getline('.') =~ '^function'
      execute "normal! jV/endfunction$\<cr>k"
    else
      execute "normal! ?^function\<cr>jV/endfunction$\<cr>k"
    endif
  endif
  noh
  echo ' '
endfunction
