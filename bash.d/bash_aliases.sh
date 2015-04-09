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
alias ls='ls -hlstr --color=tty'
alias la='ls -A'
alias rm='rm -v'
alias cp='cp -v'
alias shutdown="sudo shutdown -h -P now"
alias cscope='cscope -dRq'
#If the agent is empty, try to add keys, else do a simple ssh command
alias ssh=". $HOME/scripts/sshAutoAgent.sh; ssh-add -l > /dev/null || ssh-add && ssh"

#i3 (colors)
alias dmenu="dmenu -sb darkgreen"

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
        myopts=''
        if [ "x$DISPLAY" != "x" ]
        then
            myopts='--servername VIM'
        fi
        tmux new-session "TERM=$TERM \vim $myopts $arg"
    }
    alias vim='tvim'
    alias vi='vim'
fi
