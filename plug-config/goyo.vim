let g:goyo_linenr = 1
let g:goyo_colorcolumn = 1

function! s:goyo_enter()
  if g:goyo_preset == 1
    " Coding style preset
    Goyo 70%+25%x100%
    set statusline=%!Lightline()
    echom "Coding preset"
  elseif g:goyo_preset == 2
    " Writing preset
    Goyo 85+3x100%
    set statusline=%!Lightline()
    set wrap
    echom "Writing preset"
  elseif g:goyo_preset == 3
    " Note taking preset
    set nonu
    echom "Note-taking preset"
    
  else
  endif
endfunction

function! s:goyo_leave()
  " For later use
endfunction

autocmd! User GoyoEnter nested call <SID>goyo_enter()
autocmd! User GoyoLeave nested call <SID>goyo_leave()

