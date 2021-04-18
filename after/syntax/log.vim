syn keyword errorKeyword ERROR Error error 
syn keyword warnKeyword WARN Warn warn 
syn keyword infoKeyword INFO Info info 

syn match celDate '[0-9]\{2,4}\(.\)[0-9]\{2}\1[0-9]\{2}'
syn match celTime '[0-9]\{2}\:[0-9]\{2}'

syn match pathDivider '\\' contained
syn match pathDivider '/' contained
syn match celPath '\([A-Z]:\)\?\(\(\\\|\/\)[0-9A-Za-z_\-.]\+\)\+' contains=pathDivider

syn match celNumDivider '\,'
syn match celNumDivider '\.'
syn match celNumber '[0-9.,]\+[f]\?' contains=celNumDivider

syn region regString start='"' end='"'
syn region regString start="'" end="'"


hi! def link errorKeyword  Error
hi! def link warnKeyword   DiffChange
hi! def link infoKeyword   DiffAdd
hi! def link celTime       Identifier
hi! def link celDate       Identifier
hi! def link regString     Comment

  
hi! def link celNumDivider Normal
hi! def link celNumber     Constant

hi! def link celPath       Directory
hi! def link pathDivider   Normal

