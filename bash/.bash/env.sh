#!/usr/bin/env bash

if can emacs; then
    export EDITOR="emacs"
elif can vim; then
    export EDITOR="vim"
elif can vi; then
    export EDITOR="vi"
elif can code; then
    export EDITOR="code"
fi
export CLICOLOR="yes"

export GOPATH="$HOME/.go"

# see: https://github.com/Homebrew/brew/blob/master/docs/Analytics.md#opting-out
export HOMEBREW_NO_ANALYTICS=1

if can fd; then
    export FZF_DEFAULT_COMMAND='fd --type f'
fi

# Nix.
export NIX_BUILD_SHELL=bash
