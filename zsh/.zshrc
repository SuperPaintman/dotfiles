#!/usr/bin/env zsh
# Autoload
autoload -U zmv

# Init default bash config
if [ -f ~/.bashrc ]; then
    source ~/.bashrc
fi

# Completion
source ~/.zsh/completion.zsh

# Oh My ZSH
source ~/.zsh/oh-my-zsh-config.zsh

# Theme
source ~/.zsh/theme.zsh
