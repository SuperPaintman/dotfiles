#!/usr/bin/env bash

#
# This file is generated; DO NOT EDIT.
#

set -e

ROOT="$(dirname "$(realpath "${BASH_SOURCE[0]}")")"
EXIT_CODE=0

source "$ROOT/../common.sh"

link $@ "$ROOT/.gitconfig" "$HOME/.gitconfig" || { EXIT_CODE="$?"; }


link --optional $@ "$ROOT/.gitconfig.local" "$HOME/.gitconfig.local" || { EXIT_CODE="$?"; }

exit "$EXIT_CODE"
