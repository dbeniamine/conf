"mail autocorrect
set spell spelllang=fr 
"format 
set textwidth=72 colorcolumn=74
" Start mutt in RO mode 
map <LocalLeader>m :! /home/david/scripts/mutt.sh -t "Mutt RO" -R &<CR>
