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
if _is_osx; then
    alias ls="gls --color=auto"
else
    alias ls="ls --color=auto"
fi
alias ll="ls -alFh --group-directories-first"
alias la="ls -Ah --group-directories-first"
alias l="ls -CFh --group-directories-first"

## `df` aliases
alias dfh="df -h --total"

## `tree` aliases
alias tree="tree -C"
alias t="tree"

## `grep`, `fgrep`, `egrep` aliases
alias grep="grep --color=auto --exclude-dir={.bzr,CVS,.git,.hg,.svn}"
alias fgrep="fgrep --color=auto"
alias egrep="egrep --color=auto"

## Other
alias e="$EDITOR"
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

# NPM and NPX
alias npx="npx --no-install"

# Webpack
alias wds="npx webpack-dev-server"
