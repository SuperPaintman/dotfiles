#!/usr/bin/env bash

is_force=false
for arg in "$@"; do
  case $arg in
    -f)
      is_force=true
      ;;
  esac
done

for module in ./*; do
  if [ -f "$module" ]; then
    continue
  fi

  if [[ $is_force = true ]]; then
    "$module/install.sh" -f
  else
    "$module/install.sh"
  fi
done
