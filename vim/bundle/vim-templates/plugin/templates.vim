"========================= Templates plugin ===================================
"
"   Insert templates and Makefiles by extension when creating a new file
"
"==============================================================================

if (!exists("g:templ_templates_install_dir"))
    let g:templ_templates_install_dir="~/.vim"
endif

let g:templ_templatesdir=g:templ_templates_install_dir . "/headers/"
let g:templ_Makefilesdir=g:templ_templates_install_dir . "/Makefiles/"

" Insert headers if any
au BufNewFile * call Headers()

" Insert headers corresponding to the file extension
function! Headers()
    "insert headers
    if expand('%')=~'presentation.tex'
        let header=g:templ_templatesdir . "beamer.tex"
        let type="beamer"
    else
        let type=expand('%:e')
        let header=g:templ_templatesdir . "headers.". l:type
    endif
    try
        execute "0read" header
    catch
    endtry
    if system("ls | grep Makefile")=="" && &ft !="" && system('ls ' . g:templ_Makefilesdir . '| grep Makefile_' . &ft)!="" && input("Do you want to import an existing makefile ? [y/N]") == "y"
        call ImportMakefile()
    endif
    execute "normal \<C-n>\<Right>"
endfunction

" Import makefile based on the filetype
function! ImportMakefile()
    try
        if system("ls | grep Makefile")=="" ||input("There is already one Makefile, do you want to overwrite it ? [y/N]")=="y"
            let mk=g:templ_Makefilesdir. "Makefile_" . &ft
            exe '!cp ' l:mk 'Makefile'
        endif
    catch
    endtry
endfunction


