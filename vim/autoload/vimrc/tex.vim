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
