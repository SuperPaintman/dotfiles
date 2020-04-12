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

    cat <<EOF >> "$MODULES_FILE.new"
{
  "path": "$path",
  "remote": "$(cd $path && git remote get-url origin)",
  "rev": "$(cd $path && git rev-parse HEAD)"
}
EOF

    rm -rf "$path/.git"
done

cat "$MODULES_FILE.new" | jq -n '[inputs]' | tee "$MODULES_FILE.new"

mv "$MODULES_FILE" "$MODULES_FILE.bak"
mv "$MODULES_FILE.new" "$MODULES_FILE"
