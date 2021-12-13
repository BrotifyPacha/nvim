" Specify a directory for plugins
let g:config_location = stdpath('config')

call plug#begin(g:config_location . '/plugged')
"call plug#begin(stdpath('data').'/plugged')

"Disable default plugins
let g:loaded_matchit     = 1
let g:loaded_tarPlugin   = 1
let g:loaded_zipPlugin   = 1
let g:loaded_netrwPlugin = 1

" Utils
Plug 'nvim-lua/popup.nvim'
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'
Plug 'nvim-treesitter/nvim-treesitter'
Plug 'nvim-treesitter/nvim-treesitter-refactor'
Plug 'nvim-treesitter/nvim-treesitter-textobjects'
Plug 'nvim-treesitter/playground', { 'on': 'TSPlaygroundToggle' }
Plug 'SirVer/ultisnips'
Plug 'liuchengxu/vim-which-key'
Plug 'neoclide/coc.nvim'
Plug 'mfussenegger/nvim-dap'
Plug 'Pocco81/DAPInstall.nvim'
Plug 'rcarriga/nvim-dap-ui'
" General
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-unimpaired'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-repeat'
Plug 'wellle/targets.vim'
Plug 'Raimondi/delimitMate'
Plug 'tommcdo/vim-exchange', { 'on': ['<Plug>(Exchange)', '<Plug>(ExchangeLine)'] }
" Visual
Plug 'lewis6991/gitsigns.nvim'
Plug 'brotifypacha/vim-colors-pencil'
Plug 'norcalli/nvim-colorizer.lua'
Plug 'junegunn/vim-easy-align', { 'on': '<Plug>(EasyAlign)' }
Plug 'brotifypacha/goyo.vim', { 'on': 'Goyo'}
" Filetype specific
Plug 'baskerville/vim-sxhkdrc'
Plug 'StanAngeloff/php.vim', { 'for': ['php', 'html', 'blade.php'] }
Plug 'nelsyeung/twig.vim'
Plug 'jwalton512/vim-blade'
Plug 'iamcco/markdown-preview.nvim',
            \{ 'do': { -> mkdp#util#install() }, 'for': ['markdown', 'vim-plug'] }
" Tools
Plug 'qpkorr/vim-renamer', { 'on': 'Renamer' }
Plug 'vim-scripts/ingo-library'
Plug 'vim-scripts/AdvancedSorters'

call plug#end() "}}}

"{{{ General settings
set omnifunc=syntaxcomplete#Complete

set signcolumn=auto:1-2
set number
set colorcolumn=80
set nowrap

set linebreak
set expandtab
set tabstop=4
set softtabstop=4
set shiftwidth=4
set scrolloff=4

set t_Co=256
set listchars=eol:$,tab:>-,trail:~,nbsp:+
set showmatch

set mouse=a
set hidden
set path+=**
set smartcase
set ignorecase
set noswapfile
set regexpengine=1
set diffopt+=vertical
set virtualedit=block

set grepprg=grep\ -Rin\ $*\ --exclude-dir={.git,vendor,logs}\ /dev/null

set wildmenu
set wildoptions+=pum " Enable pop up menu 
set inccommand=nosplit
set termguicolors

" Update time for gitsigns
set updatetime=100

try
  let g:pencil_gutter_color = 1
  set bg=dark "Or bg=light if you feeling moody
  colo pencil
catch
endtry

let g:PHP_vintage_case_default_indent = 1
" }}}

"{{{ Foldings

set fillchars=fold:-

set foldlevel=99
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
  if cwd =~ 'trunk'
      let cwd = substitute(cwd, '[/\\]trunk.*', '', '')
      return matchstr(cwd, '[^/]\+/[^/]\+$')
  endif
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


""" Plugin mappings
" Easy align mappings
nmap ga <Plug>(EasyAlign)
xmap ga <Plug>(EasyAlign)
" Exchange mappings
nmap cx <Plug>(Exchange)
nmap cxx <Plug>(ExchangeLine)


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
vmap s <Plug>VSurround
nnoremap S s

" declating Document text object
onoremap id :lua require 'mytextobj'.documentTextObj()<cr>
xnoremap id :lua require 'mytextobj'.documentTextObj()<cr>
" declaring Expression text object
onoremap ie :lua require 'mytextobj'.expressionTextObj()<cr>
xnoremap ie :lua require 'mytextobj'.expressionTextObj()<cr>
" declaring Indent text object
onoremap ii :lua require 'mytextobj'.indentTextObj()<cr>
xnoremap ii :lua require 'mytextobj'.indentTextObj()<cr>

nnoremap cy "*y
nnoremap cp :set paste \| normal! "*p:set nopaste<cr>

nnoremap p p=`[
nnoremap P mmP=`[`m
vnoremap p pgv=

nnoremap [t :tabprevious<cr>
nnoremap ]t :tabnext<cr>

nnoremap [g :lua require'gitsigns'.prev_hunk()<cr>zz
nnoremap ]g :lua require'gitsigns'.next_hunk()<cr>zz

nnoremap gmp ddmm}P`m:call repeat#set("gmp") \| echo ""<cr>
nnoremap gmP ddkmm{p`m:call repeat#set("gmP") \| echo ""<cr>

nnoremap n nzz
nnoremap N Nzz

nnoremap gF :e <cfile><cr>

inoremap <C-f> <C-x><C-f>
inoremap <C-l> <C-x><C-l>

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

tnoremap <Esc> <C-\><C-n>

" }}}
augroup highlight_yank
    autocmd!
    autocmd TextYankPost * lua require('vim.highlight').on_yank({higroup='PmenuSel', timeout=250})
augroup END

"{{{ Sourcing settings for plugins
execute "source " . g:config_location ."/"."plug-config/coc-settings.vim"
execute "source " . g:config_location . "/"."plug-config/which-key.vim"
execute "source " . g:config_location ."/"."plug-config/welle-targets.vim"
execute "source " . g:config_location ."/"."plug-config/delimitMate.vim"
execute "source " . g:config_location ."/"."plug-config/telescope.vim"
execute "source " . g:config_location ."/"."plug-config/goyo.vim"
execute "source " . g:config_location ."/"."plug-config/ulti.vim"
execute "source " . g:config_location ."/"."plug-config/dap_config.lua"

if (has("nvim"))

  set foldmethod=expr
  set foldexpr=nvim_treesitter#foldexpr()

  lua require 'helpers'

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
      use_languagetree = true, -- Use this to enable language injection
    },
    indent = {
      enable = true,
      -- disable = { "php" }
    },
    refactor = {
        highlight_current_scope = {
            enable = true,
            disable = { "php" }
        },
        highlight_definitions = { enable = true },
        smart_rename = {
            enable = true,
            keymaps = {
                smart_rename = "<space>rr"
            }
        },
        navigation = {
            enable = true,
            keymaps = {
                list_definitions_toc = "gO"
            }
        }
    },
    textobjects = {
        select = {
            enable = true,
            -- Automatically jump forward to textobj, similar to targets.vim 
            lookahead = true,
            keymaps = {
                -- You can use the capture groups defined in textobjects.scm
                ["af"] = "@function.outer",
                ["if"] = "@function.inner",
                ["ac"] = "@class.outer",
                ["ic"] = "@class.inner",

                -- Or you can define your own textobjects like this
                ["ie"] = {
                   php = "@expression.inner",
                   lua = "@expression.inner"
                --     python = "(function_definition) @function",
                --     cpp = "(function_definition) @function",
                --     c = "(function_definition) @function",
                --     java = "(method_declaration) @function",
                },
            },
        },
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

