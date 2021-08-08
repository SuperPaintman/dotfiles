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

# Env.
if [ -f ~/.zsh/env.sh ]; then source ~/.zsh/env.sh; fi

# Functions.
if [ -f ~/.zsh/functions.zsh ]; then source ~/.zsh/functions.zsh; fi

# Theme.
if [ -f ~/.zsh/theme.zsh ]; then source ~/.zsh/theme.zsh; fi

# Key bindings.
if [ -f ~/.zsh/key-bindings.zsh ]; then source ~/.zsh/key-bindings.zsh; fi

# Completions.
if [ -f ~/.zsh/completions.zsh ]; then source ~/.zsh/completions.zsh; fi

# Local (If we have one).
if [ -f ~/.zshrc.local ]; then source ~/.zshrc.local; fi

# Show system information. Do not show it in tmux.
if [ -z "$IN_NIX_SHELL" ] && [ -z "$TMUX" ] && can neofetch; then
    neofetch --no_config --config ~/.config/neofetch/config.conf
fi
