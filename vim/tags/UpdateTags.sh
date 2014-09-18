#!/bin/bash
args="-R --c++-kinds=+p --fields=+iaS --extra=+q --language-force=C++"
cppinputs='/usr/include/c++'
ctags $args -f tags_cpp $cppinputs
ctags $args -f tags_c -L clibToTag

