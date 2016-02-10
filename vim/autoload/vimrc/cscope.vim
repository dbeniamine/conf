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

"Create or update cscope and tags files on demand {{{1
function! vimrc#cscope#Init (mode)
    "do nothing if cscope.out doesn't exist and the user doesn't explicitly
    "asked to create it
    if(a:mode!="create" && !filereadable("cscope.out") )
        return
    endif
    "List c and cpp files
    silent !(find . -name '*.c' -o -name '*.h' -o -name '*.cpp' -o -name '*.hpp' -o -name '*.inl' > cscope.files)
    execute "silent ! ctags --c++-kinds=+p --fields=+iaS --extra=+q -L cscope.files -f tags_temp && mv tags_temp tags &"
    "cscope cmd to create (or update) cscope files
    let ccmd="\cscope -R -b -q"
    if(a:mode=="create")
        "create cscope file in verbose mode and foreground
        execute ":!"ccmd" -v"
        :cscope add .
    else
        let ccmd="rm cscope.*; ".ccmd
        execute "silent !".ccmd
        :cscope reset
    endif
endfunction

