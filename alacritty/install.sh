#!/usr/bin/env bash

#
# This file is generated; DO NOT EDIT.
#

set -e

ROOT="$(dirname "$(realpath "${BASH_SOURCE[0]}")")"
EXIT_CODE=0

source "$ROOT/../common.sh"

link $@ "$ROOT/alacritty.toml" "$HOME/.config/alacritty/alacritty.toml" || { EXIT_CODE="$?"; }
link $@ "$ROOT/colors.toml" "$HOME/.config/alacritty/colors.toml" || { EXIT_CODE="$?"; }
link $@ "$ROOT/default.toml" "$HOME/.config/alacritty/default.toml" || { EXIT_CODE="$?"; }

if is_osx; then
    link $@ "$ROOT/macos.toml" "$HOME/.config/alacritty/macos.toml" || { EXIT_CODE="$?"; }
fi

exit "$EXIT_CODE"
