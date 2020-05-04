#!/usr/bin/env zsh

# Note: ^ - Ctrl .

# Use vim key bindings.
bindkey -v

# Escape back to the normal mode.
bindkey -M viins 'jk' vi-cmd-mode

# Accepts the current `zsh-autosuggestions` suggestion.
bindkey -M viins '^ ' autosuggest-accept
