#!/usr/bin/env bash

if [ -n "$PS1" ] && [ -f ~/.bash_profile ]; then
    source ~/.bash_profile
fi

# Local (If we have one).
if [ -f ~/.bashrc.local ]; then source ~/.bashrc.local; fi
