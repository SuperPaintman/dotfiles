#!/usr/bin/env zsh

if can fzf-share && [ -f "$(fzf-share)/completion.zsh" ]; then
    source "$(fzf-share)/completion.zsh"
elif can brew && brew --prefix fzf > /dev/null 2>&1 && [ -f "$(brew --prefix fzf)/shell/completion.zsh" ]; then
    source "$(brew --prefix fzf)/shell/completion.zsh"
fi

# ZStyle
# Use caching to make completion for commands.
zstyle ':completion::complete:*' use-cache on

# Add groups names.
# zstyle ':completion:*' format '%F{yellow}[%d]%f'
zstyle ':completion:*' format "$(printf "\x1b[90m")"'[%d]'"$(printf "\x1b[0m")"

# Do not complete unavailable commands.
zstyle ':completion:*:functions' ignored-patterns '(_*)'

## Make
# Outputs all possible results for make targets.
zstyle ':completion:*:make:*:targets' call-command on

# Show only targets.
zstyle ':completion:*:make:*' tag-order targets
# zstyle ':completion:*:make:*' tag-order targets,variables
