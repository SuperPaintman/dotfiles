#!/usr/bin/env bash

set -e

# go get github.com/mvdan/sh/cmd/shfmt
shfmt -i 4 -ci -sr -s -w $(
    find . \
        \( -type f -name '*.sh' -or -name '*.bash' -or -name '*.zsh' \) \
        -and \
        -not -path './zsh/.oh-my-zsh/**' \
        -and \
        -not -path './zsh/.oh-my-zsh-custom/**' \
        -and \
        -not -path './vim/.vim/bundle/**' \
        -and \
        -not -path './tmux/.tmux/plugins/**' \
        -and \
        -not -path '**/node_modules/**'
)
