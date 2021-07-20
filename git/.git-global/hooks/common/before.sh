#!/usr/bin/env bash

HOOK_NAME="${HOOK_NAME:-"$(basename "$(basename "$0")")"}"
if [ "$HOOK_NAME" = "" ]; then
    exit 1
fi

GIT_DIR="${GIT_DIR:-"$(git rev-parse --show-toplevel)"}"
if [ "$?" != 0 ]; then
    exit "$?"
fi

# Run local git hook if it exists.
if [ -e "$GIT_DIR/.git/hooks/$HOOK_NAME" ]; then
    eval "$GIT_DIR/.git/hooks/$HOOK_NAME" $@
    exit "$?"
fi
