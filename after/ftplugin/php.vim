echom "Loaded PHP config"
set tabstop=4 softtabstop=4 shiftwidth=4
set suffixesadd=.php
setlocal include=\\(\\(require\\\|include\\)\\(_once\\)\\?\\\|new\\\|use\\)\\s*\\zs\\(\\S*\\s\\{-}\\)\\ze\\(\\sas\\\|(\\)
setlocal define=\\s*\\(class\\\|function\\\|define\\)
set includeexpr=IncludeFunc(v:fname)


" $foo = new Provas_Model_User()
function! IncludeFunc(fname)
  let parts = split(a:fname, "\\")
  if len(parts) > 1
    let fp = "../".substitute(a:fname, "\\", "/", "g") . ".php"
    echom fp
  else
    let fp = "../". substitute(a:fname, "_", "/", "g") . ".php"
    echom fp
  endif
  return fp
endfunction

function! ConvertToMultilineArgs()
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

function! ConvertToOneLineArgs()
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

function! ToggleMultilineArgs()
  normal mm
  let argend = line(".") 
  normal %
  let argstart = line(".") 
  normal `m
  if (argstart == argend)
    silent! call ConvertToMultilineArgs()
  else
    call ConvertToOneLineArgs()
  endif
endfunction

function! AddDocString()
  let funcstart = GetFuncStart(0)
  let docstart = GetFuncStart(1)
  if funcstart != docstart
    echo "Already have a Docstring"
    execute "normal " . docstart . "G$F*ll"
    return
  endif
  execute "normal " . docstart . "G^"
  call search("(", "cW")
  normal v%"*y
  let str = @*
  let lst = []
  call substitute(str, "\\($[A-z0-9_]*\\)", '\=add(lst, submatch(0))', "g")
  execute("normal O/**\<esc>")
  let docstart = line(".")
  execute("normal o/\<esc>k")
  for m in lst
    execute "normal o@param " . m . " <++>"
  endfor
  normal o<++>
  execute "normal jV" . docstart . "G="
  normal F*ll
endfunction

function! RenameLocalVariable()
  normal! F$l"*yiw
  let renamefrom = @*

  " сохраняем начальное положение курсора
  let initpos = getpos(".") 

  " сохраняем положение экрана
  normal L 
  let screenlowpos = getpos(".")

  call setpos(".", initpos)

  " просим новое название переменной
  call inputsave()
  let renameto = input("Rename local variable $" . renamefrom . " to: $")
  call inputrestore()

  let funcstart = GetFuncStart(1)
  let funcend = GetFuncEnd()
  execute(funcstart.",".funcend."s/\\<" . renamefrom . "\\>/" . renameto . "/g")

  call setpos(".", screenlowpos)
  normal zb
  call setpos(".", initpos)
  call feedkeys("*N")
  echo funcstart[1] . " " . funcend[1]
endfunction

function! ExtractMethod()
  let func_start = GetFuncStart(1)
  execute "'<,'>move " . (func_start - 1)
  execute "normal! '<Ofunction func_name()\<cr>{"
  execute "normal! '>o}"
  execute "normal! o"
  execute "normal! V" .GetFuncStart(0) . "G^=="
  normal! wdw
  startinsert
endfunction

augroup LoadPhpTemplate
  autocmd!
  autocmd BufEnter *.php if line("$") == 1 && getline(1) == "" | call AddPhpBlock() | endif
augroup end 

function! AddPhpBlock()
  call feedkeys("i<?php?>\<esc>hi\<cr>\<esc>O")
endfunction

function! GetFuncStart(includeDoc)
  let funcstart = search("function", "cnbW")
  " если перед определением функции следуюет коммент если он следует то
  " заменяем название переменной ещё и в нём
  if a:includeDoc && (stridx(getline(funcstart-1), "*/") != -1)
    let funcstart = search("\/\\*", "nbW")
  endif
  return funcstart
endfunction

function! GetFuncEnd()
  let initpos = getpos(".")
  execute "normal " . GetFuncStart(0) . "G^"
  call search("{", "W")
  normal %
  let funcend = line(".")
  call setpos(".", initpos)
  return funcend
endfunction

" Php macros
let @a = "A;\<esc>"
let @t = "$this->"

" Abbreviations
iabbrev <buffer> func function

