" Specify a directory for plugins
let g:config_location = stdpath('config')

"{{{ General settings
lua require 'user.options'

" }}}

execute "source " . g:config_location ."/"."abbreviation.vim"

"{{{ Foldings

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

" Mappings {{{
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
