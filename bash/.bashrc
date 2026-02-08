#!/usr/bin/env bash

# Backword compatability until files are migrated.
if [ -f ~/.bashrc.migration ]; then source ~/.bashrc.migration; fi

if [ -n "$PS1" ] && [ -f ~/.bash_profile ]; then
    source ~/.bash_profile
fi

# Local (If we have one).
if [ -f ~/.bashrc.local ]; then source ~/.bashrc.local; fi
