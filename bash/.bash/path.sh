#!/usr/bin/env bash

# Rust
export PATH="$HOME/.cargo/bin:$PATH"

# Go
if [[ -n $GOPATH ]]; then
    export PATH="$PATH:$GOPATH/bin"
fi

# Local bins
export PATH="$PATH:/usr/local/bin"

# User's bins
export PATH="$HOME/bin:$PATH"
