" CocExplorer

let g:coc_global_extensions = [
            \ 'coc-explorer',
            \ '@yaegassy/coc-intelephense',
            \ 'coc-pyright',
            \ 'coc-tsserver',
            \ 'coc-lua',
            \ 'coc-html',
            \ 'coc-css',
            \ 'coc-markdownlint',
            \ 'coc-json',
            \ 'coc-prettier'
            \ ]


" enable sign column by default so it wont jump in and out
set signcolumn=yes

" GoTo code navigation.
nmap <silent> gd :call GoToDefinition()<cr>
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

function! GoToDefinition()
  if CocAction("jumpDefinition")
    return v:true
  endif
  let word = expand("<cword>")
  let splitword = split(word, "_")
  execute "dj ".splitword[-1]
endfunction

" Use K to show documentation in preview window.
nnoremap <silent> K :call <SID>show_documentation()<CR>
function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'vert bel h '.expand('<cword>')
  elseif (coc#rpc#ready())
    call CocActionAsync('doHover')
  else
    execute '!' . &keywordprg . " " . expand('<cword>')
  endif
endfunction
