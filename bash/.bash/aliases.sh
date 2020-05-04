#!/usr/bin/env bash

# Common
## `cat` aliases
if can bat; then
    alias cat="bat"
fi

## `cd` aliases
alias ..="cd .."
alias cd..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias .....="cd ../../../.."
alias ......="cd ../../../../.."
alias ~="cd ~"

if which lfcd > /dev/null 2>&1; then
    cd() {
        if [ "$#" = 0 ]; then
            lfcd
        else
            builtin cd $@
        fi
    }
fi

## `ls` aliases
if can exa; then
    alias ls="exa --color=auto"
elif can gls; then
    alias ls="gls --color=auto"
else
    alias ls="ls --color=auto"
fi
alias ll="ls -alFh --group-directories-first"
alias la="ls -ah --group-directories-first"
alias l="ls -Fh --group-directories-first"

## `df` aliases
alias dfh="df -h --total"

## `tree` aliases
alias tree="tree -C"
alias t="tree"

## `grep`, `fgrep`, `egrep` aliases
alias grep="grep --color=auto --exclude-dir={.bzr,CVS,.git,.hg,.svn}"
alias fgrep="fgrep --color=auto"
alias egrep="egrep --color=auto"

## Open
if ! can open && can xdg-open; then
    alias open="xdg-open"
fi

## Other
alias e="$EDITOR"
alias where="which"
alias afk="systemctl suspend -i"
alias fs='stat --format="%s bytes"'
alias map="xargs -n1"

# Git
alias g="git"
alias gl="git l"
alias glo="git lo"
alias glol="git lol"
alias gd="git d"
alias gdi="git di"
alias gs="git s"
alias gcb="git cb"
alias gcm="git cm"

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

# `pbcopy` and `pbpaste`
if ! can pbcopy; then
    alias pbcopy="xclip -selection clipboard"
fi
if ! can pbpaste; then
    alias pbpaste="xclip -selection clipboard -o"
fi
