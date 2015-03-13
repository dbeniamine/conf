" Autocorrect
set spell spelllang=fr
" Format
set textwidth=72 colorcolumn=74
" Start mutt in RO mode
map <LocalLeader>M :! /home/david/scripts/mutt.sh -t "Mutt RO" -R &<CR>
" Back to pandoc
map <localLeader>m :! pandoc --atx-headers -f html -t markdown -o % %
map <localLeader>h :call ToHtml()<CR>
imap <localLeader>a <C-X><C-U>
au BufWinEnter *mutt-* call GotoStart()
" Completion based on pc_query
set completefunc=CompleteAddr

" Complete function using pc_query
" If we are on a header field provides only mail information
" Else provides each fields contains in the matched vcards
function! CompleteAddr(findstart, base)
    if(a:findstart)
        let line=getline('.')
        " Are we in a header field ?
        if line=~ '^\(From\|To\|Cc\|Bcc\|Reply-To\):'
            let g:VimMailCompleteOnlyMail=1
        else
            let g:VimMailCompleteOnlyMail=0
        endif
        " Find the start
        let start=col('.')-1
        while start > 0 && line[start - 1] =~ '\a'
            let start -= 1
        endwhile
        return start
    else
        " Set the grep function
        if (g:VimMailCompleteOnlyMail)
            let l:grep="egrep \"(Name|MAIL)\""
        else
            let l:grep="grep :"
        endif
        let l:records=[]
        " Do the query
        let l:query=system("pc_query ".a:base."|".l:grep)
        for line in split(l:query, '\n')
            "Recover the name
            if line=~ "Name"
                let l:name=substitute(split(line, ':')[1],"^[ ]*","","")
            else
                " pc_query answer look like this
                " EMAIL (WORK): foo@bar.com
                let ans=split(line,':')
                " Remove useless whitespace
                let ans[1]=substitute(ans[1], "^[ ]*","","")
                let l:item={}
                " Full information for preview window name + pc_query line
                let l:item.info=l:name.":\n ".line
                if ans[0]=~"^EMAIL"
                    " Put email addresses in '<' '>'
                    let l:item.word=l:name." <".ans[1].">"
                    let l:item.abbr=ans[1]
                    let l:item.kind="M"
                else
                    let l:item.word=ans[1]
                    "Use the first letter of the pc_query type for the kind
                    let l:item.kind=strpart(ans[0],0,1)
                endif
                " If there are a precise info (aka '(WORK)') add it
                if ans[0]=~"(.*)"
                    let l:item.menu=substitute(ans[0],'\(.*(\|).*\)',"","g")
                endif
                call add(records, item)
            endif
        endfor
        return records
    endif
endfunction

function! GotoStart()
    /^$
endfunction;

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

