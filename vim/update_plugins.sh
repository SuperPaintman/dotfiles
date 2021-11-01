#!/usr/bin/env bash

set -e

ROOT="$(dirname "$(realpath "${BASH_SOURCE[0]}")")"

rm -rf "${ROOT}/.vim/plugged" || { exit "$?"; }
vim -c 'let g:plug_home = "'"${ROOT}/.vim/plugged"'" | PlugInstall! | qa' || { exit "$?"; }
rm -rf "${ROOT}/.vim/plugged/**/.git" || { exit "$?"; }
