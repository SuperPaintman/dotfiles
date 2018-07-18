#!/usr/bin/env bash

if ! which realpath > /dev/null; then
    # OSX dirty replacement for `realpath`
    realpath() {
        [[ $1 = /* ]] && echo "$1" || echo "$PWD/${1#./}"
    }
fi

source "$(dirname "$(realpath "${BASH_SOURCE[0]}")")/../common.sh"

is_force=false
for arg in "$@"; do
    case $arg in
        -f)
            is_force=true
            ;;
    esac
done

TARGET_ROOT="$HOME"
SOURCE_ROOT="$(dirname "$(realpath "${BASH_SOURCE[0]}")")"

linkall \
    "$SOURCE_ROOT" \
    "$TARGET_ROOT" \
    "$is_force" \
    ".ctags"
