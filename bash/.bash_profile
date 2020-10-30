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

# Global env.
if [ -d "${XDG_CONFIG_HOME:-"$HOME/.config"}/bash" ]; then
    export BASHDOTDIR="${BASHDOTDIR:-"${XDG_CONFIG_HOME:-"$HOME/.config"}/bash"}"
else
    export BASHDOTDIR="${BASHDOTDIR:-"$HOME"}"
fi

if [ "$BASHDOTDIR" = "$HOME" ]; then
    export BASH_FILES="$HOME/.bash"
else
    export BASH_FILES="$BASHDOTDIR"
fi

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
if [ -f "$BASH_FILES/env.sh" ]; then source "$BASH_FILES/env.sh"; fi

# Path.
if [ -f "$BASH_FILES/path.sh" ]; then source "$BASH_FILES/path.sh"; fi

# Functions.
if [ -f "$BASH_FILES/functions.sh" ]; then source "$BASH_FILES/functions.sh"; fi

# Aliases.
if [ -f "$BASH_FILES/aliases.sh" ]; then source "$BASH_FILES/aliases.sh"; fi

# Theme.
if [ -f "$BASH_FILES/theme.sh" ]; then source "$BASH_FILES/theme.sh"; fi


# === Bash only ===
if [ -n "$ZSH_VERSION" ]; then
    return 0 2> /dev/null || exit 0
fi

# Bash history
if [ -n "$XDG_DATA_HOME" ] && [ -d "$XDG_DATA_HOME" ]; then
    if [ ! -d "$XDG_DATA_HOME/bash" ]; then
        mkdir -p "$XDG_DATA_HOME/bash"
    fi

    export HISTFILE="$XDG_DATA_HOME/bash/bash_history"
fi
export HISTTIMEFORMAT='[%F %T] '
export HISTCONTROL=ignoreboth
export HISTSIZE=2000
export HISTFILESIZE="$HISTSIZE"
export HISTIGNORE="&:[ ]*:history:clear"

shopt -s histappend
shopt -s checkwinsize

# Key bindings.
if [ -f "$BASH_FILES/key-bindings.sh" ]; then source "$BASH_FILES/key-bindings.sh"; fi

# Completions.
if [ -f "$BASH_FILES/completions.sh" ]; then source "$BASH_FILES/completions.sh"; fi

# Show system information.
if can neofetch; then
    neofetch --no_config --config "${XDG_CONFIG_HOME:-"$HOME/.config"}/neofetch/config.conf"
fi
