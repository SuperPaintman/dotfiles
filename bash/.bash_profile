#!/usr/bin/env bash

# Global functions.

# Replacement for `which $1 > /dev/null 2>&1`.
can() {
    if [ "$#" = 0 ]; then
        return 1
    fi

    command -v "$1" > /dev/null
    return "$?"
}

# Start tmux.
if can tmux; then
    if [ -z "$TMUX" ] && [ "$TERM_PROGRAM" = "iTerm.app" ]; then
        if tmux list-session > /dev/null 2>&1; then
            tmux attach-session && exit
        else
            tmux && exit
        fi
    fi
fi

# Init.
if [ -x /usr/bin/lesspipe ]; then
    eval "$(SHELL=/bin/sh lesspipe)"
fi

if [ -x /usr/bin/dircolors ]; then
    if [ -f ~/.dircolors ]; then
        eval "$(dircolors -b ~/.dircolors)"
    else
        eval "$(dircolors -b)"
    fi
fi

# Env.
if [ -f ~/.bash/env.sh ]; then source ~/.bash/env.sh; fi

# Path.
if [ -f ~/.bash/path.sh ]; then source ~/.bash/path.sh; fi

# Functions.
if [ -f ~/.bash/functions.sh ]; then source ~/.bash/functions.sh; fi

# Aliases.
if [ -f ~/.bash/aliases.sh ]; then source ~/.bash/aliases.sh; fi

# Theme.
if [ -f ~/.bash/theme.sh ]; then source ~/.bash/theme.sh; fi


# === Bash only ===
if [ -n "$ZSH_VERSION" ]; then
    return 0 2> /dev/null || exit 0
fi

# Bash history
export HISTTIMEFORMAT='[%F %T] '
export HISTCONTROL=ignoreboth
export HISTSIZE=2000
export HISTFILESIZE="$HISTSIZE"
export HISTIGNORE="&:[ ]*:history:clear"

shopt -s histappend
shopt -s checkwinsize

# Key bindings.
if [ -f ~/.bash/key-bindings.sh ]; then source ~/.bash/key-bindings.sh; fi

# Completions.
if [ -f ~/.bash/completions.sh ]; then source ~/.bash/completions.sh; fi

# Show system information. Do not show it in tmux.
if [ -z "$TMUX" ] && can neofetch; then
    neofetch --no_config --config ~/.config/neofetch/config.conf
fi
