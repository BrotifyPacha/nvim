" Specify a directory for plugins
"plug.vim file should be placed under:
"~/.config/nvim/autoload/plug.vim - for unix
"~/AppData/Local/nvim/autoload/plug.vim for windows
if (has("nvim"))
  let g:config_location = stdpath('config')
else
  let g:config_location = "~/.vim"
endif
call plug#begin(g:config_location . '/plugged')
"call plug#begin(stdpath('data').'/plugged')

Plug 'tpope/vim-surround'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-repeat'
Plug 'tommcdo/vim-exchange'
Plug 'wellle/targets.vim'
Plug 'brotifypacha/vim-colors-pencil'
Plug 'Raimondi/delimitMate'
Plug 'airblade/vim-gitgutter'
Plug 'chrisjohnson/vim-foldfunctions'
Plug 'lilydjwg/colorizer'
Plug 'qpkorr/vim-renamer'

Plug 'StanAngeloff/php.vim', { 'for': ['php', 'html', 'blade.php'] }

if (v:version >= 800)
  Plug 'liuchengxu/vim-which-key'
  Plug 'neoclide/coc.nvim', {'branch': 'release'}
endif

if (v:version >= 740 && has("python3"))
  Plug 'SirVer/ultisnips'
endif

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

set listchars=eol:$,tab:>-,trail:~,nbsp:+
" set list

set t_Co=256
set showmatch
set incsearch
set hlsearch
set laststatus=2
set path+=**
set hidden
set wildmenu
set noshowcmd
set smartcase
set ignorecase
set lazyredraw
set noswapfile
set regexpengine=1
set endofline
set diffopt+=vertical
set virtualedit=block

if (has("nvim"))
  set wildoptions+=pum " Enable pop up menu 
  set inccommand=nosplit
  set termguicolors

  set signcolumn=yes
else
  set numberwidth=6
endif

" Update time for gitgutter
set updatetime=100

let g:pencil_gutter_color = 1
set bg=dark "Or bg=light if you feeling moody
colo pencil

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
inoreabbrev pbulic public
inoreabbrev puclbi public
inoreabbrev swithc switch
inoreabbrev swtihc switch
inoreabbrev siwthc switch
inoreabbrev calss class
inoreabbrev clss class
inoreabbrev thsi this
inoreabbrev esle else
inoreabbrev eher here
inoreabbrev taht that
inoreabbrev thta that

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
  startinsert!
endfunction

" Useless bind to make which-key delay work
nnoremap <leader>+ <nop> 

" Shortening most used mappings
" If you need cw - use ce
nnoremap cw ciw
nnoremap vv ^v$h

nnoremap p p==
vnoremap p pgv=

vnoremap < <gv
vnoremap > >gv

nnoremap <c-l> :cnext<cr>zt
nnoremap <c-h> :cprev<cr>zt

" F key maps
" Remove search highlighting / remove match groups / update gutter
nnoremap <silent> <F5> :nohl \| match \| GitGutterAll<cr>
nnoremap <silent> <F6> :set list!<cr>
nnoremap <silent> <F7> :set wrap!<cr>
nnoremap <F8> :ColorToggle<cr>

inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<Tab>"

if (has("nvim"))
  tnoremap <Esc> <C-\><C-n>
endif

" }}}

" Commands
function! s:DiffWithSaved()
  let filetype=&ft
  diffthis
  bel vnew
  r #
  normal! 1GddzR
  execute "setlocal bt=nofile bh=wipe noma nobl noswf readonly ft=" . filetype
  diffthis
  wincmd p
  normal! zR
endfunction
com! DiffSaved call s:DiffWithSaved()

function! s:DiffOff()
  let curbuf = bufnr("%")
  echom curbuf
  windo if (&bt == "nofile") | bw! | endif
  execute "buffer ".curbuf
  diffoff
endfunction
com! DiffOff call s:DiffOff()

function! s:ToggleSpell()
  if (&spell == 0)
    set spell
    syntax off
  else
    set nospell
    syntax on
  endif
endfunction
com! ToggleSpell call s:ToggleSpell()

function! s:AutoCorrectWord()
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


"{{{ Sourcing settings for plugins
if (v:version >= 800)
  execute "source " . g:config_location . "/plug-config/coc-settings.vim"
endif
execute "source " . g:config_location . "/plug-config/which-key.vim"


execute "source " . g:config_location . "/plug-config/welle-targets.vim"
execute "source " . g:config_location . "/plug-config/gitgutter.vim"
execute "source " . g:config_location . "/plug-config/colorizer.vim"
execute "source " . g:config_location . "/plug-config/ulti.vim"
"}}}
