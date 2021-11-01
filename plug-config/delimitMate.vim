
let g:delimitMate_expand_space = 1
let g:delimitMate_expand_cr = 1

au FileType html,twig,blade,jinja let b:delimitMate_matchpairs = "(:),[:],<:>"

inoremap <expr> <CR> delimitMate#WithinEmptyPair() ?
    \ "<C-r>=delimitMate#ExpandReturn()<cr>" :
    \ "<C-r>=UltiSnips#ExpandSnippetOrJump()<cr>"

