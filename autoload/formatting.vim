function! formatting#squash_blank_lines()
  normal! dipO
  normal! cc
  call repeat#set(":call formatting#squash_blank_lines()\<cr>")
endfunction

" testing.function(testing(nice_variable));
function! formatting#delete_surrounding_func()
  normal ds)mm
  call search('\(\s\|(\|=\|^\)', 'be')
  if getpos('.')[2] != 1
      normal ld`m
  else
      normal d`m
  endif
  call repeat#set(":call formatting#delete_surrounding_func()\<cr>")
endfunction

" testing.function(testing(nice_variable, second_var));
function! formatting#change_surrounding_func(func_name)
  normal! F(

  if len(a:func_name) > 0
    let func_name = a:func_name
  else
    let func_name = input("Change function to: ")
  endif

  call search('\(\s\|(\|=\|^\)', 'b')
  if getpos('.')[2] != 1
      execute "norm lct(" . func_name
  else
      execute "norm ct(" . func_name
  endif
  call repeat#set(":call formatting#change_surrounding_func('".func_name."')\<cr>")
endfunction

