#!/usr/bin/env bash

if [ -z "$HOOK_NAME" ]; then
    echo "Usage: HOOK_NAME=\"<name>\" $0 \$@" 1>&2
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

exit 0
