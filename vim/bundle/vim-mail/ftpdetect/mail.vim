" Detect mail files
augroup filetypedetect
    " Mail
    autocmd BufRead,BufNewFile *mutt-* setfiletype mail
    "mutt files
    autocmd BufRead,BufNewFile *.mutt setfiletype muttrc
augroup END
