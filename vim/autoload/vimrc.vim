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

" Remove trailing space {{{1
function! vimrc#RemoveTrailingSpace()
    "save position
    normal mz
    if &ft=='pandoc'
        " In pandoc files a double space at the end of a line has a meaning
        " and must not be removed
        " If a line ends with more than two space, replace it by two space
        execute ':%s/[ ]\{2,\}$/  /e'
        " Remove single white space at the end of a line
        execute ':%s/[^ ] $//e'
    elseif &ft=='mail'
        " In mails we have to allow "-- " as it is the begining of a signature
        " This one is a bit tricky: the first part until \@! says to match a
        " line witch doesn't start by -- . Than to make the negation work we
        " have to match the rest of the line, so we record any string of
        " caracter not ending by a space in \2 and removing any space between
        " this pattern and the end of the line
        execute ':%s/^\(-- \)\@!\(.*[^ ]\)\s\+$/\2/e'
    else
        " Just remove any character at the end of a line
        execute ':%s/\s\+$//ge'
    endif
    "restore cursor
    normal `z
    execute "silent :delmarks z"
endfunction


" Wordcount should be a fast implem for status bar {{{1
function! vimrc#WC()
    if &modified || !exists("b:wordcount")
        let l:old_status = v:statusmsg
        let position= getpos(".")
        execute "silent normal g\<c-g>"
        if v:statusmsg =~ '--No lines in buffer--'
            let b:wordcount=0
        else
            let b:wordcount = str2nr(split(v:statusmsg)[11])
        endif
        let v:statusmsg = l:old_status
        call setpos('.', position)
        return b:wordcount
    else
        return b:wordcount
    endif
endfunction
