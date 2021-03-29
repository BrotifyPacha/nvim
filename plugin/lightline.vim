set statusline=%!Lightline()
function Lightline()
  let actual_curbuf = winbufnr(g:statusline_winid)
  let isCurBuf = actual_curbuf == bufnr()
  let mode = GetMode()
  let secMode = Hl(GetModeHighlight(mode), "%6.10( ".GetModeTitle(mode)." %)")

  let secRuler = Hl("MoreMsg", " %(%2.5v | %2.5l/%1.150L | %2.3p %)")

  let filetail = "%t"
  let fileflags = "%-0.10(%m%r%w%q%)"

  let secOptional = []
  " Detecting whether we are drawing statusline for the buffer that the cursor
  " is in or not
  if (actual_curbuf == bufnr())
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
        call add(secOptional, "%-3.8(".join(coc_section, ", ")."%)")
      endif

      " Detecting amount of lines that have trailing white spaces
      let trailingCount = s:CountTrailingSpaces()
      if (trailingCount > 0)
        let secTrailing = Hl("DiffChange", "".trailingCount)
        call add(secOptional, secTrailing)
      endif

    endif
    if (get(g:, "lightline_fugitive", 1))
      let fugbranch = FugitiveHead()
      if (len(fugbranch) != 0)
        let secBranch = Hl("DiffAdd", " " . fugbranch)
        call add(secOptional, secBranch)
      endif
    endif
  endif

  let buf_fileenc = getbufvar(actual_curbuf, "&fileencoding")
  let buf_ff = getbufvar(actual_curbuf, "&ff")
  let encoding = Hl("MoreMsg", buf_fileenc."[".buf_ff."]")
  return join([secMode, filetail, fileflags, encoding, "%=", join(secOptional, " "), secRuler])
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
