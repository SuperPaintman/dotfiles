#!/usr/bin/env bash

if ! which realpath > /dev/null; then
  # OSX dirty replacement for `realpath`
  realpath() {
    [[ $1 = /* ]] && echo "$1" || echo "$PWD/${1#./}"
  }
fi

TARGET="$HOME/.config/Code/User"

is_force=false
for arg in "$@"; do
  case $arg in
    -f)
      is_force=true
      ;;
  esac
done


mkdir -p "$TARGET"

for target in "settings.json" "snippets"; do
  ln_target="$TARGET/$target"
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
