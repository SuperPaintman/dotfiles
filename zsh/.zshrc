#!/usr/bin/env zsh
# Autoload
autoload -U zmv

# Oh My ZSH
if [ -f  ~/.zsh/oh-my-zsh-config.zsh ]; then source ~/.zsh/oh-my-zsh-config.zsh; fi

# Init default bash config
if [ -f ~/.bashrc ]; then
    source ~/.bashrc
fi

# Functions
if [ -f ~/.zsh/functions.zsh ]; then source ~/.zsh/functions.zsh; fi

# Completion
if [ -f ~/.zsh/completion.zsh ]; then source ~/.zsh/completion.zsh; fi

# Theme
if [ -f  ~/.zsh/theme.zsh ]; then source ~/.zsh/theme.zsh; fi

# Show system information
if which neofetch > /dev/null 2>&1; then
    neofetch
fi
