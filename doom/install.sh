#!/usr/bin/env bash

#
# This file is generated; DO NOT EDIT.
#

set -e

ROOT="$(dirname "$(realpath "${BASH_SOURCE[0]}")")"
EXIT_CODE=0

source "$ROOT/../common.sh"

link $@ "$ROOT/config.el" "$HOME/.doom.d/config.el" || { EXIT_CODE="$?"; }
link $@ "$ROOT/init.el" "$HOME/.doom.d/init.el" || { EXIT_CODE="$?"; }
link $@ "$ROOT/packages.el" "$HOME/.doom.d/packages.el" || { EXIT_CODE="$?"; }




if is_linux; then
  : # Linux specific files.
  

  
fi

if is_osx; then
  : # OSX specific files.
  

  
fi

exit "$EXIT_CODE"
