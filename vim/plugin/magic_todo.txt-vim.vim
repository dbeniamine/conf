let g:Todo_txt_first_level_sort_mode="! i"

"Intelligent completion for projects and contexts
augroup todotxt
    au!
    au filetype todo imap <buffer> + +<C-X><C-O>
    au filetype todo imap <buffer> @ @<C-X><C-O>
    au filetype todo setlocal omnifunc=todo#Complete
augroup END

