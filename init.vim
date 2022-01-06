" Specify a directory for plugins
let g:config_location = stdpath('config')

lua require 'user.options'
lua require 'user.mappings'

execute "source " . g:config_location ."/"."abbreviation.vim"

function! MyFoldText()
  let n = v:foldend - v:foldstart + 1
  let line = getline(v:foldstart)
  let spc = substitute(line, '^\s*\zs.*', '', '')
  let txt = substitute(line, '^\s*', '', 'g')
  let txt = substitute(txt, '{', '', 'g')
  return  spc . v:folddashes . " " . txt . " - " . n . " "
endfunction

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

augroup highlight_yank
    autocmd!
    autocmd TextYankPost * lua require('vim.highlight').on_yank({higroup='PmenuSel', timeout=250})
augroup END

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
