" Autocorrect
set spell spelllang=fr
" Format
set textwidth=72 colorcolumn=74
" Use pandoc higlight
set syn=pandoc
" Start mutt in RO mode
map <LocalLeader>M :! /home/david/scripts/mutt.sh -t "Mutt RO" -R &<CR>
" Back to pandoc
map <localLeader>m :! pandoc --atx-headers -f html -t markdown -o % %
map <localLeader>h :call ToHtml()<CR>
" Convert to html on exit
"au VimLeave mutt-* :call ToHtml()<CR>

function! ToHtml()
    " Prepare html version
    :%s/\(^On .* wrote:$\)/\r\1\r/e
    :w
    :! pandoc -f markdown -t html -o % %
endfunction;

function! ToMultiPart()
    " Prepare html version
    :%s/\(^On .* wrote:$\)/\r\1\r/e
    :w
    :! pandoc -f markdown -t html -o %.html %
    " Restore original content
    :%s/\r\(^On .* wrote:$\)\r/\1/e
    " Get the bound
    let l:bound=system("head -n 1 ~/.mutt/content_type | sed 's/.*boundary=\\([a-z0-9]*\\).*/\\1/' ")
    " Test plain headers
    0put =l:bound
    normal gg
    normal I--
    normal oContent-Type: text/plain;charset=us-ascii
    normal o
    " Html headers
    normal G
    normal o
    put =l:bound
    normal I--
    normal G
    normal oContent-Type: text/html;charset=us-ascii
    normal o
    " hml version
    :read %.html
    "Final bound
    normal G
    normal o
    put =l:bound
    normal I--
    normal A--
    :! rm %.html
endfunction

