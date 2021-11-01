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
  normal! %
  let argstart = line(".")
  normal `m
  if (argstart == argend)
    silent! call s:convert_to_multiline_args()
  else
    silent! call s:convert_to_one_line_args()
  endif
  call repeat#set(":call formatting#toggle_multiline_args()\<cr>")
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

function! formatting#squash_blank_lines()
  normal! dipO
  normal! cc
  call repeat#set(":call formatting#squash_blank_lines()\<cr>")
endfunction

" testing.function(testing(nice_variable));
function! formatting#delete_surrounding_func()
  normal ds)mm
  call search('\(\s\|(\|=\|^\)', 'be')
  if getpos('.')[2] != 1
      normal ld`m
  else
      normal d`m
  endif
  call repeat#set(":call formatting#delete_surrounding_func()\<cr>")
endfunction

" testing.function(testing(nice_variable, second_var));
function! formatting#change_surrounding_func(func_name)
  normal! F(

  if len(a:func_name) > 0
    let func_name = a:func_name
  else
    let func_name = input("Change function to: ")
  endif

  call search('\(\s\|(\|=\|^\)', 'b')
  if getpos('.')[2] != 1
      execute "norm lct(" . func_name
  else
      execute "norm ct(" . func_name
  endif
  call repeat#set(":call formatting#change_surrounding_func('".func_name."')\<cr>")
endfunction

