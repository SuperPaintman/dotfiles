#!/usr/bin/env bash

#
# This file is generated; DO NOT EDIT.
#

set -e

ROOT="$(dirname "$(realpath "${BASH_SOURCE[0]}")")"
EXIT_CODE=0

source "$ROOT/../common.sh"

link $@ "$ROOT/keybindings.json" "$HOME/.config/Code/User/keybindings.json" || { EXIT_CODE="$?"; }
link $@ "$ROOT/settings.json" "$HOME/.config/Code/User/settings.json" || { EXIT_CODE="$?"; }
link $@ "$ROOT/snippets" "$HOME/.config/Code/User/snippets" || { EXIT_CODE="$?"; }

exit "$EXIT_CODE"
