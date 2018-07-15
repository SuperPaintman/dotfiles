#!/usr/bin/env bash

if ! which realpath > /dev/null; then
  # OSX dirty replacement for `realpath`
  realpath() {
    [[ $1 = /* ]] && echo "$1" || echo "$PWD/${1#./}"
  }
fi

is_force=false
for arg in "$@"; do
  case $arg in
    -f)
      is_force=true
      ;;
  esac
done

for target in ".sbt"; do
  ln_target="$HOME/$target"
  ln_source="$(dirname "$(realpath "${BASH_SOURCE[0]}")")/$target"

  if [[ -e "$ln_target" || -L "$ln_target" ]]; then
    if [[ $is_force = true ]]; then
      rm -fr "$ln_target"
    else
      echo "$target already exist"
      exit 1
    fi
  fi

  ln -s "$ln_source" "$ln_target"
done
