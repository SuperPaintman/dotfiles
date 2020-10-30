#!/usr/bin/env bash

if [ -n "$PS1" ]; then
    if [ -f "${XDG_CONFIG_HOME:-"$HOME/.config"}/bash/bash_profile" ]; then
        source "${XDG_CONFIG_HOME:-"$HOME/.config"}/bash/bash_profile"
    elif [ -f ~/.bash_profile ]; then
        source ~/.bash_profile
    fi
fi
