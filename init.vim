"" Specify a directory for plugins
"plug.vim file should be placed under:
"~/.config/nvim/autoload/plug.vim - for unix
"~/AppData/Local/nvim/autoload/plug.vim for windows
call plug#begin(stdpath('config').'/plugged')
"call plug#begin(stdpath('data').'/plugged')

Plug 'tpope/vim-surround'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-fugitive'
Plug 'tommcdo/vim-exchange'
Plug 'wellle/targets.vim'
Plug 'reedes/vim-colors-pencil'
Plug 'psliwka/vim-smoothie'
Plug 'Raimondi/delimitMate'
Plug 'liuchengxu/vim-which-key'
Plug 'airblade/vim-gitgutter'
Plug 'vim-airline/vim-airline'

Plug 'neoclide/coc.nvim', {'branch': 'release'}
call plug#end()

set nocompatible


"{{{ General settings
filetype plugin on
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

" Проверка правильности написания слов"

set langmap=ФИСВУАПРШОЛДЬТЩЗЙКЫЕГМЦЧНЯЁЖ;
      \ABCDEFGHIJKLMNOPQRSTUVWXYZ~:,
      \фисвуапршолдьтщзйкыегмцчня;
      \abcdefghijklmnopqrstuvwxyz

set spelllang=en,ru

"}}}

colo pencil
set bg=dark "Or bg=light if you feeling moody

let mapleader=' '
let jumpvar='<++>'

"{{{ Sourcing settings for plugins
source $HOME\AppData\Local\nvim\plug-config\coc-settings.vim
source $HOME\AppData\Local\nvim\plug-config\welle-targets.vim
source $HOME\AppData\Local\nvim\plug-config\which-key.vim
source $HOME\AppData\Local\nvim\plug-config\gitgutter.vim
"}}}

" Abbreviations {{{1
cnoreabbrev h vertical botright help
cnoreabbrev vsf vert bel sf
cnoreabbrev vsp bel vsp
cnoreabbrev sp bel sp
" }}}1

" Mappings {{{

inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<Tab>"

tnoremap <Esc> <C-\><C-n>


