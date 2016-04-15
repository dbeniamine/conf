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


#
# Stuff here are done for both interactive and non interactive session
# do not add anything except if you know what you are doing
#

unalias -a
# PATH
export PATH="$PATH:$HOME/scripts/:$HOME/install/bin:/usr/local/cuda-5.0/bin:/sbin/"
# The only true editor is vim
export EDITOR=vim
# I hate that fucking bell !
xset b off
# For Inria printers
export CUPS_USER="dbeniami"

#
# After this changes are made only for interactive sessions
#
[ -z "$PS1" ] && return

# PATH
export PATH="$PATH:$HOME/scripts/pass-tools"

#
# Source other configuration files
#
bashdir="$HOME/.bash.d"
for f in $(\ls $bashdir)
do
    if [ -f "$bashdir/$f" ]
    then
        . $bashdir/$f
    fi
done
unset f
unset bashdir

#
# TERMINAL
#

if [ -e /usr/share/terminfo/x/xterm+256color ]; then
    export TERM='xterm-256color'
else
    export TERM='xterm-color'
fi

#
# History
#

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
    if [ -f /usr/share/bash-completion/bash_completion ]; then
        . /usr/share/bash-completion/bash_completion
    elif [ -f /etc/bash_completion ]; then
        . /etc/bash_completion
    fi
fi

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize


#
# Environment
#

# For sofa kaapi
# export KAAPI_DIR=$HOME/install/kaapi
# export PKG_CONFIG_PATH=$PKG_CONFIG_PATH:$HOME/lib/plasma-installer_2.4.6/install/lib/pkgconfig
# export LD_LIBRARY_PATH=$HOME/install/kaapi/lib:$LD_LIBRARY_PATH

# For adasdl.gpr
# export GPR_PROJECT_PATH=/usr/local/lib/ada/adasdl_alpha20120723a/Thin/AdaSDL

# mutt background fix
export COLORFGBG="default;default"
