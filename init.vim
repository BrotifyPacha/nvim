" Specify a directory for plugins
let g:config_location = stdpath('config')

lua require 'user.autocmds'
lua require 'user.options'
lua require 'user.mappings'

execute "source " . g:config_location ."/"."abbreviation.vim"

function! MyFoldText()
  let n = v:foldend - v:foldstart + 1
  let startLine = getline(v:foldstart)
  if &expandtab == 0
    let unindented = substitute(startLine, '^\s\+', '', '')
    let indent = repeat(' ', indent(v:foldstart))
    let startLine = indent . unindented
  end
  let endLine = substitute(getline(v:foldend), '^[\s\t]*', '', '')
  return startLine . " .." . n . ".. " . endLine
endfunction
set foldtext=MyFoldText()

set winbar=%{%v:lua.require('user.helpers').getMyWinbar()%}
set tabline=%{%v:lua.require('tabline').myTabline()%}
set showtabline=2

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
execute "source " . g:config_location ."/"."plug-config/vim-go.vim"

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
