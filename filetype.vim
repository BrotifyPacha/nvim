au BufNewFile,BufRead *.class,*.java,*.jav setf java

augroup netrw_autocomands
  autocmd!
  autocmd filetype netrw vertical resize 35
  autocmd BufEnter,BufWinEnter NetrwTreeListing vertical resize 35
augroup end

augroup girarlog_filetype
  autocmd!
  autocmd BufEnter,BufWinEnter * if &ft =='girarlog' 
              \| edit!
              \| setlocal readonly
              \| normal G
augroup end

augroup CocNoStatusline
  autocmd BufEnter,BufWinEnter * if &l:ft == "coc-explorer" | setlocal statusline=~ | endif
augroup end

augroup help_filetype
  autocmd!
  autocmd BufEnter * if &l:buftype ==# 'help' | vert resize 80 | endif
augroup end

augroup vim_filetype
  autocmd!
  autocmd BufWinEnter *.vim let b:surround_{char2nr('f')} = "\"{{{\r\"}}}"
augroup end

augroup quickfix
  autocmd!
  autocmd QuickFixCmdPost [^l]* cwindow
  autocmd QuickFixCmdPost l* lwindow
augroup end

