#!/usr/bin/env zsh
# Common
alias afk="systemctl suspend -i"

# Git
alias git="noglob git"
alias gl="git log --graph --all --abbrev-commit --date=relative --pretty=format:'%Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset'"
alias glog="git log --graph --all --decorate=auto"
alias glol="git log --graph --all --decorate=auto --pretty=oneline"
alias gd="git diff"
alias gdiff='git difftool -y -x "diff -W `tput cols` -y" | colordiff | less'
alias gs="git status"
alias gcb="git rev-parse --abbrev-ref HEAD"

# SSH
alias sshpass="ssh -o PreferredAuthentications=password -o PubkeyAuthentication=no"

# Python
alias py="python"
alias py3="python3"

# Pygments
alias ccat="colorize"
