#!/usr/bin/env zsh

if [ -n "$XDG_CACHE_HOME" ] && [ -d "$XDG_CACHE_HOME" ]; then
    export HISTFILE="$XDG_CACHE_HOME/zsh_history"
fi
