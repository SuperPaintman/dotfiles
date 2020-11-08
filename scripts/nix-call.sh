#!/usr/bin/env bash

set -e
set -u
set -o pipefail

COMMAND="${1:-}"
PACKAGE="${2:-}"
ARGS="${@:3}"

if which nix-shell > /dev/null 2>&1; then
    input="$(mktemp)"
    trap "rm -f $input" EXIT

    cat << EOF > "$input"
#!/usr/bin/env nix-shell
#!nix-shell -i bash -p pkgs.${PACKAGE}

$COMMAND $ARGS
EOF

    nix-shell "$input"
    exit "$?"
fi

if which "$COMMAND" > /dev/null 2>&1; then
    eval "$COMMAND $ARGS"
    exit "$?"
fi

echo "$COMMAND not found" 1>&2
exit 1
