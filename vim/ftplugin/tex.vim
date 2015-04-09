"====================== Latex-suite {{{2 ======================================

" IMPORTANT: grep will sometimes skip displaying the file name if you
" " search in a singe file. This will confuse Latex-Suite. Set your grep
" " program to always generate a file-name.
set grepprg=grep\ -nH\ $*

" " OPTIONAL: Starting with Vim 7, the filetype of empty .tex files defaults to
" " 'plaintex' instead of 'tex', which results in vim-latex not being loaded.
" " The following changes the default filetype back to 'tex':
let g:tex_flavor='latex'

" TIP: if you write your \label's as \label{fig:something}, then if you
" " type in \ref{fig: and press <C-n> you will automatically cycle through
" " all the figure labels. Very useful!
set iskeyword+=:

" Compilation
let g:Tex_DefaultTargetFormat='pdf'
let g:Tex_CompileRule_pdf="pdflatex -interaction=nonstopmode $*"
let g:Tex_UseMakefile=1

"Map \it to Localeader i
imap <buffer> <LocalLeader>it <Plug>Tex_InsertItemOnThisLine

" Environments
let g:Tex_Env_frame = "\\begin{frame}{<++>}\<CR><++>\<CR>\\end{frame}"
let g:Tex_Env_alertblock = "\\begin{alertblock}{<++>}\<CR><++>\<CR>\\end{alertblock}"
let g:Tex_Env_exampleblock = "\\begin{exampleblock}{<++>}\<CR><++>\<CR>\\end{exampleblock}"
let g:Tex_Env_block = "\\begin{block}{<++>}\<CR><++>\<CR>\\end{block}"
