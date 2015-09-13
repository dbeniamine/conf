#!/bin/bash
#            DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE
#                    Version 2, December 2004
# 
# Copyright (C) 2015 Beniamine, David <David@Beniamine.net>
# Author: Beniamine, David <David@Beniamine.net>
# 
# Everyone is permitted to copy and distribute verbatim or modified
# copies of this license document, and changing it is allowed as long
# as the name is changed.
# 
#            DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE
#   TERMS AND CONDITIONS FOR COPYING, DISTRIBUTION AND MODIFICATION
# 
#  0. You just DO WHAT THE FUCK YOU WANT TO.


# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

#Human, List, Sort, by Time, Reverse
alias ls='ls -hlstr --color=auto'
alias la='ls -A'
alias rm='rm -v'
alias cp='cp -v'
alias shutdown="sudo shutdown -h -P now"
alias cscope='cscope -dRq'

#i3 (colors)
alias dmenu="dmenu -sb darkgreen"

# Set git email address according to repo location
# MAIL and WORK_MAIL must be set before
set_git_mail()
{
    if [[ "$PWD" =~ "$HOME/Work" ]]
    then
        export GIT_COMMITTER_EMAIL=$WORK_MAIL
        export GIT_AUTHOR_EMAIL=$WORK_MAIL
    else
        export GIT_COMMITTER_EMAIL=$MAIL
        export GIT_AUTHOR_EMAIL=$MAIL
    fi
}
alias git='set_git_mail; git'

#
# Tmux vim
#

#Avoid nested session
if [ ! -z $(which tmux) ] && [ -z $TMUX ]
then

    function tvim()
    {
        # Using directly $@ seems to add a ' at the end of the first argument
        # which makes tmux bug so there is an ugly hack to recreate a clean
        # argument list
        arg=""
        while [ ! -z $1 ]
        do
            arg="$arg $1"
            shift
        done
        if [ ! -z "$DISPLAY" ] && [ -z "$(echo $arg | grep 'servername')" ]
        then
            id=$(\vim --serverlist | grep 'VIM[0-9][0-9]*' | wc -l)
            myopts="--servername VIM$id"
        fi
        tmux new-session "TERM=$TERM \vim $myopts $arg"
    }
    alias vim='tvim'
    alias vi='vim'
fi
