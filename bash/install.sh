#!/usr/bin/env bash

#
# This file is generated; DO NOT EDIT.
#

set -e

ROOT="$(dirname "$(realpath "${BASH_SOURCE[0]}")")"
EXIT_CODE=0

source "$ROOT/../common.sh"

link $@ "$ROOT/.bash" "$HOME/.bash" || { EXIT_CODE="$?"; }
link $@ "$ROOT/.bash_profile" "$HOME/.bash_profile" || { EXIT_CODE="$?"; }
link $@ "$ROOT/.bashrc" "$HOME/.bashrc" || { EXIT_CODE="$?"; }

link --optional $@ "$ROOT/.bash.local" "$HOME/.bash.local" || { EXIT_CODE="$?"; }
link --optional $@ "$ROOT/.bash_profile.local" "$HOME/.bash_profile.local" || { EXIT_CODE="$?"; }
link --optional $@ "$ROOT/.bashrc.local" "$HOME/.bashrc.local" || { EXIT_CODE="$?"; }
exit "$EXIT_CODE"
