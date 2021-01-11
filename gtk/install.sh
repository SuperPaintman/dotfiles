#!/usr/bin/env bash

set -e

source "$(dirname "$(realpath "${BASH_SOURCE[0]}")")/../common.sh"

is_force=false
for arg in "$@"; do
    case $arg in
        -f)
            is_force=true
            ;;
    esac
done

if ! is_linux; then
    exit
fi

TARGET_ROOT="$HOME"
SOURCE_ROOT="$(dirname "$(realpath "${BASH_SOURCE[0]}")")"

mkdir -p "$TARGET_ROOT/.config"

linkall \
    "$SOURCE_ROOT/gtk-3.0" \
    "$TARGET_ROOT/.config/gtk-3.0" \
    "$is_force" \
    "settings.ini"
