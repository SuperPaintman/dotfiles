#!/usr/bin/env bash

#
# This file is generated; DO NOT EDIT.
#

set -e

ROOT="$(dirname "$(realpath "${BASH_SOURCE[0]}")")"
EXIT_CODE=0

source "$ROOT/../common.sh"

link $@ "$ROOT/.oh-my-zsh" "$HOME/.oh-my-zsh" || { EXIT_CODE="$?"; }
link $@ "$ROOT/.oh-my-zsh-custom" "$HOME/.oh-my-zsh-custom" || { EXIT_CODE="$?"; }
link $@ "$ROOT/.zsh" "$HOME/.zsh" || { EXIT_CODE="$?"; }
link $@ "$ROOT/.zshrc" "$HOME/.zshrc" || { EXIT_CODE="$?"; }


link --optional $@ "$ROOT/.zsh.local" "$HOME/.zsh.local" || { EXIT_CODE="$?"; }
link --optional $@ "$ROOT/.zshrc.local" "$HOME/.zshrc.local" || { EXIT_CODE="$?"; }


if is_linux; then
  : # Linux specific files.
  

  
fi

if is_osx; then
  : # OSX specific files.
  

  
fi

exit "$EXIT_CODE"
