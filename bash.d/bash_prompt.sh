# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
    deb_chr_ps1="${Yellow}${debian_chroot:+($debian_chroot)} "
fi

# gitprompt configuration

# Set config variables first
# GIT_PROMPT_ONLY_IN_REPO=1

# GIT_PROMPT_FETCH_REMOTE_STATUS=0   # uncomment to avoid fetching remote status

# Retrieve color names
. ~/.bash.d/bash-git-prompt/prompt-colors.sh


# Date and time
Prompt_Time="${White}\D{%x} \A${ResetColor}"
# chroot user@host:path
Prompt_UserPath="$deb_chr_ps1\u@\h${ResetColor}:${Cyan}\w${ResetColor}"

# Pre git stuff
GIT_PROMPT_START="$Prompt_Time _LAST_COMMAND_INDICATOR_ $Prompt_UserPath"

# Real git colors
GIT_PROMPT_PREFIX="${Yellow}("
GIT_PROMPT_BRANCH="${Yellow}"
GIT_PROMPT_SUFFIX="${Yellow})${ResetColor}"
GIT_PROMPT_SEPARATOR="${Yellow}|"

# Post git stuff
GIT_PROMPT_END="\n\\$ "

# as last entry source the gitprompt script
#GIT_PROMPT_THEME="Custom" # use custom .git-prompt-colors.sh
#GIT_PROMPT_THEME=Solarized # use theme optimized for solarized color scheme

. ~/.bash.d/bash-git-prompt/gitprompt.sh
