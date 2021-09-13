au BufNewFile,BufRead *.class,*.java,*.jav setf java

au BufNewFile,BufRead *.csx setf cs

augroup pacha_netrw_autocomands
  autocmd!
  autocmd filetype netrw vertical resize 35
  autocmd BufEnter,BufWinEnter NetrwTreeListing vertical resize 35
augroup end

augroup pacha_girarlog_filetype
  autocmd!
  autocmd BufEnter,BufWinEnter * if &ft =='girarlog' 
              \| edit!
              \| setlocal readonly
              \| normal G
augroup end

augroup pacha_coc_no_statusline
  autocmd!
  autocmd BufEnter * if &l:ft == "coc-explorer" | setlocal statusline=~ | endif
augroup end

augroup pacha_help_filetype
  autocmd!
  autocmd BufRead,WinEnter * if &l:buftype ==# 'help' | vert resize 80 | endif
augroup end

augroup pacha_vim_filetype
  autocmd!
  autocmd BufWinEnter *.vim let b:surround_{char2nr('f')} = "\"{{{\r\"}}}"
augroup end

augroup pacha_quickfix
  autocmd!
  autocmd QuickFixCmdPost [^l]* cwindow
  autocmd QuickFixCmdPost l* lwindow
augroup end

