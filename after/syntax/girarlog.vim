syn keyword errorKeyword ERROR
syn keyword warnKeyword WARN
syn keyword infoKeyword INFO

syn match celDate '[0-9]\{4}-[0-9]\{2}-[0-9]\{2}' nextgroup=celTime
syn match celTime '[0-9]\{2}\:[0-9]\{2}\:[0-9]\{2}'

syn region regString start='"' end='"' contained
syn region regString start="'" end="'" contained

hi! def link errorKeyword    Special
hi! def link warnKeyword     DiffChange
hi! def link infoKeyword     DiffAdd
hi! def link celDate         DiffText
hi! def link celTime         DiffText
hi! def link regString       Comment
hi! def link celKey          Statement
