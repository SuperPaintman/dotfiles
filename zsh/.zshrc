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

# Oh My ZSH.
if [ -f  ~/.zsh/oh-my-zsh-config.zsh ]; then source ~/.zsh/oh-my-zsh-config.zsh; fi

# Init default bash config.
if [ -f ~/.bashrc ]; then source ~/.bashrc; fi

# Functions.
if [ -f ~/.zsh/functions.zsh ]; then source ~/.zsh/functions.zsh; fi

# Theme.
if [ -f  ~/.zsh/theme.zsh ]; then source ~/.zsh/theme.zsh; fi

# Show system information.
if can neofetch; then
    neofetch --no_config
fi
