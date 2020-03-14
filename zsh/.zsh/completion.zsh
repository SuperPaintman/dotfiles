#!/usr/bin/env zsh
if serve --completion=zsh > /dev/null 2>&1; then
    eval "$(serve --completion=zsh)"
fi
