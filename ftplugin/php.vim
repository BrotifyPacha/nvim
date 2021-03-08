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
    call search("function", "bW")
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
    execute "normal jV" . docstart . "G="
    normal o<++>
    normal F*ll
endfunction

function! RenameLocalVariable()
    let initpos = getpos(".")
    normal! "*yiw
    let renamefrom = @*
    call inputsave()
    let renameto = input("Rename local variable $" . renamefrom . " to: $")
    call inputrestore()
    call search("function", "bW")
    let funcstart = getpos(".")
    call search("{", "W")
    normal %
    let funcend = getpos(".")
    execute(funcstart[1].",".funcend[1]."s/\\<" . renamefrom . "\\>/" . renameto . "/g")
    call setpos(".", initpos)
    nohl
endfunction

function! ExtractMethod()
    "TODO сделать реализацию
endfunction
