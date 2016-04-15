augroup commentaryvimrc
    au!
    au filetype pandoc let b:commentary_format="<!--%s-->"
    au filetype rmd let b:commentary_format="#%s"
augroup END

