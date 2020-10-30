#!/usr/bin/env zsh

# Autoload.
autoload -U zmv

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
# See: http://zsh.sourceforge.net/Intro/intro_3.html
if [ -d "${XDG_CONFIG_HOME:-"$HOME/.config"}/zsh" ]; then
    export ZDOTDIR="${ZDOTDIR:-"${XDG_CONFIG_HOME:-"$HOME/.config"}/zsh"}"
else
    export ZDOTDIR="${ZDOTDIR:-"$HOME"}"
fi

if [ "$ZDOTDIR" = "$HOME" ]; then
    export ZSH_FILES="$HOME/.zsh"
else
    export ZSH_FILES="$ZDOTDIR"
fi

# Oh My ZSH.
if [ -f "$ZSH_FILES/oh-my-zsh-config.zsh" ]; then source "$ZSH_FILES/oh-my-zsh-config.zsh"; fi

# Init default bash config.
# Do it after Oh My ZSH because it will set it's own aliases.
if [ -f "${XDG_CONFIG_HOME:-"$HOME/.config"}/bash/bashrc" ]; then
    source "${XDG_CONFIG_HOME:-"$HOME/.config"}/bash/bashrc"
elif [ -f ~/.bashrc ]; then
    source ~/.bashrc
fi

# Config.
if [ -f "$ZSH_FILES/config.zsh" ]; then source "$ZSH_FILES/config.zsh"; fi

# Functions.
if [ -f "$ZSH_FILES/functions.zsh" ]; then source "$ZSH_FILES/functions.zsh"; fi

# Theme.
if [ -f "$ZSH_FILES/theme.zsh" ]; then source "$ZSH_FILES/theme.zsh"; fi

# Key bindings.
if [ -f "$ZSH_FILES/key-bindings.zsh" ]; then source "$ZSH_FILES/key-bindings.zsh"; fi

# Completions.
if [ -f "$ZSH_FILES/completions.zsh" ]; then source "$ZSH_FILES/completions.zsh"; fi

# Show system information.
if can neofetch; then
    neofetch --no_config --config "${XDG_CONFIG_HOME:-"$HOME/.config"}/neofetch/config.conf"
fi
