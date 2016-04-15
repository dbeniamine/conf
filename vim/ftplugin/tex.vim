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

" Find the right language for latex spell checking {{{1
function! SetTexLang()
    try | let file = readfile(expand("%:p")) | catch /.*/ | let file=[] | endtry
    " read current file
    for line in file
        let g:myLang = matchstr(line, '\\usepackage\[.*\]{babel}')
        if(!empty(g:myLang))
            "extract the (list of) language
            let g:myLang = substitute(g:myLang, '\\usepackage\[',"", "")
            let g:myLang = substitute(g:myLang, '\]{babel}',"", "")
            "if there are more than one language, the last one is the main language
            let ind=stridx(g:myLang, ",")+1
            let g:myLang=strpart(g:myLang, ind,strlen(g:myLang))
            "now we have just to set correctly the spellang
            "echo "language detected : "g:myLang
            let g:myLang = strpart(g:myLang,0,2)
            let &l:spelllang=g:myLang
            return
        endif
    endfor
endfunction
