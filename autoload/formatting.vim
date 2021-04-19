function! s:convert_to_multiline_args()
  let initpos = getpos(".")
  call search("(", "cW")
  let lbrack = getpos(".")
  normal %
  if getcurpos[2] - lbrack[2] < 5 "
    call setpos(".", initpos)
    return
  endif
  call setpos(".", lbrack)
  execute "normal a\<cr>\<esc>"
  call setpos(".", lbrack)
  execute "normal %i\<cr>\<esc>"
  call setpos(".", lbrack)
  normal j^
  let linenum = line(".")
  execute "s/\\v,([^(]*\\))@!/,\\r/g"
  execute "normal V" . linenum . "G="
  call setpos(".", initpos)
endfunction

function! s:convert_to_one_line_args()
  let initpos = getpos(".")
  call search("(", "cW")
  let lbrack = getpos(".")
  execute "normal Jh%"
  let lines = line(".") - lbrack[1] + 1
  call setpos(".", lbrack)
  execute "normal " . lines . "J"
  call setpos(".", initpos)
  silent! execute "s/(\\s\\+/(/g"
  call setpos(".", initpos)
endfunction

function! formatting#toggle_multiline_args()
  normal mm
  let argend = line(".")
  normal %
  let argstart = line(".")
  normal `m
  if (argstart == argend)
    silent! call s:convert_to_multiline_args()
  else
    silent! call s:convert_to_one_line_args()
  endif
endfunction

function! formatting#go_snake_case(screaming)
  normal! mm
  normal! yiw
  let str = getreg('"')
  let str = substitute(str, "\\C[a-z]\\zs\\([A-Z]\\)", "_\\1", "g")
  execute "normal! ciw\<c-r>=str\<cr>\<esc>guiw"
  if a:screaming
    normal gUiw
  endif
  normal! `m
endfunction

function! formatting#go_camel_case(start_upper)
  normal! mm
  normal! yiw
  let str = tolower(getreg('"'))
  let str = substitute(str, "\\([^a-z][a-z]\\)", "\\U\\1", "g")
  let str = substitute(str, "_", "", "g")
  if a:start_upper
    let str = substitute(str, "^\\([a-z]\\)", '\U\1', '')
  endif
  execute "normal! ciw\<c-r>=str\<cr>\<esc>"
  normal! `m
endfunction
