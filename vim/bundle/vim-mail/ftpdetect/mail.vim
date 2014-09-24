" Detect mail files
augroup filetypedetect
    " Mail
    autocmd BufEnter *mutt-* setfiletype mail
    "mutt files
    autocmd BufEnter *.mutt setfiletype muttrc
augroup END
