#!/usr/bin/env zsh

# Note: ^ - Ctrl .

# Use vim key bindings.
# TDDO(SuperPaintman):
#     One day... I wanna add mode indicator in the prompt.
#     But I dont know how to detect VISUAL and REPLACE modes.
# bindkey -v

# Escape back to the normal mode.
# bindkey -M viins 'jk' vi-cmd-mode

# Accepts the current `zsh-autosuggestions` suggestion.
bindkey -M viins '^ ' autosuggest-accept

if can fzf-share && [ -f "$(fzf-share)/key-bindings.zsh" ]; then
    source "$(fzf-share)/key-bindings.zsh"
fi

if can git-fzf; then
    eval "$(git-fzf shell zsh status '^g^s')"
    eval "$(git-fzf shell zsh branch '^g^b')"
    eval "$(git-fzf shell zsh log '^g^l')"
fi
