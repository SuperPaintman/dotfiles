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
  link $@ "$ROOT/mimeapps.list" "$HOME/.config/mimeapps.list" || { EXIT_CODE="$?"; }


  
fi

if is_osx; then
  : # OSX specific files.
  

  
fi

exit "$EXIT_CODE"
