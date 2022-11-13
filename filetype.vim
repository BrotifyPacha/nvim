au BufNewFile,BufRead *.class,*.java,*.jav setf java

au BufNewFile,BufRead *.csx setf cs

augroup pacha_vim_filetype
  autocmd!
  autocmd BufWinEnter *.vim let b:surround_{char2nr('f')} = "\"{{{\r\"}}}"
augroup end

augroup pacha_quickfix
  autocmd!
  autocmd QuickFixCmdPost [^l]* cwindow
  autocmd QuickFixCmdPost l* lwindow
augroup end

