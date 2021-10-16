#!/usr/bin/env bash

set -e
set -u
set -o pipefail

ROOT="$(dirname "$(realpath "${BASH_SOURCE[0]}")")"

rm -rf "${ROOT}/tmp"
mkdir -p "${ROOT}/tmp"

(cd "${ROOT}/scripts" && zip -r "${ROOT}/tmp/greasemonkey.zip" .)
