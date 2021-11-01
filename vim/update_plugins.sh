#!/usr/bin/env bash

set -e

ROOT="$(dirname "$(realpath "${BASH_SOURCE[0]}")")"

rm -rf "${ROOT}/.vim/plugged" || { exit "$?"; }
vim -u NONE -c 'let g:plug_update_all = 1 | let g:plug_home = "'"${ROOT}/.vim/plugged"'" | source ~/.vimrc | PlugInstall! | qa' || { exit "$?"; }
rm -rf "${ROOT}/.vim/plugged/"**"/.git" || { exit "$?"; }
