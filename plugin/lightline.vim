set statusline=%!Lightline()
function Lightline()
  let mode = GetMode()
  if (mode == "n")
    let mdstr = "Normal"
    let higr = "Cursor"
  elseif (mode == "v")
    let mdstr = "Visual"
    let higr = "Todo"
  elseif (mode == "i")
    let mdstr = "Insert"
    let higr = "TabLineSel"
  elseif (mode == "c")
    let mdstr = "Command"
    let higr = "lCursor"
  elseif (mode == "r")
    let mdstr = "Replace"
    let higr = "TabLineSel"
  elseif (mode == "t")
    let mdstr = "Terminal"
    let higr = "lCursor"
  endif
  let md = Hl(higr, "%6.10( ".mdstr." %)")
  let column  = "%2.5c"
  let line  = "%2.5l"
  let ruler = "%( ".column." | ".line." |%3.3p%%  %)"
  let filetail = "%t"
  let fileflags = " %-0.10(%m%r%w%q%)"  
  let fileinfo = filetail . fileflags

  let statusline = md ." ". fileinfo ."%="

  let fugbranch = FugitiveHead()
  if (len(fugbranch) != 0)
    let statusline = statusline . Hl("DiffAdd", " " . fugbranch)
  endif
  let statusline = statusline ." ". ruler
  return statusline
endfunction

function Hl(group, text)
  return "%#" . a:group . "#" . a:text . "%#Normal#"
endfunction

" Returns:
" n - normal
" v - visual
" i - insert
" c - command
" r - replace
" t - terminal
function GetMode()
  let mdstr = mode()
  if (mdstr[0] == "n")
    return "n"
  elseif (mdstr == "v" || 
        \mdstr == "V" ||
        \mdstr == "\<C-v>" ||
        \mdstr == "s" ||
        \mdstr == "S" ||
        \mdstr == "\<C-s>")
    return "v"
  elseif (mdstr[0] == "i")
    return "i"
  elseif (mdstr[0] == "c")
    return "c"
  elseif (mdstr[0] == "r")
    return "r"
  elseif (mdstr[0] == "t")
    return "t"
  endif
endfunction
