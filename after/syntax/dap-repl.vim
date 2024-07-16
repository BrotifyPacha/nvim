syn match infoKeyword '^\[\zsstdout\ze\]'
syn match errorKeyword '^\[\zsstderr\ze\]'

hi! def link infoKeyword   Folded
hi! def link errorKeyword  ErrorMsg
