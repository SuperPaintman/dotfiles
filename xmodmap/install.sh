#!/usr/bin/env bash

#
# This file is generated; DO NOT EDIT.
#

set -e

ROOT="$(dirname "$(realpath "${BASH_SOURCE[0]}")")"
EXIT_CODE=0

source "$ROOT/../common.sh"




if is_linux; then
    link $@ "$ROOT/.Xmodmap" "$HOME/.Xmodmap" || { EXIT_CODE="$?"; }
fi

exit "$EXIT_CODE"
