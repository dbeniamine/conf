#!/bin/bash
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
