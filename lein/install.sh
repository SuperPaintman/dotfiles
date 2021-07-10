#!/usr/bin/env bash

#
# This file is generated; DO NOT EDIT.
#

set -e

ROOT="$(dirname "$(realpath "${BASH_SOURCE[0]}")")"
EXIT_CODE=0

source "$ROOT/../common.sh"

link $@ "$ROOT/profiles.clj" "$HOME/.lein/profiles.clj" || { EXIT_CODE="$?"; }

exit "$EXIT_CODE"
