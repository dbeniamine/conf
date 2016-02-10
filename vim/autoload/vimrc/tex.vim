" Copyright (C) 2015  Beniamine, David <David@Beniamine.net>
" Author: Beniamine, David <David@Beniamine.net>
"
" This program is free software: you can redistribute it and/or modify
" it under the terms of the GNU General Public License as published by
" the Free Software Foundation, either version 3 of the License, or
" (at your option) any later version.
"
" This program is distributed in the hope that it will be useful,
" but WITHOUT ANY WARRANTY; without even the implied warranty of
" MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
" GNU General Public License for more details.
"
" You should have received a copy of the GNU General Public License
" along with this program.  If not, see <http://www.gnu.org/licenses/>.

" Custom starter for latex synctex {{{1
function! vimrc#tex#Starter(cmd,type)
    if &ft == "tex" && a:type !='m'
        " Retrieve main file from vim-compile command
        let l:file=substitute(a:cmd, '.* \([^ ]*\.pdf\).*','\1','')
        " Generate command
        execute ':! qpdfview --unique '.l:file.'\#src:'."%:p".':'.
                    \getpos(".")[1].':'.getpos(".")[2]." &"
    else
        " Not a latex start, let vim-compile handle it
        call vimcompile#DefaultStartCmd(a:cmd,a:type)
    endif
endfunction

" Find the right language for latex spell checking {{{1
function! vimrc#tex#SetLang()
    let file = readfile(expand("%:p"))
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


