#!/usr/bin/env zsh
# Init
ZSH="$HOME/.oh-my-zsh"

# Theme
ZSH_THEME="amuse"

# Oh My ZSH custom
ZSH_CUSTOM="$HOME/.oh-my-zsh-custom"

# Configs
DISABLE_AUTO_UPDATE="true"

# Plugins
plugins=()

## Vendor
#plugins+=(git)
plugins+=(emoji)
#plugins+=(thefuck)
#plugins+=(vi-mode)
#plugins+=(web-search)
plugins+=(colorize)

## Custom
plugins+=(zsh-autosuggestions)
plugins+=(zsh-syntax-highlighting)

# Init
source "$ZSH/oh-my-zsh.sh"
