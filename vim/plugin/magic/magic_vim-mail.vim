let g:VimMailStartFlags='boi'
augroup mail
    au!
    au filetype mail setlocal spell spelllang=fr textwidth=72 colorcolumn=74
    au filetype mail let g:attach_check_keywords=',PJ,ci-joint,pièce jointe,attached'
    au filetype mail let g:checkattach_once = 'y'
    au filetype mail let g:VimMailClient="/home/david/scripts/mutt.sh -t \"Mutt RO\" -R &"
augroup END
