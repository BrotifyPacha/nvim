let s:percent_icon = ""
let s:trailing_icon = ""
let s:git_branch_icon = ""
let s:lines_icon = ""
let s:chars_icon = ""

set statusline=%!Lightline()
function! Lightline()
  let mode = GetMode()
  let secModeHiglight = ""
  if v:version >= 800
    let actual_curbuf = winbufnr(g:statusline_winid)
    let isCurBuf = actual_curbuf == bufnr()
    if isCurBuf
      let secModeHiglight = GetModeHighlight(mode)
    else
      let secModeHiglight = "Search"
    endif
  else
    let secModeHiglight = GetModeHighlight(mode)
  endif

  let is_small = winwidth(g:statusline_winid) <= 60

  let secMode = Hl(
     \secModeHiglight,
     \"%3.10( ".GetModeTitle(mode, is_small)." %)"
     \)

  if is_small
    let secRuler = Hl(
          \"MoreMsg", 
          \" %(%2.5v | %1.5l/%1.150L".s:lines_icon."%) ")
  else
    let secRuler = Hl(
          \"MoreMsg", 
          \" %(%2.5v | %2.5l/%1.150L".s:lines_icon." | %1.3p".s:percent_icon."%)")
  endif

  let filetail = "%{GetFilePath()}"
  let fileflags = "%-0.10(%m%r%w%q%)"

  if v:version >= 800
    let buf_fileenc = getbufvar(actual_curbuf, "&fileencoding")
    let buf_ff = getbufvar(actual_curbuf, "&ff")
    let encoding = Hl("MoreMsg", buf_fileenc."[".buf_ff."]")
    let fileflags = fileflags." ".encoding
    " Drawing optional data only if g:lightline_optional is set
  endif

  let secOptional = []

  if get(g:, "lightline_show_visual", 1)
    call add(secOptional, Hl("CursorLineNr", "%{GetVisSection()}"))
  endif

  if get(g:, "lightline_show_trailing", 1) && !is_small
    call add(secOptional, Hl("DiffChange", "%{GetTrailingSpaceSection()}"))
  endif

  if exists('g:loaded_fugitive')
    call add(secOptional, Hl("DiffAdd", "%{GetGitSection()}"))
  endif

  if (is_small)
    return join([
        \secMode, 
        \"%<", 
        \filetail, 
        \"%=", 
        \join(secOptional, " "),
        \secRuler])
  else
    return join([
          \secMode, 
          \"%<", 
          \filetail, 
          \fileflags,
          \"%=", 
          \join(secOptional, " "),
          \secRuler])
  endif
endfunction

function! GetVisSection()
  if (GetMode() == "v")
    let visualSelected = VisualSelectionSize()
    return visualSelected
  endif
  return ""
endfunction

function! GetTrailingSpaceSection()
  let arr = getline(0, "$")
  let trailing = 0
  for line in arr
    if line[-1:-1] == " "
      let trailing = trailing + 1
    endif
  endfor
  if trailing > 0
    return s:trailing_icon . trailing . ""
  else
    return ""
  endif
endfunction

function! GetGitSection()
  let fugbranch = FugitiveHead()
  if (len(fugbranch) != 0)
    return s:git_branch_icon." ". fugbranch
  else
    return ""
  endif
endfunction

function! Hl(group, text)
  return "%#" . a:group . "#" . a:text . "%#Normal#"
endfunction

function GetFilePath()
  let path = expand("%")
  let lastTwoElements = substitute(
        \path,
        \'.*[/\\]\ze[^/\\]\+[/\\][^/\\]\+$',
        \'',
        \'i'
        \)
  return lastTwoElements
endfunction

" Returns:
" n - normal
" v - visual
" i - insert
" c - command
" r - replace
" t - terminal
function! GetMode()
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

function! GetVisualType()
  let mdstr = mode()
  if (mdstr ==# "V")
    return "V"
  elseif (mdstr == "\<C-v>")
    return "cv"
  endif
  return "v"
endfunction

function! GetModeTitle(mode, is_short)
  if (a:mode == "n")
    if a:is_short
      return "N"
    endif
    return "Normal"
  elseif (a:mode == "v")
    if a:is_short 
      return "V"
    endif
    return "Visual"
  elseif (a:mode == "i")
    if a:is_short
      return "I"
    endif
    return "Insert"
  elseif (a:mode == "c")
    if a:is_short 
      return "C"
    endif
    return "Command"
  elseif (a:mode == "r")
    if a:is_short 
      return "R"
    endif
    return "Replace"
  elseif (a:mode == "t")
    if a:is_short 
      return "T"
    endif
    return "Terminal"
  else
    if a:is_short 
      return "N"
    endif
    return "Normal"
  endif
endfunction

function! GetModeHighlight(mode)
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
