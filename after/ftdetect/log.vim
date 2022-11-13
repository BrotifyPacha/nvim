let log_regex = "\([0-9-]\+\)\s\+\([0-9:]\+\)\s\+\d\+\s\+\[\(INFO\|WARN\|ERROR\)\]"
let log_regex = "\\([0-9-]\\+\\)\\s\\+\\([0-9:]\\+\\)\\s\\+\\d\\+\\s\\+\\[\\(INFO\\|WARN\\|ERROR\\)\\]"
autocmd BufEnter,BufWinEnter,BufRead,BufNewFile *.log 
            \if search(log_regex, "cn") != 0
            \| setf log.girarlog 
            \| else
              \| setf log
            \| endif


