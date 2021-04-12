function! OpenTerminal()
  let win_list = []
  windo call add(win_list, winnr())

  if get(g:, "terminal_winid", 0) && index(win_list, g:terminal_winid) != -1
    execute g:terminal_winid . "wincmd w"
    term
    bw! #
  else
    bo vnew | term
    let g:terminal_winid = winnr()
  endif
  call SetLocals()
endfunction

function! RunCommand(command, args)
  call OpenTerminal()
  execute "term ".a:command." ".a:args
  call SetLocals()
  bw! #
endfunction

function! SetLocals()
  setlocal nonu noma signcolumn=yes:1
endfunction
