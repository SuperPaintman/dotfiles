#!/usr/bin/env bash

export XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-"$HOME/.config"}"
export XDG_CACHE_HOME="${XDG_CACHE_HOME:-"$HOME/.cache"}"
export XDG_DATA_HOME="${XDG_DATA_HOME:-"$HOME/.local/share"}"
export XDG_BIN_HOME="${XDG_BIN_HOME:-"$HOME/.local/bin"}"

export EDITOR="vim"
export CLICOLOR="yes"

export GOPATH="$HOME/.go"

# see: https://github.com/Homebrew/brew/blob/master/docs/Analytics.md#opting-out
export HOMEBREW_NO_ANALYTICS=1

if can fd; then
    export FZF_DEFAULT_COMMAND='fd --type f'
fi
