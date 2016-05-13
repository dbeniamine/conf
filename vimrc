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
let mapleader = " "

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
    au BufRead *.tex call SetTexLang()
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
    " Auto open / close R terminal
    au VimEnter *.rmd execute "normal ".maplocalleader."rf"
    au VimLeave *.rmd execute "normal ".maplocalleader."rq"
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
noremap <silent><Leader>wac :execute ':!rm -rvf '.g:vimwiki_list[0].path_html.'/*'<CR>

" Toggle Gitgutter highlight
nnoremap <silent><Leader>gg :GitGutterLineHighlightsToggle<CR>
