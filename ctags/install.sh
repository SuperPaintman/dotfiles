#!/bin/bash

is_force=false
for arg in "$@"; do
  case $arg in
    -f)
      is_force=true
      ;;
  esac
done

for target in ".ctags"; do
  ln_target="$HOME/$target"
  ln_source="$(dirname "$(realpath "${BASH_SOURCE[0]}")")/$target"

  if [[ -e "$ln_target" ]]; then
    if [[ $is_force = true ]]; then
      rm -fr "$ln_target"
    else
      echo "$target already exist"
      exit 1
    fi
  fi

  ln -s "$ln_source" "$ln_target"
done
