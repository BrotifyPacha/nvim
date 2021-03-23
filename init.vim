" Specify a directory for plugins
"plug.vim file should be placed under:
"~/.config/nvim/autoload/plug.vim - for unix
"~/AppData/Local/nvim/autoload/plug.vim for windows
call plug#begin(stdpath('config').'/plugged')
"call plug#begin(stdpath('data').'/plugged')

Plug 'tpope/vim-surround'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-repeat'
Plug 'tommcdo/vim-exchange'
Plug 'wellle/targets.vim'
Plug 'brotifypacha/vim-colors-pencil'
Plug 'psliwka/vim-smoothie'
Plug 'Raimondi/delimitMate'
Plug 'liuchengxu/vim-which-key'
Plug 'airblade/vim-gitgutter'
Plug 'chrisjohnson/vim-foldfunctions'
" Plug 'tmhedberg/SimpylFold'
" Plug 'vim-airline/vim-airline'

Plug 'neoclide/coc.nvim', {'branch': 'release'}
call plug#end() "}}}

"{{{ General settings
set nocompatible
filetype plugin indent on
syntax on
set omnifunc=syntaxcomplete#Complete
set nu

set nowrap
set expandtab
set tabstop=2
set softtabstop=2
set shiftwidth=2
set scrolloff=2 

set listchars=eol:$,tab:<->,trail:~,nbsp:+
" set list

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
set ignorecase
set lazyredraw
set noswapfile
set regexpengine=1

colo pencil
set bg=dark "Or bg=light if you feeling moody

" }}}

"{{{ Foldings

set fillchars=fold:-

set foldlevel=1
set foldminlines=3
set foldtext=MyFoldText()
set foldopen=block,hor,insert,jump,mark,percent,quickfix,search,tag,undo
function! MyFoldText()
  let n = v:foldend - v:foldstart + 1
  let line = getline(v:foldstart)
  let spc = substitute(line, '^\s*\zs.*', '', '')
  let txt = substitute(line, '^\s*', '', 'g')
  let txt = substitute(txt, '{', '', 'g')
  return  spc . v:folddashes . " " . txt . " - " . n . " "
endfunction
"}}}

"{{{ Lang and Spell stuff

set langmap=ФИСВУАПРШОЛДЬТЩЗЙКЫЕГМЦЧНЯХЪЖБЮЁ;
           \ABCDEFGHIJKLMNOPQRSTUVWXYZ{}:<>~,
           \фисвуапршолдьтщзйкыегмцчняхъэюё;
           \abcdefghijklmnopqrstuvwxyz[]'.`

set langmap+=Э;\\"
set langmap+=ж;\\;
set langmap+=б;\\,
set langmap+=№;#
set spelllang=en,ru
"}}}

" Abbreviations {{{
cnoreabbrev h vertical botright help
cnoreabbrev vsf vert bel sf
cnoreabbrev vsp bel vsp
cnoreabbrev sp bel sp

inoreabbrev fynction function
inoreabbrev fycntion function
inoreabbrev fucntion function
inoreabbrev fucniton function
inoreabbrev funciton function 
inoreabbrev pubcli public
inoreabbrev publci public
inoreabbrev pbulci public
inoreabbrev puclbi public
inoreabbrev swithc switch
inoreabbrev swtihc switch
inoreabbrev siwthc switch
inoreabbrev calss class
inoreabbrev clss class
inoreabbrev thsi this
inoreabbrev esle else
inoreabbrev eher here

inoreabbrev осуществояется осуществляется 
inoreabbrev осуществялется осуществляется 
inoreabbrev подклбючатеся подключается
inoreabbrev подколючается подключается
inoreabbrev подклбючается подключается
inoreabbrev подклбючается подключается
inoreabbrev пдклбючается подключается
inoreabbrev возварщаяет возвращает
inoreabbrev получате получает
inoreabbrev проихсодит происходит
inoreabbrev берется берётся
inoreabbrev исхояд исходя
inoreabbrev ихсодя исходя
inoreabbrev ихсояд исходя
inoreabbrev сулчае случае
inoreabbrev присутсвтует присутствует
inoreabbrev присутствиует присутствует
inoreabbrev присутстсвует присутствует
inoreabbrev приуствствует присутствует
inoreabbrev приутствует присутствует
inoreabbrev прсутствует присутствует
inoreabbrev отсутсвтует отсутствует
inoreabbrev отсутствиует отсутствует
inoreabbrev отсутстсвует отсутствует
inoreabbrev отуствствует отсутствует
inoreabbrev отутствует отсутствует

" }}}

" Mappings {{{
let mapleader=' '
let g:macro_placeholder='<++>'
function! SearchForMacroPlaceholder()
  call search(g:macro_placeholder, "cw")
  execute "normal! c" . strlen(g:macro_placeholder) . "l"
  normal l
  startinsert
endfunction

" Useless bind to make which-key delay work
nnoremap <leader>+ <nop> 

nnoremap vv ^v$h

" F key maps
nnoremap <F6> :set list!<cr>
nnoremap <F5> :nohl<cr>

inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<Tab>"

tnoremap <Esc> <C-\><C-n>

" }}}

" Commands
function! s:DiffWithSaved()
  let filetype=&ft
  diffthis
  bel vnew
  r #
  normal! 1GddzR
  execute "setlocal bt=nofile bh=wipe nobl noswf ro ft=" . filetype
  diffthis
  wincmd p
  normal! zR
endfunction
com! DiffSaved call s:DiffWithSaved()

function s:DiffOff()
  let curbuf = bufnr("%")
  echom curbuf
  windo if (&bt == "nofile") | bw! | endif
  execute "buffer ".curbuf
  diffoff
endfunction
com! DiffOff call s:DiffOff()

function s:ToggleSpell()
  if (&spell == 0)
    set spell
    syntax off
  else
    set nospell
    syntax on
    " Re-source gitgutter config to load linked highlight groups
    source $HOME\AppData\Local\nvim\plug-config\gitgutter.vim
  endif
endfunction
com! ToggleSpell call s:ToggleSpell()

function s:AutoCorrectWord()
  let curspell = &spell
  set spell
  normal 1z=
  if curspell
    set spell
  else
    set nospell
  endif
endfunction
com! AutoCorrectWord call s:AutoCorrectWord()

"{{{ Custom status line
set statusline=%!MyStatusLine()
function MyStatusLine()
  let mdstr = mode()
  if (mdstr[0] == "n")
    let mdstr = "Normal"
    let higr = "Cursor"
  elseif (mdstr[0] == "v")
    let mdstr = "Visual"
    let higr = "Todo"
  elseif (mdstr[0] == "i")
    let mdstr = "Insert"
    let higr = "TabLineSel"
  elseif (mdstr[0] == "c")
    let mdstr = "Command"
    let higr = "lCursor"
  endif
  let md = "%#".higr."#%6.9( ".mdstr." %#Normal#%)"
  let column  = "%3.5c"
  let line  = "%3.5l"
  let ruler = "%( |".column." | ".line." |%3.3p%%  %)"
  let filetail = "%t"
  let fileflags = " %-8.20(%m%r%w%q%)"
  let fileinfo = filetail . fileflags
  return md . " " . fileinfo . "%=" . "%y" . ruler
endfunction
"}}}
"{{{ Sourcing settings for plugins
source $HOME\AppData\Local\nvim\plug-config\coc-settings.vim
source $HOME\AppData\Local\nvim\plug-config\welle-targets.vim
source $HOME\AppData\Local\nvim\plug-config\which-key.vim
source $HOME\AppData\Local\nvim\plug-config\gitgutter.vim
"}}}
