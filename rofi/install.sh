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

TARGET_ROOT="$HOME/.config/rofi"
SOURCE_ROOT="$(dirname "$(realpath "${BASH_SOURCE[0]}")")"

mkdir -p "$TARGET_ROOT"

linkall \
    "$SOURCE_ROOT" \
    "$TARGET_ROOT" \
    "$is_force" \
    "config.rasi" \
    "colors.rasi" \
    "theme.rasi"
