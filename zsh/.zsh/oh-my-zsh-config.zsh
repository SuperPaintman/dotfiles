#!/usr/bin/env zsh

# Init.
ZSH="$HOME/.oh-my-zsh"

# Oh My ZSH custom.
ZSH_CUSTOM="$HOME/.oh-my-zsh-custom"

# Configs.
DISABLE_AUTO_UPDATE="true"

# Plugins.
plugins=()

plugins+=(colored-man-pages)
plugins+=(sudo)

plugins+=(zsh-autosuggestions)
plugins+=(zsh-syntax-highlighting)

# Init.
source "$ZSH/oh-my-zsh.sh"
