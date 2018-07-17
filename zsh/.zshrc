#!/usr/bin/env zsh
# Autoload
autoload -U zmv

# Init default bash config
if [ -f ~/.bashrc ]; then
    source ~/.bashrc
fi

# Completion
if [ -f ~/.zsh/completion.zsh ]; then source ~/.zsh/completion.zsh; fi

# Oh My ZSH
if [ -f  ~/.zsh/oh-my-zsh-config.zsh ]; then source ~/.zsh/oh-my-zsh-config.zsh; fi

# Theme
if [ -f  ~/.zsh/theme.zsh ]; then source ~/.zsh/theme.zsh; fi
