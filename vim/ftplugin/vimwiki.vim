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


function! VimwikiLinkHandler(link) "{{{ Use Vim to open links with the
    " 'vlocal:' or 'vfile:' schemes.  E.g.:
    "   1) [[vfile:///~/Code/PythonProject/abc123.py]], and
    "   2) [[vlocal:./|Wiki Home]]
    let link = a:link
    if link =~ "vlocal:" || link =~ "vfile:"
      let link = link[1:]
    else
      return 0
    endif
    let [idx, scheme, path, subdir, lnk, ext, url] =
         \ vimwiki#base#resolve_scheme(link, 0)
    if g:vimwiki_debug
      echom 'LinkHandler: idx='.idx.', scheme=[v]'.scheme.', path='.path.
           \ ', subdir='.subdir.', lnk='.lnk.', ext='.ext.', url='.url
    endif
    if url == ''
      echom 'Vimwiki Error: Unable to resolve link!'
      return 0
    else
      call vimwiki#base#edit_file('tabnew', url, [], 0)
      return 1
    endif
endfunction
