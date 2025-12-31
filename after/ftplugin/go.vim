setlocal formatprg=gofmt noexpandtab shiftwidth=4
setlocal formatoptions=roj

iabbrev <buffer> cosnt const

iabbrev <buffer> tyep type

iabbrev <buffer> sring string
iabbrev <buffer> strign string
iabbrev <buffer> strinv string
iabbrev <buffer> stirng string
iabbrev <buffer> flaot float

iabbrev <buffer> cahn chan
iabbrev <buffer> hcan chan

iabbrev <buffer> stuct struct
iabbrev <buffer> sturct struct
iabbrev <buffer> structg struct

iabbrev <buffer> interfce interface
iabbrev <buffer> intrefce interface
iabbrev <buffer> intreface interface
iabbrev <buffer> interfcae interface
iabbrev <buffer> intervce interface

iabbrev <buffer> ragne range

iabbrev <buffer> fucn func
iabbrev <buffer> function func

iabbrev <buffer> retrun return
iabbrev <buffer> reutnr return
iabbrev <buffer> returnc return

iabbrev <buffer> errrors errors
iabbrev <buffer> errros errors
iabbrev <buffer> errro error
iabbrev <buffer> erorr error

iabbrev <buffer> ;= :=
iabbrev <buffer> f;= :=

iabbrev <buffer> =! !=

nnoremap @e :lua AddErrorOrSecondReturnArgument()<cr>
