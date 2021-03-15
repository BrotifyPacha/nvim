let girar_log_regex = "\([0-9-]\+\)\s\+\([0-9:]\+\)\s\+\d\+\s\+\[\(INFO\|WARN\|ERROR\)\]"
let girar_log_regex = "\\([0-9-]\\+\\)\\s\\+\\([0-9:]\\+\\)\\s\\+\\d\\+\\s\\+\\[\\(INFO\\|WARN\\|ERROR\\)\\]"
autocmd BufEnter,BufWinEnter,BufRead,BufNewFile *.log 
            \if search(girar_log_regex, "cn") != -1
            \|setf girarlog | endif


