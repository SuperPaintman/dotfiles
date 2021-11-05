#!/usr/bin/env sh

set -e
set -u
set -o pipefail

ROOT="$(dirname "$(realpath "${BASH_SOURCE[0]}")")"
EXIT_CODE=0

# Constants.
RESET=""
RED=""
GREEN=""
BLUE=""

# Check if stdout is a terminal.
if [ -t 1 ]; then
    RESET="$(printf "\033[0m")"
    RED="$(printf "\033[31;01m")"
    GREEN="$(printf "\033[0;32m")"
    BLUE="$(printf "\033[0;34m")"
fi

TESTS="$(
    cd "$ROOT" && nix eval \
        --raw $(nix --version | grep -E '2\.3\.' > /dev/null || echo "--impure --expr") \
        '(
    with import <nixpkgs> {};
    with lib;
    let
        tests = callPackage ./. {};
    in
        pipe tests [
            attrNames
            (filter (n: ! elem n [ "override" "overrideDerivation" ]))
            (concatStringsSep " ")
        ]
)'
)"

run_tests() {
    local name results failed

    name="$1"

    echo "=== ${BLUE}RUN${RESET}:  $name"

    results="$(cd "$ROOT" && nix-instantiate \
        --eval \
        --strict \
        -E 'with import <nixpkgs> { }; callPackage ./. { }' \
        -A "$name")"

    failed="$(cd "$ROOT" && nix eval $(nix --version | grep -E '2\.3\.' > /dev/null || echo "--impure --expr") "(builtins.length $results)")"
    if [ "$failed" = "0" ]; then
        echo "--- ${GREEN}PASS${RESET}: $name"
        return 0
    fi

    (cd "$ROOT" && nix eval --raw $(nix --version | grep -E '2\.3\.' > /dev/null || echo "--impure --expr") '(
        with import <nixpkgs> {};
        with builtins;
        with lib;

        let
            filename = '"\"$name\""';
            results = '"$results"';
        in
            lib.concatMapStringsSep "\n"
                ({ name, result, expected }: "--- '"$RED"'FAIL'"$RESET"': ${filename}: ${name}: expected ${toJSON expected} but got ${toJSON result}")
                results
                + "\n"
    )')

    return 1
}

for t in $TESTS; do
    run_tests "$t" || { EXIT_CODE="$?"; }
done

exit "$EXIT_CODE"
