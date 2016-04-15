let g:VimCompileCustomStarter=function("vimrc#tex#Starter")

let g:VimCompileExecutors={'pandoc' : "firefox %:p:r.html > /dev/null 2>&1",}
