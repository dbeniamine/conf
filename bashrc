#
# Stuff here are done for both interactive and non interactive session
# do not add anything except if you know what you are doing
#

#PATH
export PATH="$PATH:/home/david/scripts/:/home/david/install/bin:/usr/local/cuda-5.0/bin:/sbin/"
#the only true editor is vim
export EDITOR=vim


#
# After this changes are made only for interactive sessions
#
[ -z "$PS1" ] && return

#
# Source other configuration files
#
bashdir="$HOME/.bash.d"
for f in $(\ls $bashdir)
do
    . $bashdir/$f
done

#
# TERMINAL
#

if [ -e /usr/share/terminfo/x/xterm+256color ]; then
    export TERM='xterm-256color'
else
    export TERM='xterm-color'
fi


#
# PROMPT
#

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
    debian_chroot_ps1="\[$Yellow\]${debian_chroot:+($debian_chroot)}"
fi

case "$TERM" in
    xterm*|rxvt*)
        #Red or green depending on last command result
        command_color="if [[ \$? == 0 ]]; then echo -n \"\[$Green\]\"; else \
            echo -n \"\[$Red\]\"; fi"
        #git ps1 settings
        GIT_PS1_SHOWDIRTYSTATE=1
        GIT_PS1_SHOWSTASHSTATE=1
        GIT_PS1_SHOWUNTRACKEDFILES=
        GIT_PS1_SHOWCOLORHINTS=1
        GIT_PS1_DESCRIBE_STYLE="branch"
        GIT_PS1_SHOWUPSTREAM="auto git"

        #actual prompt
        PS1="\[$Cyan\][\D{%x} \A]$debian_chroot_ps1 \$($command_color)\u@\h$Color_Off:\[$Blue\]\w\[$Yellow\]\$(__git_ps1)\n\[$Color_Off\]\$ "
        ;;
    *)
        ;;
esac


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
# Env variables
#

#for sofa kaapi
export KAAPI_DIR=/home/david/install/kaapi
export PKG_CONFIG_PATH=$PKG_CONFIG_PATH:/home/david/lib/plasma-installer_2.4.6/install/lib/pkgconfig
export LD_LIBRARY_PATH=/home/david/install/kaapi/lib:$LD_LIBRARY_PATH

#for adasdl.gpr
export GPR_PROJECT_PATH=/usr/local/lib/ada/adasdl_alpha20120723a/Thin/AdaSDL

# mutt background fix
export COLORFGBG="default;default"
