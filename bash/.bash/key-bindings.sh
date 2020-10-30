#!/usr/bin/env bash

if can fzf-share && [ -f "$(fzf-share)/key-bindings.bash" ]; then
    source "$(fzf-share)/key-bindings.bash"
elif can brew && brew --prefix fzf > /dev/null 2>&1 && [ -f "$(brew --prefix fzf)/shell/key-bindings.bash" ]; then
    source "$(brew --prefix fzf)/shell/key-bindings.bash"
fi
