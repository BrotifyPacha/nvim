let g:go_def_mapping_enabled = 0
let g:go_doc_keywordprg_enabled = 0
let g:go_code_completion_icase = 0
let g:go_code_completion_enabled = 0
let g:go_textobj_enabled = 0

let g:pacha_go_format = 1

function ToggleGoFmtOnSave() abort
    let val = !get(g:, 'pacha_go_format')

    let g:pacha_go_format = val
    echo "Set go_fmt_autosave = " .. val

    let g:go_fmt_autosave = val
    let g:go_asmfmt_autosave = val
    let g:go_imports_autosave = val
endfunction

function CustomGoBuild() abort
    let dir = getcwd()
    execute "GoBuild " .. dir
endfunction
