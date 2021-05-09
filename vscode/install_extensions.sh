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

get_extension() {
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

mkdir -p "$HOME/.vscode/extensions"

# cpptools (ms-vscode)
if ! has_extension "ms-vscode" "cpptools"; then
    get_extension "ms-vscode" "cpptools" "0.26.3"
fi

# clang-format (xaver)
if ! has_extension "xaver" "clang-format"; then
    get_extension "xaver" "clang-format" "1.9.0"
fi

# cmake (twxs)
if ! has_extension "twxs" "cmake"; then
    get_extension "twxs" "cmake" "0.0.17"
fi

# dart-code (Dart-Code)
if ! has_extension "Dart-Code" "dart-code"; then
    get_extension "Dart-Code" "dart-code" "3.11.0"
fi

# elm-ls-vscode (Elmtooling)
if ! has_extension "Elmtooling" "elm-ls-vscode"; then
    get_extension "Elmtooling" "elm-ls-vscode" "1.5.2"
fi

# flutter (Dart-Code)
if ! has_extension "Dart-Code" "flutter"; then
    get_extension "Dart-Code" "flutter" "3.12.2"
fi

# Go (golang)
if ! has_extension "golang" "Go"; then
    get_extension "golang" "Go" "0.14.1"
fi

# language-haskell (justusadam)
if ! has_extension "justusadam" "language-haskell"; then
    get_extension "justusadam" "language-haskell" "3.3.0"
fi

# vscode-ghc-simple (dramforever)
if ! has_extension "dramforever" "vscode-ghc-simple"; then
    get_extension "dramforever" "vscode-ghc-simple" "0.1.22"
fi

# brittany (MaxGabriel)
if ! has_extension "MaxGabriel" "brittany"; then
    get_extension "MaxGabriel" "brittany" "0.0.9"
fi

# lua (sumneko)
if ! has_extension "sumneko" "lua"; then
    get_extension "sumneko" "lua" "0.17.0"
fi

# Nix (bbenoist)
if ! has_extension "bbenoist" "Nix"; then
    get_extension "bbenoist" "Nix" "1.0.1"
fi

# python (ms-python)
if ! has_extension "ms-python" "python"; then
    get_extension "ms-python" "python" "2020.9.114305"
fi

# rust-analyzer (matklad)
if ! has_extension "matklad" "rust-analyzer"; then
    get_extension "matklad" "rust-analyzer" "0.2.583"
fi

# stylus (alan)
if ! has_extension "alan" "stylus"; then
    get_extension "alan" "stylus" "0.0.4"
fi

# vimL (fallenwood)
if ! has_extension "fallenwood" "vimL"; then
    get_extension "fallenwood" "vimL" "0.0.3"
fi

# monokai-extended (SuperPaintman)
if ! has_extension "SuperPaintman" "monokai-extended"; then
    get_extension "SuperPaintman" "monokai-extended" "0.5.1"
fi

# even-better-toml (tamasfe)
if ! has_extension "tamasfe" "even-better-toml"; then
    get_extension "tamasfe" "even-better-toml" "0.12.1"
fi

# terraform (HashiCorp)
if ! has_extension "HashiCorp" "terraform"; then
    get_extension "HashiCorp" "terraform" "2.10.2"
fi

# docthis (oouo-diogo-perdigao)
if ! has_extension "oouo-diogo-perdigao" "docthis"; then
    get_extension "oouo-diogo-perdigao" "docthis" "0.8.2"
fi

# llvm (RReverser)
if ! has_extension "RReverser" "llvm"; then
    get_extension "RReverser" "llvm" "0.0.3"
fi

# prettier-vscode (esbenp)
if ! has_extension "esbenp" "prettier-vscode"; then
    get_extension "esbenp" "prettier-vscode" "4.5.0"
fi

# quokka-vscode (WallabyJs)
if ! has_extension "WallabyJs" "quokka-vscode"; then
    get_extension "WallabyJs" "quokka-vscode" "1.0.291"
fi

# vscode-arduino (vsciot-vscode)
if ! has_extension "vsciot-vscode" "vscode-arduino"; then
    get_extension "vsciot-vscode" "vscode-arduino" "0.2.29"
fi

# gitignore (codezombiech)
if ! has_extension "codezombiech" "gitignore"; then
    get_extension "codezombiech" "gitignore" "0.6.0"
fi

# rest-client (humao)
if ! has_extension "humao" "rest-client"; then
    get_extension "humao" "rest-client" "0.24.3"
fi

# partial-diff (ryu1kn)
if ! has_extension "ryu1kn" "partial-diff"; then
    get_extension "ryu1kn" "partial-diff" "1.4.1"
fi

# jinjahtml (samuelcolvin)
if ! has_extension "samuelcolvin" "jinjahtml"; then
    get_extension "samuelcolvin" "jinjahtml" "0.15.0"
fi
