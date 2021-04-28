" Vim syntax file

syn case match
syn sync minlines=50

syn include @gitDiff syntax/diff.vim

syn match  gitType      /\<\%(tag\|commit\|tree\|blob\)\>/     contained nextgroup=gitHash skipwhite
syn match  gitHashAbbrev /\<\x\{4,40\}\>/           contained nextgroup=gitHashAbbrev,gitPointers skipwhite
syn match  gitHashAbbrev /\<\x\{4,39\}\.\.\./he=e-3 contained nextgroup=gitHashAbbrev,gitPointers skipwhite

syn match  gitVersion /\v\d[0-9.]+\d+/                   contained containedin=gitPointer
syn match  gitPointerDelimiters /\v(\-\>|\:|\/|\(|\)|,)/ contained containedin=gitPointer
syn match  gitPointer /\v\S+(( \-\> |\/|: )\S+)?(, )?/   contained containedin=gitPointers contains=gitType,gitVersion,gitPointerDelimiters
syn region gitPointers start=/(/ end=/)/                 contained containedin=gitOnelineLog oneline contains=gitPointer keepend

syn match  gitGraphDot /\*/ contained containedin=gitGraph
syn match  gitGraphLine /\v(\||\\|\/)/ contained containedin=gitGraph
syn match  gitGraph /\v^(\*|\s|\||\\|\/)*\s/ contains=gitGraphDot,gitGraphLine

syn match  gitOnelineLog /^\(|\|\*\| \)*\<\x\{4,40\}\>.*$/ contains=gitGraph,gitHashAbbrev,gitPointers


hi def link gitGraphLine         diffAdded
hi def link gitGraphDot          diffChanged
hi def link gitGraph             Normal
hi def link gitPointerDelimiters Normal
hi def link gitPointers          Normal
hi def link gitVersion           Number
hi def link gitPointer           KeyWord

