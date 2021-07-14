#!/usr/bin/env bash

# This file is generated; DO NOT EDIT.

set -e
set -u
set -o pipefail

# Helpers.
get_extension_dir() {
    local publisher="$1"
    local name="$2"

    echo "$HOME/.vscode/extensions/${publisher}.${name}"
}

has_extension() {
    local publisher="$1"
    local name="$2"

    local ext_dir="$(get_extension_dir "$publisher" "$name")"

    if [ ! -d "$ext_dir" ]; then
        return 1
    fi

    return 0
}

download_extension() {
    local publisher="$1"
    local name="$2"
    local version="$3"

    local ext_dir="$(get_extension_dir "$publisher" "$name")"
    local ext_url="https://${publisher}.gallery.vsassets.io/_apis/public/gallery/publisher/${publisher}/extension/${name}/${version}/assetbyname/Microsoft.VisualStudio.Services.VSIXPackage"
    local tmp_ext_zip="$(mktemp -t --dry-run "${publisher}.${name}.XXXXXXXX.zip")"
    local tmp_ext_dir="$(mktemp -t --dry-run "${publisher}.${name}.XXXXXXXX")"

    trap "rm -f $tmp_ext_zip" EXIT
    trap "rm -rf $tmp_ext_dir" EXIT

    curl "$ext_url" -o "$tmp_ext_zip"
    unzip "$tmp_ext_zip" -d "$tmp_ext_dir"

    rm -rf "$ext_dir"
    mv "${tmp_ext_dir}/extension" "$ext_dir"
}

extension() {
    local publisher="$1"
    local name="$2"
    local version="$3"

    if ! has_extension "${publisher}" "${name}"; then
        download_extension "${publisher}" "${name}" "${version}"
    fi
}

mkdir -p "$HOME/.vscode/extensions"

# cpptools (ms-vscode)
extension "ms-vscode" "cpptools" "0.26.3"

# clang-format (xaver)
extension "xaver" "clang-format" "1.9.0"

# cmake (twxs)
extension "twxs" "cmake" "0.0.17"

# dart-code (Dart-Code)
extension "Dart-Code" "dart-code" "3.11.0"

# elm-ls-vscode (Elmtooling)
extension "Elmtooling" "elm-ls-vscode" "1.5.2"

# flutter (Dart-Code)
extension "Dart-Code" "flutter" "3.12.2"

# Go (golang)
extension "golang" "Go" "0.14.1"

# language-haskell (justusadam)
extension "justusadam" "language-haskell" "3.3.0"

# vscode-ghc-simple (dramforever)
extension "dramforever" "vscode-ghc-simple" "0.1.22"

# brittany (MaxGabriel)
extension "MaxGabriel" "brittany" "0.0.9"

# lua (sumneko)
extension "sumneko" "lua" "0.17.0"

# nix-ide (jnoortheen)
extension "jnoortheen" "nix-ide" "0.1.12"

# python (ms-python)
extension "ms-python" "python" "2020.9.114305"

# rust-analyzer (matklad)
extension "matklad" "rust-analyzer" "0.2.583"

# stylus (alan)
extension "alan" "stylus" "0.0.4"

# vimL (fallenwood)
extension "fallenwood" "vimL" "0.0.3"

# monokai-extended (SuperPaintman)
extension "SuperPaintman" "monokai-extended" "0.5.1"

# even-better-toml (tamasfe)
extension "tamasfe" "even-better-toml" "0.12.1"

# terraform (HashiCorp)
extension "HashiCorp" "terraform" "2.10.2"

# docthis (oouo-diogo-perdigao)
extension "oouo-diogo-perdigao" "docthis" "0.8.2"

# llvm (RReverser)
extension "RReverser" "llvm" "0.0.3"

# prettier-vscode (esbenp)
extension "esbenp" "prettier-vscode" "4.5.0"

# quokka-vscode (WallabyJs)
extension "WallabyJs" "quokka-vscode" "1.0.291"

# vscode-arduino (vsciot-vscode)
extension "vsciot-vscode" "vscode-arduino" "0.2.29"

# gitignore (codezombiech)
extension "codezombiech" "gitignore" "0.6.0"

# rest-client (humao)
extension "humao" "rest-client" "0.24.3"

# partial-diff (ryu1kn)
extension "ryu1kn" "partial-diff" "1.4.1"

# jinjahtml (samuelcolvin)
extension "samuelcolvin" "jinjahtml" "0.15.0"
