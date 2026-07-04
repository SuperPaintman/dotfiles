#!/usr/bin/env bash

#===============================================================================
# Replacements and default flags.
#===============================================================================
# `cat`.
# NOTE(SuperPaintman): migrated
if can bat; then
    # Replace `cat` with `bat`.
    alias cat='bat'
fi

# `ls`.
# NOTE(SuperPaintman): migrated
if can eza; then
    # Replace `ls` with `eza`.
    alias ls='eza --color=auto'
elif can exa; then
    # Replace `ls` with `exa`.
    alias ls='exa --color=auto'
elif can gls; then
    alias ls='gls --color=auto'
else
    alias ls='ls --color=auto'
fi

# `tree`.
# NOTE(SuperPaintman): migrated
alias tree='tree -C'

# `grep`.
# NOTE(SuperPaintman): migrated
alias grep='grep --color=auto' # --exclude-dir={.bzr,CVS,.git,.hg,.svn}

# `fgrep`.
# NOTE(SuperPaintman): migrated
alias fgrep='fgrep --color=auto'

# `egrep`.
# NOTE(SuperPaintman): migrated
alias egrep='egrep --color=auto'

# `open`.
# NOTE(SuperPaintman): migrated
if ! can open && can xdg-open; then
    alias open='xdg-open'
fi

# `pbcopy`.
# NOTE(SuperPaintman): migrated
if ! can pbcopy; then
    alias pbcopy='xclip -selection clipboard'
fi

# `pbpaste`.
# NOTE(SuperPaintman): migrated
if ! can pbpaste; then
    alias pbpaste='xclip -selection clipboard -o'
fi

# `npx`.
# NOTE(SuperPaintman): migrated
alias npx='npx --no-install'

# `vim`, `vi` and `v`.
# NOTE(SuperPaintman): migrated
if can nvim; then
    alias vim='nvim'
    alias vi='nvim'
    alias v='nvim'
elif can vim; then
    alias vi='vim'
    alias v='vim'
elif can vi; then
    alias v='vi'
fi

# `neomutt` and `mutt`.
# NOTE(SuperPaintman): don't want to migrate it.
if can neomutt; then
    alias mutt='neomutt'
fi

#===============================================================================
# Shortcats.
#===============================================================================
# `cd`.
# NOTE(SuperPaintman): migrated
alias ..='cd ..'
alias cd..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'
alias ......='cd ../../../../..'
alias ~='cd ~'

# Use `lfcd` (`lf`) as `cd` without arguments.
# NOTE(SuperPaintman): migrated
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
# NOTE(SuperPaintman): migrated
alias ll='ls -alh --group-directories-first'
alias la='ls -ah --group-directories-first'
alias l='ls -h --group-directories-first'

# `df`.
# NOTE(SuperPaintman): migrated
alias dfh='df -h --total'

# `tree`.
# NOTE(SuperPaintman): don't want to migrate it.
alias t='tree'

# `git`.
# NOTE(SuperPaintman): migrated
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
# NOTE(SuperPaintman): migrated
alias where='which'

# `can`.
# NOTE(SuperPaintman): don't want to migrate it.
alias has='can'

# `python`.
# NOTE(SuperPaintman): migrated
alias py='python'
alias py3='python3'

# `webpack-dev-server`.
# NOTE(SuperPaintman): don't want to migrate it.
alias wds='npx webpack-dev-server'

# Misc.
# NOTE(SuperPaintman): migrated
alias e="$EDITOR"

# NOTE(SuperPaintman): don't want to migrate it.
alias map="xargs -n1"
# NOTE(SuperPaintman): don't want to migrate it.
alias sshpass='ssh -o PreferredAuthentications=password -o PubkeyAuthentication=no'
