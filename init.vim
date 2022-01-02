" Specify a directory for plugins
let g:config_location = stdpath('config')


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
set showtabline=2
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
    " the label is made by MyTabLabel() and %(i+1)X 
    let s .= ' %{MyTabLabel(' . (i + 1) . ')} %' . (i + 1) . 'X窱'
    " if next is not selected and not current and not last add divider
    if i + 2 != tabpagenr() && i + 1 != tabpagenr() && i + 1 != tabpagenr('$')
        let s .= '%#TabLineDivider#│'
    endif
  endfor
  " after the last tab fill with TabLineFill and reset tab page nr
  let s .= '%#TabLineFill#%T'
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

set foldmethod=expr
set foldexpr=nvim_treesitter#foldexpr()

lua require 'user.helpers'
lua require 'user.plugins'
lua require 'user.plugins-config'

execute "source " . g:config_location ."/"."plug-config/coc-settings.vim"
execute "source " . g:config_location ."/"."plug-config/which-key.vim"
execute "source " . g:config_location ."/"."plug-config/welle-targets.vim"
execute "source " . g:config_location ."/"."plug-config/delimitMate.vim"
execute "source " . g:config_location ."/"."plug-config/telescope.vim"
execute "source " . g:config_location ."/"."plug-config/goyo.vim"
execute "source " . g:config_location ."/"."plug-config/ulti.vim"
