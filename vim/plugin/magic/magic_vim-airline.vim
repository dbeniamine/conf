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

