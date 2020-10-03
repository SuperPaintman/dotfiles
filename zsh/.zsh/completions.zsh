#!/usr/bin/env zsh

if can fzf-share && [ -f "$(fzf-share)/completion.zsh" ]; then
    source "$(fzf-share)/completion.zsh"
fi
