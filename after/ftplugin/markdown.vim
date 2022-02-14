
let b:surround_{char2nr('c')} = "`\r`"
let b:surround_{char2nr('`')} = "`\r`"
let b:surround_{char2nr('b')} = "**\r**"
let b:surround_{char2nr('i')} = "*\r*"

function! MarkdownFoldExpr()
  let line = getline(v:lnum)
  let hashCnt = len(matchstr(line, '^#\+'))
  if hashCnt > 0
    return ">" . hashCnt
  endif
  return "="
endfunction

setlocal foldexpr=MarkdownFoldExpr()
setlocal foldmethod=expr
