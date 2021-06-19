#!/usr/bin/env bash

#
# This file is generated; DO NOT EDIT.
#

set -e

ROOT="$(dirname "$(realpath "${BASH_SOURCE[0]}")")"
EXIT_CODE=0

source "$ROOT/../common.sh"






if is_linux; then
  : # Linux specific files.
  link $@ "$ROOT/colors.rasi" "$HOME/.config/rofi/colors.rasi" || { EXIT_CODE="$?"; }
link $@ "$ROOT/config.rasi" "$HOME/.config/rofi/config.rasi" || { EXIT_CODE="$?"; }
link $@ "$ROOT/lib" "$HOME/.config/rofi/lib" || { EXIT_CODE="$?"; }
link $@ "$ROOT/modes" "$HOME/.config/rofi/modes" || { EXIT_CODE="$?"; }
link $@ "$ROOT/theme.rasi" "$HOME/.config/rofi/theme.rasi" || { EXIT_CODE="$?"; }


  
fi

if is_osx; then
  : # OSX specific files.
  

  
fi

exit "$EXIT_CODE"
