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

"========================= Pathogen {{{1 ======================================

" This section must stay at the beginning of the vimrc it loads the plugins
" Manually add pathogen bundle {{{2
runtime bundle/vim-pathogen/autoload/pathogen.vim
" Do the infection {{{2
syntax off " Syntax must be off for pathogen infection
execute pathogen#infect()

"========================= General settings {{{1 ==============================

"====================== Appearance {{{2 =======================================

set nocompatible

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

"Completion colors
highlight Pmenu ctermbg=gray ctermfg=black
highlight PmenuSel ctermbg=black ctermfg=white


" highlighting trailing spaces
highlight ExtraWhitespace ctermbg=red guibg=red
au BufWinEnter * match ExtraWhitespace /\s\+$/

" Status command line tab completion
set wildmenu

" keep at least two lines above cursor
set scrolloff=2

" keep fiver column aside of the cursor
set sidescrolloff=5

" Show lastline if possible
set display=lastline

" Character to show with :list command
set listchars=tab:>\ ,trail:-,extends:>,precedes:<,nbsp:+

"====================== Coding style {{{2 =====================================

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

"====================== Behavior {{{2 =========================================

" cursor line only on the active tab
augroup CursorLine
    au!
    au VimEnter,WinEnter,BufWinEnter * setlocal cursorline
    au WinLeave * setlocal nocursorline
augroup END

" split at the right or below
set splitright
set splitbelow


" Always show the completion menu
set completeopt=longest,menuone,preview

" Allow mouse use
set mouse=a

" Encoding
set encoding=utf-8

" Highlight searched word
set hlsearch
" Show results while typing the search
set incsearch

" Change the <LocalLeader> key:
let maplocalleader = ","
let mapleader = ";"

"auto ident
filetype plugin indent on
set omnifunc=syntaxcomplete#Complete

"fold by syntaxic bloc
set foldmethod=syntax
set foldlevelstart=4

" Wait for a keymap
set ttimeout
set ttimeoutlen=100

" Delete comment character when joining commented lines
set formatoptions+=j

" Re-read files modified out of vim
set autoread

" Also try to read mac files
set fileformats+=mac

" Keep a long history
set history=1000

"====================== Filetype settings {{{2 ================================

" C and Cpp ident and tags
au FileType c,cpp set cindent  tags+=~/.vim/tags/tags_c
au Filetype cpp set tags+=~/.vim/tags/tags_cpp

" Perl indent & fold (broken ?)
au FileType pl set ai

"It's all text plugin for firefox: activate spell checking
au BufEnter *mozilla/firefox/*/itsalltext/*.txt set spell spelllang=fr
" Markdown folds
au BufEnter *.md,*.markdown setlocal foldexpr=MdLevel() foldmethod=expr
            \ ft=pandoc foldlevel=1
" Latex language
au FileType tex,vimwiki setlocal spell spelllang=en spellsuggest=5
au BufRead *.tex call SetTexLang()
" gitcommit spell
au FileType gitcommit setlocal spell spelllang=en
" mutt files
au BufEnter *.mutt setfiletype muttrc
" Configuration files
au FileType vim,muttrc,conf,mailcap setlocal foldmethod=marker foldlevel=1
" Disable NeoComplete for certain filetypes
au Filetype tex,cpp if exists(":NeoCompleteDisable") | NeoCompleteDisable | endif

au Filetype vimwiki setlocal foldlevel=2 number

"====================== Mappings {{{2 =========================================

" Easily move through windows

" First change the <C-j> mapping from latex suite to <C-m>
imap <C-m> <Plug>IMAP_JumpForward
nmap <C-m> <Plug>IMAP_JumpForward
" Then add moving shortcuts
noremap <C-h> <C-w>h
noremap <C-j> <C-w>j
noremap <C-k> <C-w>k
noremap <C-l> <C-w>l

"Clean search highlight
noremap <silent> <leader>c :let @/=""<CR>
"Redraw terminal
noremap <leader>l :redraw!<CR>

" Terminal escape
" noremap <leader>s <ESC>:w<CR>:sh<CR>
noremap <leader>s <ESC>:Start<CR>
" Auto indent
noremap <leader>i mzgg=G`z :delmarks z<CR>

" Open a new tab
noremap <leader>t <Esc>:tabnew

" Remove trailing space
noremap <leader>tr :call RemoveTrailingSpace()<CR>

" Cscope_map.vim style map to create the cscope files
nnoremap <C-@>a :call Cscope_Init("create")<CR>
nnoremap <C-@>u :call Cscope_Init("update")<CR>

" Validate menu entry with enter
inoremap <expr> <CR> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"

" Go to the directoring containing current file
nnoremap <leader>cd :cd %:h<CR>
nnoremap <leader>cc :cd -<CR>

" Compile all wiki
noremap <Leader>wa :VimwikiAll2HTML<CR>:edit<CR>
noremap <Leader>waw :VimwikiAll2HTML<CR>:Vimwiki2HTMLBrowse<CR>:edit<CR>


"====================== Functions {{{1 ========================================

" Remove trailing space {{{2
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

"Create or update cscope and tags files on demand {{{2
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

" Find the right language for latex spell checking {{{2
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

" Wordcount should be a fast implem for status bar {{{2
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

" Markdown folds {{{2
function! MdLevel()
    let h = matchstr(getline(v:lnum), '^#\+')
    if empty(h)
        return "="
    else
        return ">" . len(h)
    endif
endfunction

"Insert a R chunk code {{{2
function! InsertRChunk()
    execute "normal mz"
    execute "normal i```{<++>}"
    execute "normal o<++>"
    execute "normal o```<++>"
    execute "normal `z"
    delmarks z
endfunction

"====================== Plugin Configuration {{{1 =============================

"====================== Indent guides {{{2 ====================================

let g:indent_guides_enable_on_vim_startup = 1
let g:indent_guides_guide_size = 1
let g:indent_guides_auto_colors = 0
hi IndentGuidesOdd  ctermbg=black
hi IndentGuidesEven ctermbg=lightgrey

"====================== Neocompl {{{2 =========================================

" Use neocomplcache.
let g:neocomplete#enable_at_startup = 1
" Use smartcase.
let g:neocomplete#enable_smart_case = 1
" Use camel case completion.
let g:neocomplete#enable_camel_case_completion = 1
"let g:neocomplete#lock_buffer_name_pattern = '\*ku\*'

" Enable heavy omni completion.
if !exists('g:neocomplete#sources#omni#input_patterns')
  let g:neocomplete#sources#omni#input_patterns = {}
endif
"let g:neocomplete#sources#omni#input_patterns.php = '[^. \t]->\h\w*\|\h\w*::'
let g:neocomplete#sources#omni#input_patterns.c = '[^.[:digit:] *\t]\%(\.\|->\)'
let g:neocomplete#sources#omni#input_patterns.cpp = '[^.[:digit:] *\t]\%(\.\|->\)\|\h\w*::'

let g:neocomplete#enable_auto_select = 1
let g:neocomplete#disable_auto_complete = 1

"====================== Commentary {{{2 =======================================

au filetype pandoc let b:commentary_format="<!--%s-->"
au filetype rmd let b:commentary_format="#%s"

"====================== Airline {{{2 ==========================================

let g:airline_section_z = '%p%% %#__accent_bold#%l%#__restore__#:%c'
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

"====================== OmniCppComplete {{{2 ==================================
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
"====================== Templates {{{2 ========================================

" This is ugly but for the moment the simplest way to find the templates is to
" give the path of the install directory
let g:templ_templates_install_dir="~/.vim/bundle/vim-templates"

"====================== Vim-R-plugin {{{2 =====================================

"Insert a chunk code
au filetype r,rmd,rhelp,rnoweb,rrst inoremap <LocalLeader>r <ESC>:call InsertRChunk()<CR>i

"====================== Todo.txt {{{2 =========================================

let g:Todo_txt_first_level_sort_mode="! i"

"Intelligent completion for projects and contexts
au filetype todo imap <buffer> + +<C-X><C-O>
au filetype todo imap <buffer> @ @<C-X><C-O>
au filetype todo setlocal omnifunc=TodoComplete

"====================== EasyGrep {{{2 =========================================

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

"====================== CheckAttach (mutt) {{{2 ===============================

let g:attach_check_keywords=',PJ,ci-joint,pièce jointe,attached'
let g:checkattach_once = 'y'

"====================== VimMail (mutt) {{{2 ===================================

au filetype mail setlocal spell spelllang=fr textwidth=72 colorcolumn=74

let g:VimMailClient="/home/david/scripts/mutt.sh -t \"Mutt RO\" -R &"

"====================== Compile {{{2 ==========================================

let g:VimCompileExecutors={'pandoc' : "firefox %:p:r.html > /dev/null 2>&1",}

"====================== Licenses {{{2 =========================================

let g:licenses_copyright_holders_name = 'Beniamine, David <David@Beniamine.net>'
let g:licenses_authors_name = 'Beniamine, David <David@Beniamine.net>'

"====================== Vizardry {{{2 =========================================

let g:VizardryGitMethod="submodule add"
let g:VizardryGitBaseDir="/home/david/Documents/Conf"
let g:VizardryNbScryResults=20
let g:VizardryReadmeReader='view -c "set ft=pandoc" -'
let g:VizardrySortScryResults=""

"====================== VimWiki {{{2 ==========================================

"let g:vimwiki_html_header_numbering = 2
let g:vimwiki_list = [{'path':'~/Work/Wiki', 'path_html':'~/Work/Wiki/WWW'}]
let g:vimwiki_folding='expr'

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
endfunction " }}}


