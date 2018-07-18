#!/usr/bin/env bash

if ! which realpath > /dev/null; then
  # OSX dirty replacement for `realpath`
  realpath() {
    [[ $1 = /* ]] && echo "$1" || echo "$PWD/${1#./}"
  }
fi

source "$(dirname "$(realpath "${BASH_SOURCE[0]}")")/common.sh"

is_force=false
for arg in "$@"; do
  case $arg in
    -f)
      is_force=true
      ;;
  esac
done

# Install modules
title1 "Install modules"

for module in *; do
  if [ -f "$module" ]; then
    continue
  fi

  if [ ! -f "$module/install.sh" ]; then
    continue
  fi

  title2 "Install $module"

  if [[ $is_force = true ]]; then
    "$module/install.sh" -f
  else
    "$module/install.sh"
  fi

  echo ""
done
