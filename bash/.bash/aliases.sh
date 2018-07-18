#!/usr/bin/env bash
# Common
## `cd` aliases
alias ..="cd .."
alias cd..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias .....="cd ../../../.."
alias ......="cd ../../../../.."
alias ~="cd ~"

## `ls` aliases
alias ll="ls -alF"
alias la="ls -A"
alias l="ls -CF"

## `df` aliases
alias dfh="df -h --total"

## Colored output
if [ -x /usr/bin/dircolors ]; then
    alias ls='ls --color=auto'
    # alias dir='dir --color=auto'
    # alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

## Other
alias where="which"
alias afk="systemctl suspend -i"
alias fs='stat --format="%s bytes"'

# Git
alias g="git"
alias gl="git l"
alias glo="git lo"
alias glol="git lol"
alias gd="git d"
alias gdi="git di"
alias gs="git s"
alias gcb="git cb"

# SSH
alias sshpass="ssh -o PreferredAuthentications=password -o PubkeyAuthentication=no"

# Python
alias py="python"
alias py3="python3"

# Pygments
alias ccat="colorize"

# Webpack
alias wds="npx webpack-dev-server"
