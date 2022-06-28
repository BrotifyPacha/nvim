" Specify a directory for plugins
let g:config_location = stdpath('config')

lua require 'user.autocmds'
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
set foldtext=MyFoldText()

set winbar=%{%v:lua.require('user.helpers').getMyWinbar()%}
set tabline=%!MyTabLine()
set showtabline=2
function MyTabLine()
  let s = ''
  for i in range(tabpagenr('$'))
    let i = i + 1
    " select the highlighting
    if i == tabpagenr()
        let tab_highlight = '%#TabLineSel#'
    else
        let tab_highlight = '%#TabLine#'
    endif
    let tab_name = '%'.i.'T %{MyTabLabel(' . i . ')} %' . i . 'X窱'

    let sep_highlight = '%#TabLineDivider#'
    let sep = '│'
    if i + 1 == tabpagenr()
        let sep_highlight = '%#TabLineDividerSelected#'
        let sep = '▐'
    elseif i == tabpagenr()
        let sep_highlight = '%#TabLineDividerSelected#'
        " let sep = '▌'
        let sep = '▌'
    elseif i == tabpagenr('$')
        let sep = ''
    end
    let s .= tab_highlight . tab_name . sep_highlight . sep
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

let g:fugitive_browse_handlers = ['CustomGBrowseHandler']
function! CustomGBrowseHandler(args)
    " Convert vim assoc array to lua table
    let table = substitute(string(a:args), "'\\(\\w\\+\\)':", "\\1 =", "g")
    return luaeval("require'fugitivehandlers'.CustomGBrowseHandler(" . table . ")")
endfunction

command! -nargs=1 Browse :call BrowseFunc(<q-args>)<cr>
function! BrowseFunc(opts)
    let opts = substitute(a:opts, '#', '\\#', 'g')
    silent execute '!xdg-open ' . trim(opts)
endfunction

set foldmethod=expr
set foldexpr=nvim_treesitter#foldexpr()

lua require 'user.helpers'
lua require 'user.plugins'
lua require 'user.plugins-config'
lua require 'lsp'

execute "source " . g:config_location ."/"."plug-config/welle-targets.vim"
execute "source " . g:config_location ."/"."plug-config/delimitMate.vim"
execute "source " . g:config_location ."/"."plug-config/telescope.vim"
execute "source " . g:config_location ."/"."plug-config/goyo.vim"

let g:easy_align_delimiters = {
    \ '/': {
    \     'pattern':
    \           '//\+\s\?'  . '\|'.
    \           '/\*\+'  . '\|'.
    \           ' \*/\?',
    \     'delimiter_align': 'l',
    \     'right_margin': -1,
    \   },
    \ ' ': {
    \     'pattern':      '\s',
    \     'left_margin':  0,
    \     'right_margin': 0
    \   }
    \ }
