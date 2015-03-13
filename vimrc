"========================= Pathogen ===========================================

"
" This section must stay at the beginning of the vimrc it loads the plugins
"

" Location of the bundle
runtime bundle/vim-pathogen/autoload/pathogen.vim
" Syntax must be off for pathogen
syntax off
" Do the infection
execute pathogen#infect()

"========================= General settings ===================================

"
" Appearance
"

" Colors
set bg=dark
colorscheme slate

" Syntax coloration
syntax on

" Show line number
set number

" Always show the status line
set laststatus=2

" Show commands while typing it
set showcmd

" Always show the completion menu
set completeopt=menuone,preview
highlight Pmenu ctermbg=gray ctermfg=black
highlight PmenuSel ctermbg=black ctermfg=white

" split at the right or below
set splitright
set splitbelow

" highlighting trailing spaces
highlight ExtraWhitespace ctermbg=red guibg=red
au BufWinEnter * match ExtraWhitespace /\s\+$/

" cursor line only on the active tab
augroup CursorLine
    au!
    au VimEnter,WinEnter,BufWinEnter * setlocal cursorline
    au WinLeave * setlocal nocursorline
augroup END

"
" Coding style
"

" Define tabs size
set shiftwidth=4
set tabstop=4
" Replace tab by spaces
set expandtab
set smartindent
set smarttab
" Define line size
set textwidth=78
set colorcolumn=80

"
" Behavior
"

" Allow mouse use
set mouse=a

" Fuck old vi
set nocompatible

" Encoding
set encoding=utf8

" Highlight searched word
set hlsearch
" Show results while typing the search
set incsearch

" Allow omni completion
set omnifunc=syntaxcomplete#Complete

" Change the <LocalLeader> key:
let maplocalleader = ","
let mapleader = ";"

"auto ident
filetype plugin indent on

"fold by syntaxic bloc
set foldmethod=syntax
set foldlevelstart=4

"
" User variables
"

"let g:my_tagsdir="~/.vim/tags/"

"========================= Filetype features ==================================

" C and Cpp ident and tags
au FileType c,cpp set cindent  tags+=~/.vim/tags/tags_c
au Filetype cpp set tags+=~/.vim/tags/tags_cpp

" Perl indent & fold (broken ?)
au FileType pl set ai

"It's all text plugin for firefox: activate spell checking
au BufEnter *mozilla/firefox/*/itsalltext/*.txt set spell spelllang=fr
" Markdown folds
au BufEnter *.md setlocal foldexpr=MdLevel() foldmethod=expr ft=pandoc
" Latex language
au FileType tex setlocal spell spelllang=en spellsuggest=5
au BufRead *.tex call SetTexLang()
" gitcommit spell
au FileType gitcommit setlocal spell spelllang=en

" Set compiler
au Filetype * call SetCompiler()


"========================== User mappings =====================================

"
"
" Easily move through windows
"

" First change the <C-j> mapping from latex suite to <C-n>
imap <C-n> <Plug>IMAP_JumpForward
nmap <C-n> <Plug>IMAP_JumpForward
" Then add moving shortcuts
noremap <C-h> <C-w>h
noremap <C-j> <C-w>j
noremap <C-k> <C-w>k
noremap <C-l> <C-w>l

"Clean search highlight
noremap <leader>c :let @/=""<CR>
"Redraw terminal
noremap <leader>l :redraw!<CR>

" Terminal escape
noremap <leader>s <ESC>:w<CR>:sh<CR>
" Auto indent
noremap <leader>i mzgg=G`z :delmarks z<CR>
" Remove trailing space
noremap <leader>tr :call RemoveTrailingSpace()<CR>

"
" Compilation mappings
"

" make
noremap <leader>m :call Compile(1,0,0,0,0,0)<CR>
" make & exec
noremap <leader>me :call Compile(1,0,0,0,1,0)<CR>
" make & install
noremap <leader>mi :call Compile(1,1,0,1,0,0)<CR>
" make parallel
noremap <leader>mj :call Compile(1,1,1,0,0,0)<CR>
" make install parallel
noremap <leader>mij :call Compile(1,1,1,1,0,0)<CR>
" make & exec parallel
noremap <leader>mje :call Compile(1,1,1,0,1,0)<CR>

" make clean
noremap <leader>mc :call Compile(1,0,0,0,0,1)<CR>
" exec
noremap <leader>e :call Compile(0,0,0,0,1,0)<CR><CR>

" Cscope_map.vim style map to create the cscope files
nnoremap <C-@>a :call Cscope_Init("create")<CR>
nnoremap <C-@>u :call Cscope_Init("update")<CR>

" Toggle spelllang
noremap <LocalLeader>l :call SwitchSpellLang()<CR>
" List of spellangs
let g:mySpellLang=['fr','en']


"========================= Functions ==========================================

" Switch between spellangs defined in g:mySpellLang
function! SwitchSpellLang()
    if &spell==0
        let l:index=0
        set spell
    else
        let l:curlang=index(g:mySpellLang,&spelllang)
        if l:curlang == len(g:mySpellLang)-1
            echo "Disabling spell"
            set nospell
            return
        endif
        let l:index=l:curlang+1
    endif
    let l:nlang=get(g:mySpellLang,l:index)
    echo "Setting spelllang: ".l:nlang
    let &spelllang=l:nlang
endfunction

" Remove trailing space
function! RemoveTrailingSpace()
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

" Set make and exec functon based on the filetype
function! SetCompiler()
    "Set compiler and start action according to filetype
    if &ft=='cpp'
        let b:my_makeprg="g\+\+\ \-Wall\ \-Werror\ \-g\ \-o\ %:t:r\ %"
        let b:start="./%:t:r"
    elseif &ft=='c'
        let b:my_makeprg="gcc\ \-Wall\ \-Werror\ \-g\ \-o\ %:t:r\ %"
        let b:start="./%:t:r"
    elseif &ft=='java'
        let b:my_makeprg="javac\ %"
        let b:start="java\ %:t:r"
    elseif &ft=='dot'
        let b:my_makeprg="dot\ \-Tpdf\ %\ \>\ %:t:r.pdf"
        let b:start="evince %:t:r.pdf > /dev/null 2>&1"
    elseif &ft=='pandoc'
        let b:my_makeprg="pandoc\ \--smart\ \--standalone\ \--mathml\ \--listings\ %\ \>\ %:t:r.html"
        let b:start="firefox %:t:r.html"
    elseif &ft=='tex'
        "Use latex-suite settings for compilation
        let b:my_makeprg=Tex_GetVarValue('Tex_CompileRule_'.g:Tex_DefaultTargetFormat)."\ %"
        let l:output="%:t:r.".g:Tex_DefaultTargetFormat
        let b:start=Tex_GetVarValue('Tex_ViewRule_'.g:Tex_DefaultTargetFormat)." ".l:output." &"
    else
        " works very often
        let b:start="./%"
    endif
    "If makefile are build xml, ovewrite previous settings
    if filereadable("Makefile")
        set makeprg='make'
        "Change the start only if the make run target exists
        execute "silent !cat Makefile | grep \"run[ ]*:\""
        if v:shell_error == 0
            let b:start="make\ run"
        endif
        return
    elseif filereadable("build.xml")
        set efm=%A\ %#[javac]\ %f:%l:\ %m,%-Z\ %#[javac]\ %p^,%-C%.%#
        set makeprg='ant'
        fi
    else
        if exists("b:my_makeprg")
            let &makeprg=b:my_makeprg
        endif
    endif
endfunction

"
" Start a compilation
" All arguments are booleans
" args:
"   compi:      Actually compile (or clean)
"   forcemake:  Use Makefile instead of makeprg
"   parallel:   Pass -j option to Makefile, require forcemake
"   install:    Do installation, require forcemake
"   exec:       Start an execution
"   clean:      doe a make clean, require forcemake
function! Compile(compi, forcemake, parallel, install, exec,clean)
    if(a:compi)
        "Do compile
        " Save the file
        :w
        let l:cmd=''
        if(a:forcemake)
            "Use make command
            if(a:clean)
                let l:cmd="make clean"
                execute ":Dispatch ".l:cmd
            endif
            let l:cmd="make"
            if(a:parallel)
                "Do it in parallel
                let l:ncores=system("cat /proc/cpuinfo | grep processor | wc -l")
                let l:ncores=substitute(l:ncores,"\n","","g")
                let l:cmd.=" -j ".l:ncores

            endif
            if(a:install)
                "Also do make install
                let l:oldcmd=l:cmd
                let l:cmd.=" && ".l:oldcmd." install"
            endif
        endif
        "Do the compilation with Dispatch
        execute ":Dispatch ".l:cmd
    endif
    if(a:exec)
        "execute the program
        execute ":!".b:start
        "Redraw screen if no errors
        if v:shell_error == 0
            " Let some time to be sure that the start command is finished
            :sleep 500m
            :redraw!
        endif
    endif
endfunction

"
" Tags and cscope
"

"Create or update cscope and tags files on demand
function! Cscope_Init (mode)
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
        :cscope add cscope.out
    else
        execute "silent !"ccmd" &"
        :cscope reset
    endif
endfunction

" Find the right language for latex spell checking
function! SetTexLang()
    let file = readfile(expand("%:p"))
    " read current file
    for line in file
        let g:myLang = matchstr(line, '\\usepackage\[.*\]{babel}')
        if(!empty(g:myLang))
            "extract the (list of) language
            let g:myLang = substitute(g:myLang, '\\usepackage\[',"", "")
            let g:myLang = substitute(g:myLang, '\]{babel}',"", "")
            "if there are more than one language, the last one is the main language
            let ind=stridx(g:myLang, ",")+1
            let g:myLang=strpart(g:myLang, ind,strlen(g:myLang))
            "now we have just to set correctly the spellang
            "echo "language detected : "g:myLang
            let g:myLang = strpart(g:myLang,0,2)
            let &l:spelllang=g:myLang
            return
        endif
    endfor
endfunction

" Wordcount should be a fast implem for status bar
function! WC()
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

" Markdown folds
function! MdLevel()
    let h = matchstr(getline(v:lnum), '^#\+')
    if empty(h)
        return "="
    else
        return ">" . len(h)
    endif
endfunction

"Insert a R chunk code
function! InsertRChunk()
    execute "normal mz"
    execute "normal i ```{<++>}"
    execute "normal o<++>"
    execute "normal o`̀ `<++>"
    execute "normal `z"
    delmarks z
endfunction


"==============================================================================
"
"                         Plugin Configuration section
"
"==============================================================================

"======================== Indent guides =======================================

let g:indent_guides_enable_on_vim_startup = 1
let g:indent_guides_guide_size = 1
let g:indent_guides_auto_colors = 0
hi IndentGuidesOdd  ctermbg=black
hi IndentGuidesEven ctermbg=lightgrey

"========================== Neocompl ==========================================

" Use neocomplcache.
let g:neocomplcache_enable_at_startup = 1
" Use smartcase.
let g:neocomplcache_enable_smart_case = 1
" Use camel case completion.
let g:neocomplcache_enable_camel_case_completion = 1
" Use underbar completion.
let g:neocomplcache_enable_underbar_completion = 1
" Set minimum syntax keyword length.
let g:neocomplcache_min_syntax_length = 3
let g:neocomplcache_lock_buffer_name_pattern = '\*ku\*'

" Define dictionary.
let g:neocomplcache_dictionary_filetype_lists = {
            \ 'default' : '',
            \ 'vimshell' : $HOME.'/.vimshell_hist',
            \ 'scheme' : $HOME.'/.gosh_completions'
            \ }

" Define keyword.
if !exists('g:neocomplcache_keyword_patterns')
    let g:neocomplcache_keyword_patterns = {}
endif
let g:neocomplcache_keyword_patterns['default'] ='\h\w*'


" Recommended key-mappings.
" <CR>: close popup and save indent.
inoremap <expr><CR>  neocomplcache#smart_close_popup()."\<CR>"
" <TAB>: completion.
inoremap <expr><TAB>  pumvisible() ? "\<C-n>" : "\<TAB>"
" <C-h>, <BS>: close popup and delete backword char.
inoremap <expr><C-h> neocomplcache#smart_close_popup()."\<C-h>"
inoremap <expr><BS> neocomplcache#smart_close_popup()."\<C-h>"
inoremap <expr><C-y>  neocomplcache#close_popup()
inoremap <expr><C-e>  neocomplcache#cancel_popup()

"========================== Latex-suite =======================================

" IMPORTANT: grep will sometimes skip displaying the file name if you
" " search in a singe file. This will confuse Latex-Suite. Set your grep
" " program to always generate a file-name.
set grepprg=grep\ -nH\ $*

" " OPTIONAL: Starting with Vim 7, the filetype of empty .tex files defaults to
" " 'plaintex' instead of 'tex', which results in vim-latex not being loaded.
" " The following changes the default filetype back to 'tex':
let g:tex_flavor='latex'

" TIP: if you write your \label's as \label{fig:something}, then if you
" " type in \ref{fig: and press <C-n> you will automatically cycle through
" " all the figure labels. Very useful!
set iskeyword+=:
let g:Tex_DefaultTargetFormat='pdf'
let g:Tex_CompileRule_pdf="pdflatex -interaction=nonstopmode $*"
let g:Tex_UseMakefile=1
"Map \it to Localeader i
imap <buffer> <LocalLeader>it <Plug>Tex_InsertItemOnThisLine
imap <C-b> <Plug>Tex_MathBF
imap <C-c> <Plug>Tex_MathCal
imap <C-l> <Plug>Tex_LeftRight

"======================== Commentary ==========================================

au filetype pandoc let b:commentary_format="<!--%s-->"
au filetype rmd let b:commentary_format="#%s"

"======================== Airline =============================================

let g:airline_section_z = '%p%% %#__accent_bold#%l%#__restore__#:%c %{WC()}W'
" Unicode symbols
let g:airline_left_sep = '▶'
let g:airline_right_sep = '◀'
let g:airline_symbols_branch = '⎇'
" Fugitive
let g:airline#extensions#branch#enabled = 1
" Tabs
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#buffer_min_count = 2
let g:airline#extensions#tabline#tab_min_count = 0

"======================== OmniCppComplete======================================
"
" Autocomplete with ->, ., ::
let OmniCpp_MayCompleteDot = 1
let OmniCpp_MayCompleteArrow = 1
let OmniCpp_MayCompleteScope = 1
" Select first item
let OmniCpp_SelectFirstItem = 1
" Search namespaces in this and included files
let OmniCpp_NamespaceSearch = 2
" Show function prototype (i.e. parameters) in popup window
let OmniCpp_ShowPrototypeInAbbr = 1

"======================== Templates ===========================================

" This is ugly but for the moment the simplest way to find the templates is to
" give the path of the install directory
let g:templ_templates_install_dir="~/.vim/bundle/vim-templates"

"======================== Vim-R-plugin ========================================

"Insert a chunk code
au filetype r,rmd,rhelp,rnoweb,rrst noremap <LocalLeader>nc :call InsertRChunk()<CR>

"======================== Todo.txt ============================================

let g:Todo_txt_first_level_sort_mode="! i"

"Intelligent completion for projects and contexts
au filetype todo imap + +<C-X><C-U>
au filetype todo imap @ @<C-X><C-U>
au filetype todo setlocal completefunc=TodoComplete

"======================== EasyGrep ============================================

" Track the current extension
let g:EasyGrepMode=2
" Exlude extension list
let g:EasyGrepFilesToExclude='*.swp,*~,*.o,*.ko,*.ali'
" Recursive mode
let g:EasyGrepRecursive=1
" Multiples matchs on same line ('g' flag)
let g:EasyGrepEveryMatch=1
" Replace all works per file
let g:EasyGrepReplaceAllPerFile=1

"======================== CheckAttach (mutt) ==================================
let g:attach_check_keywords=',PJ,ci-joint,pièce jointe'
let g:checkattach_once = 'y'
