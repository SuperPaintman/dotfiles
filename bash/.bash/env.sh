#!/usr/bin/env bash

# NOTE(SuperPaintman): migrated
if can nvim; then
    export EDITOR="nvim"
elif can vim; then
    export EDITOR="vim"
elif can vi; then
    export EDITOR="vi"
elif can emacs; then
    export EDITOR="emacs"
elif can code; then
    export EDITOR="code"
fi

# NOTE(SuperPaintman): migrated
export CLICOLOR="yes"

# NOTE(SuperPaintman): migrated
export GOPATH="$HOME/.go"

# see: https://github.com/Homebrew/brew/blob/master/docs/Analytics.md#opting-out
# NOTE(SuperPaintman): migrated
export HOMEBREW_NO_ANALYTICS=1

# NOTE(SuperPaintman): migrated
if can fd; then
    export FZF_DEFAULT_COMMAND='fd --type f'
fi

# Git.
# NOTE(SuperPaintman): migrated
if can difft; then
    export GIT_EXTERNAL_DIFF="difft"
fi

# Nix.
# NOTE(SuperPaintman): migrated
export NIX_BUILD_SHELL=bash

# Bat.
# NOTE(SuperPaintman): migrated
if [ -f "$HOME/.config/bat/themes/SuperPaintman/SuperPaintman.tmTheme" ]; then
    export BAT_THEME="SuperPaintman"
else
    export BAT_THEME="TwoDark"
fi
