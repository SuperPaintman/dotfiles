#!/usr/bin/env bash

#
# This file is generated; DO NOT EDIT.
#

set -e

ROOT="$(dirname "$(realpath "${BASH_SOURCE[0]}")")"
EXIT_CODE=0

source "$ROOT/../common.sh"

link $@ "$ROOT/alacritty.yml" "$HOME/.config/alacritty/alacritty.yml" || { EXIT_CODE="$?"; }
link $@ "$ROOT/colors.yml" "$HOME/.config/alacritty/colors.yml" || { EXIT_CODE="$?"; }
link $@ "$ROOT/default.yml" "$HOME/.config/alacritty/default.yml" || { EXIT_CODE="$?"; }



if is_osx; then
  : # OSX specific files.
  link $@ "$ROOT/macos.yml" "$HOME/.config/alacritty/macos.yml" || { EXIT_CODE="$?"; }


  
fi
exit "$EXIT_CODE"
