let g:goyo_linenr = 1

function! s:goyo_enter()
  Goyo 70%+20%x100%
  set statusline=%!Lightline()
  GitGutterEnable

endfunction

function! s:goyo_leave()
  " For later use
endfunction

autocmd! User GoyoEnter nested call <SID>goyo_enter()
autocmd! User GoyoLeave nested call <SID>goyo_leave()

