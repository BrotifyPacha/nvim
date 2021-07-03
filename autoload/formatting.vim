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

function! formatting#squash_blank_lines()
  normal! dipO
  normal! cc
  call repeat#set("\<Plug>fmt_sbl")
endfunction

" testing.function(testing(nice_variable));
function! formatting#delete_surrounding_func()
  normal ds)mm
  call search('\(\s\|(\|=\)', 'b')
  normal ld`m
  call repeat#set("\<Plug>fmt_dsf")
endfunction

" testing.function(testing(nice_variable, second_var));
function! formatting#change_surrounding_func(func_name)
  normal! F(

  if len(a:func_name) > 0
    let func_name = a:func_name
  else
    let func_name = input("Change function to: ")
  endif

  call search('\(\s\|(\|=\)', 'b')
  execute "norm lct(" . func_name
  call repeat#set(":call formatting#change_surrounding_func('".func_name."')\<cr>")
endfunction

nmap <Plug>fmt_sbl :call formatting#squash_blank_lines()<cr>
nmap <Plug>fmt_dsf :call formatting#delete_surrounding_func()<cr>
nmap <Plug>fmt_csf :call formatting#change_surrounding_func('')<cr>
