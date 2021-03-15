au BufNewFile,BufRead *.class,*.java,*.jav setf java

augroup netrw_autocomands
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

augroup help_filetype
  autocmd BufEnter * if &l:buftype ==# 'help' | vert resize 80 | endif
augroup end

augroup vim_filetype
  autocmd BufWinEnter *.vim let b:surround_{char2nr('f')} = "\"{{{\r\"}}}"
augroup end

augroup quickfix
    autocmd QuickFixCmdPost [^l]* cwindow
    autocmd QuickFixCmdPost l* lwindow
augroup end

