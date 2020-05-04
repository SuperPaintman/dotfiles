#!/usr/bin/env bash

#===============================================================================
# Replacements and default flags.
#===============================================================================
# `cat`.
if can bat; then
    # Replace `cat` with `bat`.
    alias cat='bat'
fi

# `ls`.
if can exa; then
    # Replace `ls` with `exa`.
    alias ls='exa --color=auto'
elif can gls; then
    alias ls='gls --color=auto'
else
    alias ls='ls --color=auto'
fi

# `tree`.
alias tree='tree -C'

# `grep`.
alias grep='grep --color=auto --exclude-dir={.bzr,CVS,.git,.hg,.svn}'

# `fgrep`.
alias fgrep='fgrep --color=auto'

# `egrep`.
alias egrep='egrep --color=auto'

# `open`.
if ! can open && can xdg-open; then
    alias open='xdg-open'
fi

# `pbcopy`.
if ! can pbcopy; then
    alias pbcopy='xclip -selection clipboard'
fi

# `pbpaste`.
if ! can pbpaste; then
    alias pbpaste='xclip -selection clipboard -o'
fi

# `npx`
alias npx='npx --no-install'

#===============================================================================
# Shortcats.
#===============================================================================
# `cd`.
alias ..='cd ..'
alias cd..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'
alias ......='cd ../../../../..'
alias ~='cd ~'

# Use `lfcd` (`lf`) as `cd` without arguments.
if can lfcd; then
    cd() {
        if [ "$#" = 0 ]; then
            lfcd
        else
            builtin cd $@
        fi
    }
fi

# `ls`.
alias ll='ls -alFh --group-directories-first'
alias la='ls -ah --group-directories-first'
alias l='ls -Fh --group-directories-first'

# `df`.
alias dfh='df -h --total'

# `tree`.
alias t='tree'

# `git`.
alias g='git'
alias gl='git l'
alias glo='git lo'
alias glol='git lol'
alias gd='git d'
alias gdi='git di'
alias gs='git s'
alias gcb='git cb'
alias gcm='git cm'

# `which`.
alias where='which'

# `can`.
alias has='can'

# `python`.
alias py='python'
alias py3='python3'

# `webpack-dev-server`.
alias wds='npx webpack-dev-server'

# Misc.
alias e="$EDITOR"
alias map="xargs -n1"
# alias afk="systemctl suspend -i"
alias sshpass='ssh -o PreferredAuthentications=password -o PubkeyAuthentication=no'
