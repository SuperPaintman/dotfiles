#!/usr/bin/env zsh

if can fzf-share && [ -f "$(fzf-share)/completion.zsh" ]; then
    source "$(fzf-share)/completion.zsh"
elif can brew && brew --prefix fzf > /dev/null 2>&1 && [ -f "$(brew --prefix fzf)/shell/completion.zsh" ]; then
    source "$(brew --prefix fzf)/shell/completion.zsh"
fi
