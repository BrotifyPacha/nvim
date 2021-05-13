function! NewTerminal()
  terminal
  call SetLocals()

  let term_bufids = get(g:, "term_bufids", [])
  call add(term_bufids, bufnr())
  let g:term_bufids = term_bufids

  " Get all existing bufids
  let existing_buffers = []
  bufdo call add(existing_buffers, bufnr())
  
  " Remove non-existing bufids
  for id in term_bufids
    if index(existing_buffers, id) == -1
      call remove(term_bufids, index(term_bufids, id))
      echo "removed " . id
    endif
  endfor
endfunction

function! ReopenTerminal()
  " let win_list = []
  " windo call add(win_list, winnr())
  if len(get(g:, "term_bufids", [])) > 0
    echom "Detected existing terms"
    let term_bufids = get(g:, "term_bufids", [])

    " Not on term window currently, so open one
    let indx = index(term_bufids, bufnr())
    let next_indx = (indx + 1) % len(term_bufids)
    echom "current buffer = " . bufnr()
    echom "command = :" . term_bufids[next_indx] . " buffer"
    execute term_bufids[next_indx] . " buffer"

  else
    echom "No existing terms Detected"
    call NewTerminal()
  endif
endfunction

function! RunCommand(command, args)
  call ExistingTerminal()
  execute "term ".a:command." ".a:args
  call SetLocals()
  bw! #
endfunction

function! SetLocals()
  setlocal nonu noma signcolumn=yes:1
endfunction
