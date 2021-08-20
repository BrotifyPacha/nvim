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

"Disable default plugins
let g:loaded_matchit     = 1
let g:loaded_tarPlugin   = 1
let g:loaded_zipPlugin   = 1
let g:loaded_netrwPlugin = 1

Plug 'nvim-lua/popup.nvim'
Plug 'nvim-telescope/telescope.nvim'
Plug 'nvim-lua/plenary.nvim'
Plug 'lewis6991/gitsigns.nvim'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-unimpaired'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-repeat'
Plug 'wellle/targets.vim'
Plug 'brotifypacha/vim-colors-pencil'
Plug 'Raimondi/delimitMate', { 'on': [] }
Plug 'norcalli/nvim-colorizer.lua'
Plug 'qpkorr/vim-renamer', { 'on': 'Renamer' }
Plug 'brotifypacha/goyo.vim', { 'on': 'Goyo'}
Plug 'junegunn/vim-easy-align', { 'on': '<Plug>(EasyAlign)' }
Plug 'tommcdo/vim-exchange', { 'on': ['<Plug>(Exchange)', '<Plug>(ExchangeLine)'] }
nmap cx <Plug>(Exchange)
nmap cxx <Plug>(ExchangeLine)
Plug 'vim-scripts/ingo-library', { 'on': [] }
Plug 'vim-scripts/AdvancedSorters', { 'on': [] }
Plug 'iamcco/markdown-preview.nvim',
            \{ 'do': { -> mkdp#util#install() }, 'for': ['markdown', 'vim-plug'] }

Plug 'StanAngeloff/php.vim', { 'for': ['php', 'html', 'blade.php'] }

augroup load_on_insert
  autocmd!
  autocmd InsertEnter * call plug#load('delimitMate')
augroup END
augroup load_on_command
    autocmd!
    autocmd CmdlineEnter * call plug#load('ingo-library', 'AdvancedSorters')
augroup END

if (has("nvim"))
  Plug 'nvim-treesitter/nvim-treesitter'
  Plug 'nvim-treesitter/playground', { 'on': 'TSPlaygroundToggle' }
  Plug 'nvim-treesitter/nvim-treesitter-refactor'
endif

if (v:version >= 800)
  Plug 'liuchengxu/vim-which-key'
  Plug 'neoclide/coc.nvim', {'branch': 'release', 'for': ['vim', 'php', 'python', 'json', 'markdown']}
endif

if (v:version >= 704)
  if (has("python3"))
    Plug 'SirVer/ultisnips'
  endif
  if (v:version < 800)
    Plug 'vim-syntastic/syntastic', { 'for': ['php', 'html'] }
  endif 
endif

call plug#end() "}}}

"{{{ General settings
set nocompatible
syntax on
filetype plugin indent on
set omnifunc=syntaxcomplete#Complete
set nu

set nowrap
set linebreak
set expandtab
set tabstop=4
set softtabstop=4
set shiftwidth=4
set scrolloff=4 

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
set colorcolumn=80

set grepprg=grep\ -Rin\ $*\ --exclude-dir={.git,vendor,logs}\ /dev/null

if (has("nvim"))
  set wildoptions+=pum " Enable pop up menu 
  set inccommand=nosplit
  set termguicolors

  set signcolumn=yes
else
  set numberwidth=4
endif

" Update time for gitsigns
set updatetime=100

try
  let g:pencil_gutter_color = 1
  set bg=dark "Or bg=light if you feeling moody
  colo pencil
catch
endtry

" }}}

"{{{ Foldings

set fillchars=fold:-

set foldlevel=0
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
"

set tabline=%!MyTabLine()
function MyTabLine()
  let s = ''
  for i in range(tabpagenr('$'))
    " select the highlighting
    if i + 1 == tabpagenr()
        let s .= '%#TabLineSel#'
    else
        let s .= '%#TabLine#'
    endif

    " set the tab page number (for mouse clicks)
    let s .= '%' . (i + 1) . 'T'

    " the label is made by MyTabLabel()
    let s .= ' %{MyTabLabel(' . (i + 1) . ')} '
  endfor

  " after the last tab fill with TabLineFill and reset tab page nr
  let s .= '%#TabLineFill#%T'

  " right-align the label to close the current tab page
  if tabpagenr('$') > 1
    let s .= '%=%#TabLine#%999X X '
  endif

  return s
endfunction

function! MyTabLabel(n)
  let winnr = tabpagewinnr(a:n)
  let cwd = getcwd(winnr, a:n)
  let cwd = substitute(cwd, '.*[/\\]', '', '')
  return cwd
endfunction

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
cnoreabbrev vsf vert bel s
cnoreabbrev vsp bel vs

cnoreabbrev sp bel sp
cnoreabbrev bw! bn \| bw! #
cnoreabbrev cd tcd

execute "source " . g:config_location ."/"."abbreviation.vim"
" }}}

" Mappings {{{
let mapleader=' '
nnoremap <leader><leader> :call search('<++>', 'cw')<cr>c4l

" Useless bind to make which-key delay work
nnoremap <leader>+ <nop> 

" Easy align mappings
nmap ga <Plug>(EasyAlign)
xmap ga <Plug>(EasyAlign)

" Shortening most used mappings
" If you need cw - use ce
nnoremap cw ciw
nnoremap vv ^v$h
nnoremap Y yg_

nnoremap dsf :call formatting#delete_surrounding_func()<cr>
nnoremap csf :call formatting#change_surrounding_func('')<cr>

nnoremap Q @@

nnoremap q? <nop>
nnoremap q/ <nop>
nnoremap q: <nop>

nmap s <Plug>Ysurround
nmap ss <Plug>Yssurround
nnoremap S s

" declating Document text object
onoremap id :<C-u>normal! ggVG<cr>
xnoremap id :<C-u>normal! ggVG<cr>

nnoremap cy "*y
nnoremap cp :set paste \| normal! "*p:set nopaste<cr>

nnoremap p p=`[
nnoremap P mmP=`[`m
vnoremap p pgv=

nnoremap [t :tabprevious<cr>
nnoremap ]t :tabnext<cr>

nnoremap [g :lua require'gitsigns'.prev_hunk()<cr>
nnoremap ]g :lua require'gitsigns'.next_hunk()<cr>

nnoremap gF :e <cfile><cr>

nnoremap C :call ChangeTillSymbol()<cr>

function! ChangeTillSymbol()
  let line = getline('.')
  if line =~ '[,;:]$'
    let symbol = line[len(line)-1]
    call feedkeys('ct' . symbol)
  else
    call feedkeys('c$')
  endif
endfunction

" F key maps
" Remove search highlighting / remove match groups
nnoremap <silent> <F5> :nohl \| match<cr>
nnoremap <silent> <F6> :set list!<cr>
nnoremap <silent> <F7> :set wrap!<cr>
nnoremap <F8> :ColorizerToggle<cr>

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
  execute "source " . g:config_location ."/"."plug-config/coc-settings.vim"
endif
execute "source " . g:config_location . "/"."plug-config/which-key.vim"


execute "source " . g:config_location ."/"."plug-config/welle-targets.vim"
execute "source " . g:config_location ."/"."plug-config/telescope.vim"
execute "source " . g:config_location ."/"."plug-config/goyo.vim"
execute "source " . g:config_location ."/"."plug-config/ulti.vim"

if (has("nvim"))

  set foldmethod=expr
  set foldexpr=nvim_treesitter#foldexpr()

lua <<EOF
  require 'gitsigns'.setup()
  require 'colorizer'.setup {
    '*'; -- Highlight all files, but customize some others.
    css = { rgb_fn = true; }; -- Enable parsing rgb(...) functions in css.
    html = { names = false; }; -- Disable parsing "names" like Blue or Gray
    '!vim'
  }
  require 'nvim-treesitter.install'.compilers = { "gcc" }
  require 'nvim-treesitter.configs'.setup {
    query_linter = {
      enable = true,
      use_virtual_text = true,
      lint_events = {"BufWrite", "CursorHold"},
    },
    highlight = {
      enable = true,
      use_languagetree = false, -- Use this to enable language injection
    },
    indent = {
      enable = false
    },
    -- Use :TSPlaygroundToggle
    playground = {
      enable = true,
      disable = {},
      updatetime = 25, -- Debounced time for highlighting nodes in the playground from source code
      persist_queries = false, -- Whether the query persists across vim sessions
      keybindings = {
        toggle_query_editor = 'o',
        toggle_hl_groups = 'i',
        toggle_injected_languages = 't',
        toggle_anonymous_nodes = 'a',
        toggle_language_display = 'I',
        focus_language = 'f',
        unfocus_language = 'F',
        update = 'R',
        goto_node = '<cr>',
        show_help = '?',
      }
    }
  }
EOF
endif

