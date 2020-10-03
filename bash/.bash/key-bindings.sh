#!/usr/bin/env bash

if can fzf-share && [ -f "$(fzf-share)/key-bindings.bash" ]; then
    source "$(fzf-share)/key-bindings.bash"
fi
