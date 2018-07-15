#!/bin/bash

EXTENSIONS_FILE="$(dirname "$(realpath "${BASH_SOURCE[0]}")")/list-extensions.txt"

code --list-extensions --show-versions | sort > "$EXTENSIONS_FILE"
