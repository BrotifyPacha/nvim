setlocal tabstop=4 softtabstop=4 shiftwidth=4
setlocal suffixesadd=.php
setlocal include=\\(\\(require\\\|include\\)\\(_once\\)\\?\\\|new\\\|use\\)\\s*\\zs\\(\\S*\\s\\{-}\\)\\ze\\(\\sas\\\|(\\)
setlocal define=\\s*\\(class\\\|function\\\|define\\)
setlocal includeexpr=IncludeFunc(v:fname)

setlocal commentstring=//%s

setlocal iskeyword+=$

function! IncludeFunc(fname)
  let parts = split(a:fname, "\\")
  if len(parts) > 1
    let fp = "../".substitute(a:fname, "\\", "/", "g") . ".php"
    " echom fp
  else
    let fp = "../". substitute(a:fname, "_", "/", "g") . ".php"
    " echom fp
  endif
  return fp
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
  normal! "*yiw
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

  "Подсвечиваем измененные элементы
  highlight! link HiRenameLocalVariable NONE
  highlight! link HiRenameLocalVariable Cursor
  execute 'match'
  execute 'match HiRenameLocalVariable "\<'.renameto.'\>"'
  echom funcstart[1] . " " . funcend[1]
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

" vnoremap <buffer>gc :<C-u>execute "normal! '<O/*"<cr>:<C-u>execute "normal! '>o*/"<cr>
" Php macros
let @a = "mmA;\<esc>`m"
let @t = "$this->"
let @e = "echo "

" Abbreviations
iabbrev <buffer> func function
inoreabbrev <buffer> eol PHP_EOL


" Creates php block with empty line as last
" <?php
"
"
function! AddPhpBlock()
  normal! i<?php
  normal! 2o
  normal! k
endfunction

if (line("$") == 1 && getline(1) == "")
  call AddPhpBlock() 
endif
