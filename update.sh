#!/usr/bin/env bash

set -e

MODULES_FILE="./.modules.json"

modules="$(cat "$MODULES_FILE" | jq -c '.[]')"

for m in $modules; do
    path="$(echo "$m" | jq -r '.path')"
    remote="$(echo "$m" | jq -r '.remote')"
    rev="$(echo "$m" | jq -r '.rev')"

    rm -rf "$path"
    git clone "$remote" "$path"
    (cd "$path" && git checkout "$rev")
    rm -rf "$path/.git"
done
