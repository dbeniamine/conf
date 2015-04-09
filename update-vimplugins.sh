#!/bin/bash
# Copyright (C) 2015  Beniamine, David <David@Beniamine.net>
# Author: Beniamine, David <David@Beniamine.net>
# 
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
# 
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
# 
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.

if [ ! -z "$1" ]
then
    echo  "This script tries to update vim plugins either as submodules or from vim.org"
    echo  "For plugin from vim.org it uses a .metainfos file that you should manually initialise"
    echo "  A .metainfos file contains two line:"
    echo "    The url of the vimscript"
    echo "    The current version number (0 for init)"
fi

echo "Updating git submodules"
git submodule init
git submodule update
git submodule foreach git pull origin master
echo "Updatings scripts from vim.org"
subl=$(cat .gitmodules  | grep "path\s=" | cut -d '=' -f 2)
prefix=vim/bundle
baseln="http://www.vim.org/scripts"
which atool > /dev/null
if [ $? -ne 0 ]
then
    echo "Please install atool"
    exit 1
fi
opwd=$PWD
for f in $(\ls $prefix)
do
    if [ -z "$(echo $subl | grep $f)" ]
    then
        cd $prefix/$f
        if [ ! -e .metainfos ]
        then
            echo "No metainfos for $prefix/$f"
            echo "  A .metainfos file contains two line:"
            echo "    The url of the vimscript"
            echo "    The current version number (0 for init)"
        else
            ln=$(head -n 1 .metainfos)
            wget $ln -q -O $$.php
            l=$(($(grep -n "span.*script version" $$.php  | cut -d ':' -f 1)+1))
            l="$l"d
            text=$(sed 1,$l $$.php  | egrep -v "(vba|vmb)" | grep "href.*download" -A 3 | head -n 3)
            nln=$baseln/$(echo $text | sed 's/.*href="\([^"]*\).*".*/\1/')
            file=$(echo $text | sed 's/.*href=[^>]*>\([^<]*\)<.*/\1/')
            ver=$(echo $text | sed 's/.*<\/td>.*<b>\(.*\)<\/b>.*/\1/')
            oldver=$(tail -n 1 .metainfos)
            if [ "$ver" != "$oldver" ]
            then
                echo "updating $f current version $oldver, newest $ver"
                rm -rf ./*
                echo -e "$ln\n$ver" > .metainfos
                wget $nln -q -O $file
                atool -qx $file
                if [ $? -ne 0 ]
                then
                    echo "Unable to extract archive for plugin $f"
                    echo "You might need to finish the update manually"
                else
                    rm $file
                    dir=$(\ls .)
                    mv $dir/* .
                    rmdir $dir
                fi
            else
                echo "plugin $f up to date, last version $ver"
            fi
            rm $$.php
        fi
        cd $opwd
    fi
done
