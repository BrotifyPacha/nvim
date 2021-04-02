let s:percent_icon = ""
let s:trailing_icon = ""
let s:git_branch_icon = ""
let s:lines_icon = ""
let s:chars_icon = ""

set statusline=%!Lightline()
function Lightline()
  let actual_curbuf = winbufnr(g:statusline_winid)
  let isCurBuf = actual_curbuf == bufnr()
  let mode = GetMode()
  let secMode = Hl(GetModeHighlight(mode), "%6.10( ".GetModeTitle(mode)." %)")

  let secRuler = Hl(
        \"MoreMsg", 
        \" %(%2.5v | %2.5l/%1.150L".s:lines_icon." | %1.3p".s:percent_icon."%)")

  let filetail = "%t"
  let fileflags = "%-0.10(%m%r%w%q%)"

  let buf_fileenc = getbufvar(actual_curbuf, "&fileencoding")
  let buf_ff = getbufvar(actual_curbuf, "&ff")
  let encoding = Hl("MoreMsg", buf_fileenc."[".buf_ff."]")

  let secOptional = []
  " Detecting whether we are drawing statusline for the buffer that the cursor
  " is in or not
  if (actual_curbuf == bufnr())
    
    if (mode == "v")
      let visualSelected = VisualSelectionSize()
      call add(secOptional, Hl("CursorLineNr", visualSelected))
    endif


    " Drawing optional data only if g:lightline_optional is set
    if (get(g:, "lightline_optional", 1))

      if (exists('g:did_coc_loaded'))
        let coc_section = []
        if (exists('b:coc_diagnostic_info') && b:coc_diagnostic_info['error'] > 0)
          call add(coc_section, Hl("DiffRemoved", b:coc_diagnostic_info['error']."E"))
        endif
        if (exists('b:coc_diagnostic_info') && b:coc_diagnostic_info['warning'] > 0)
          call add(coc_section, Hl("DiffChange", b:coc_diagnostic_info['warning']."!"))
        endif
        if len(coc_section) > 0
          call add(secOptional, "%-3.8(".join(coc_section, ", ")."%)")
        endif
      endif

      " Detecting amount of lines that have trailing white spaces
      let trailingCount = s:CountTrailingSpaces()
      if (trailingCount > 0)
        let secTrailing = Hl("DiffChange", s:trailing_icon.trailingCount)
        call add(secOptional, secTrailing)
      endif

    endif
    if (get(g:, "lightline_fugitive", 1))
      let fugbranch = FugitiveHead()
      if (len(fugbranch) != 0)
        let secBranch = Hl("DiffAdd", s:git_branch_icon." ". fugbranch)
        call add(secOptional, secBranch)
      endif
    endif
  endif

  return join([
        \secMode, 
        \"%<", 
        \filetail, 
        \fileflags, 
        \encoding, 
        \"%=", 
        \join(secOptional, " "), 
        \secRuler])
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

function GetVisualType()
  let mdstr = mode()
  if (mdstr ==# "V")
    return "V"
  elseif (mdstr == "\<C-v>")
    return "cv"
  endif
  return "v"
endfunction

function GetModeTitle(mode)
  if (a:mode == "n")
    return "Normal"
  elseif (a:mode == "v")
    return "Visual"
  elseif (a:mode == "i")
    return "Insert"
  elseif (a:mode == "c")
    return "Command"
  elseif (a:mode == "r")
    return "Replace"
  elseif (a:mode == "t")
    return "Terminal"
  else
    return "Normal"
  endif
endfunction

function GetModeHighlight(mode)
  if (a:mode == "n")
    return "Cursor"
  elseif (a:mode == "v")
    return "Todo"
  elseif (a:mode == "i")
    return "TabLineSel"
  elseif (a:mode == "c")
    return "lCursor"
  elseif (a:mode == "r")
    return "TabLineSel"
  elseif (a:mode == "t")
    return "lCursor"
  endif
endfunction

function! s:CountTrailingSpaces()
  let arr = getline(0, "$")
  let arr = map(getline(0, "$"), {n, s -> s[-1:-1]==" "})
  let trailing = count(arr, 1)
  return trailing
endfunction

function! VisualSelectionSize()
  if mode() == "v"
    " Exit and re-enter visual mode, because the marks " ('< and '>) have not been updated yet.
    exe "normal \<ESC>gv"
    if line("'<") != line("'>")
      return (line("'>") - line("'<") + 1) . s:lines_icon.' '
    else
      return (col("'>") - col("'<") + 1) . s:chars_icon.' '
    endif
  elseif mode() == "V"
    exe "normal \<ESC>gv"
    return (line("'>") - line("'<") + 1) . s:lines_icon.' '
  elseif mode() == "\<C-V>"
    exe "normal \<ESC>gv"
    return (line("'>") - line("'<") + 1) .'x'. (abs(col("'>") - col("'<")) + 1) .' '
  else
    return ''
  endif
endfunction
