#!/usr/bin/env bash

set -euo pipefail

ROOT="$(dirname "$(realpath "${BASH_SOURCE[0]}")")/.."
cd "$ROOT"

rm -rf ".tests"

nvim --headless -c "PlenaryBustedDirectory . {minimal_init = 'tests/init.lua', sequential = true}"

