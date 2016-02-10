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
augroup trailing
    au!
    au BufWinEnter * match ExtraWhitespace /\s\+$/
augroup END

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

" netwrw window size
let g:netrw_winsize = 22
let g:netrw_browse_split = 3
let g:netrw_browsex_viewer= "xdg-open"


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

augroup ftsettings
    au!
    " C and Cpp ident and tags
    au FileType c,cpp set cindent  tags+=~/.vim/tags/tags_c
    au Filetype cpp set tags+=~/.vim/tags/tags_cpp
    
    " Perl indent & fold (broken ?)
    au FileType pl set ai
    
    "It's all text plugin for firefox: activate spell checking
    au BufEnter *mozilla/firefox/*/itsalltext/*.txt set spell spelllang=fr
    
    " Markdown folds
    au BufEnter *.md,*.markdown setlocal foldexpr=vimrc#pandoc#MdLevel() foldmethod=expr
                \ ft=pandoc
    au BufRead *.md,*.markdown setlocal foldlevel=1
    " Latex language
    au FileType tex,vimwiki setlocal spell spelllang=en spellsuggest=5
    au BufRead *.tex call vimrc#tex#SetLang()
    au Filetype plaintex set ft=tex
    
    " gitcommit spell
    au FileType gitcommit setlocal spell spelllang=en
    
    " mutt files
    au BufEnter *.mutt setfiletype muttrc
    " Configuration files
    au FileType vim,muttrc,conf,mailcap setlocal foldmethod=marker foldlevel=1
    
    " Disable NeoComplete for certain filetypes
    au Filetype tex,cpp if exists(":NeoCompleteDisable") | NeoCompleteDisable | endif
    
    " Wiki fold 
    au Filetype vimwiki setlocal foldlevel=2 number

    "Insert a chunk code
    au filetype r,rmd,rhelp,rnoweb,rrst inoremap <LocalLeader>r <ESC>:call
                \ vimrc#r#InsertChunk()<CR>i

augroup END

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

" Toggle Explorer
noremap <silent> <Leader>f :Lexplore<CR>

"Clean search highlight
noremap <silent> <leader>c :let @/=""<CR>
"Redraw terminal
noremap <silent><leader>l :redraw!<CR>

" Terminal escape
" noremap <leader>s <ESC>:w<CR>:sh<CR>
noremap <silent><leader>s <ESC>:Start<CR>
" Auto indent
noremap <silent><leader>i mzgg=G`z :delmarks z<CR>

" Open a new tab
noremap <leader>t <Esc>:tabnew

" Remove trailing space
noremap <silent><leader>tr :call vimrc#RemoveTrailingSpace()<CR>

" Cscope_map.vim style map to create the cscope files
nnoremap <silent><C-@>a :call vimrc#cscope#Init("create")<CR>
nnoremap <silent><C-@>u :call vimrc#cscope#Init("update")<CR><CR>:redraw!<CR>

" Validate menu entry with enter
inoremap <expr> <CR> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"

" Go to the directoring containing current file
nnoremap <silent><leader>cd :cd %:h<CR>
nnoremap <silent><leader>cc :cd -<CR>

" Compile all wiki
noremap <silent><Leader>wa :VimwikiAll2HTML<CR>:edit<CR>
noremap <silent><Leader>waw :VimwikiAll2HTML<CR>:Vimwiki2HTMLBrowse<CR>:edit<CR>


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

augroup commentaryvimrc
    au!
    au filetype pandoc let b:commentary_format="<!--%s-->"
    au filetype rmd let b:commentary_format="#%s"
augroup END

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
" Syntastic
let g:airline#extensions#syntastic#enabled = 1

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

"====================== Todo.txt {{{2 =========================================

let g:Todo_txt_first_level_sort_mode="! i"

"Intelligent completion for projects and contexts
augroup todotxt
    au!
    au filetype todo imap <buffer> + +<C-X><C-O>
    au filetype todo imap <buffer> @ @<C-X><C-O>
    au filetype todo setlocal omnifunc=todo#Complete
augroup END

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

"====================== CheckAttach & VimMail (mutt) {{{2 =====================

augroup mail
    au!
    au filetype mail setlocal spell spelllang=fr textwidth=72 colorcolumn=74
    au filetype mail let g:attach_check_keywords=',PJ,ci-joint,pièce jointe,attached'
    au filetype mail let g:checkattach_once = 'y'
    au filetype mail let g:VimMailClient="/home/david/scripts/mutt.sh -t \"Mutt RO\" -R &"
augroup END

"====================== Compile {{{2 ==========================================



let g:VimCompileCustomStarter=function("vimrc#tex#Starter")

let g:VimCompileExecutors={'pandoc' : "firefox %:p:r.html > /dev/null 2>&1",}

"====================== Licenses {{{2 =========================================

let g:licenses_copyright_holders_name = 'Beniamine, David <David@Beniamine.net>'
let g:licenses_authors_name = 'Beniamine, David <David@Beniamine.net>'

"====================== Vizardry {{{2 =========================================

let g:VizardryGitMethod="submodule add"
let g:VizardryGitBaseDir="/home/david/Documents/Conf"
let g:VizardryNbScryResults=20
let g:VizardryReadmeReader='view -c "set ft=pandoc" -'
let g:VizardryViewReadmeOnEvolve=1

"====================== VimWiki {{{2 ==========================================

"let g:vimwiki_html_header_numbering = 2
let g:vimwiki_list = [{'path':'~/Work/Wiki', 'path_html':'~/Work/Wiki/WWW',
            \'nested_syntaxes': { 'python': 'python', 'c++': 'cpp',
            \'sh': 'sh', 'c': 'c'}}]
let g:vimwiki_folding='expr'

"====================== EasyMotion {{{2 =======================================

" let EasyMotion_do_shade=0

"====================== Open-url {{{2 =========================================

let g:open_url_browser="xdg-open"

"====================== Templates {{{2 ========================================

let g:VimTemplates_templatesdir="~/.vim/templates/"
let g:VimTemplates_Makefilesdir="~/.vim/Makefiles/"

"====================== SudoEdit {{{2 =========================================

let g:sudo_no_gui=1
