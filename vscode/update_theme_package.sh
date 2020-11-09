#!/usr/bin/env nix-shell
#!nix-shell -i bash -p curl nodePackages.node2nix

SOURCE_ROOT="$(dirname "$(realpath "${BASH_SOURCE[0]}")")"

owner="SuperPaintman"
repo="vscode-monokai-extended"
rev="af883a8e1094fe6363148648d8f3ed9db32b9bcc"

build_dir="$SOURCE_ROOT/package"

rm -rf "$build_dir"
mkdir -p "$build_dir"
curl -s "https://raw.githubusercontent.com/${owner}/${repo}/${rev}/package.json" -o "$build_dir/package.json"

node2nix \
    --development \
    --input "$build_dir/package.json" \
    --output "$build_dir/node-packages.nix" \
    --composition "$build_dir/composition.nix" \
    --node-env "$build_dir/node-env.nix"
