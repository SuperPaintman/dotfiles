#!/usr/bin/env bash

set -euo pipefail

FILTER="${1:-.}"
FILTER="$(realpath "$FILTER")"

ROOT="$(dirname "$(realpath "${BASH_SOURCE[0]}")")/.."
cd "$ROOT"

rm -rf ".tests"

nvim --headless -c "PlenaryBustedDirectory $FILTER {minimal_init = 'tests/init.lua', sequential = true}"

