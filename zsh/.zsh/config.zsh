#!/usr/bin/env zsh

if [ -n "$XDG_DATA_HOME" ] && [ -d "$XDG_DATA_HOME" ]; then
    if [ ! -d "$XDG_DATA_HOME/zsh" ]; then
        mkdir -p "$XDG_DATA_HOME/zsh"
    fi

    export HISTFILE="$XDG_DATA_HOME/zsh/zsh_history"
fi
