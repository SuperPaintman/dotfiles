#!/usr/bin/env bash

set -e

if ! which realpath > /dev/null 2>&1; then
    # OSX dirty replacement for `realpath`
    realpath() {
        [[ $1 == /* ]] && echo "$1" || echo "$PWD/${1#./}"
    }
fi

source "$(dirname "$(realpath "${BASH_SOURCE[0]}")")/common.sh"

is_force=false
for arg in "$@"; do
    case $arg in
        -f)
            is_force=true
            ;;
    esac
done

if is_osx; then
    # Install brew
    if ! which brew > /dev/null 2>&1; then
        title1 "Install brew"

        ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

        echo ""
    fi

    # Install brew formulas
    if which brew > /dev/null 2>&1; then
        title1 "Install brew formulas"

        for formula in \
            "coreutils" \
            "zsh" \
            "tmux" \
            "htop" \
            "tree" \
            "wget" \
            "jq" \
            "cmake" \
            "llvm" \
            "node" \
            "imagemagick" \
            "bat" \
            "go" \
            "dep" \
            "ansible" \
            "fd" \
            "lf" \
            "exa"; do
            if ! brew ls --versions "$formula" > /dev/null 2>&1; then
                brew install "$formula"

                ok "$(blue "$formula") has installed ($(gray "$(brew ls --versions "$formula")"))"
            else
                ok "$(blue "$formula") is already installed ($(gray "$(brew ls --versions "$formula")"))"
            fi
        done

        echo ""
    fi

    # Install brew casks
    if which brew > /dev/null 2>&1; then
        title1 "Install brew casks"

        for cask in \
            "iterm2" \
            "docker" \
            "alfred" \
            "zaplin" \
            "alacritty"; do
            if ! brew cask ls --versions "$cask" > /dev/null 2>&1; then
                brew cask install "$cask"

                ok "$(blue "$cask") has installed ($(gray "$(brew cask ls --versions "$cask")"))"
            else
                ok "$(blue "$cask") is already installed ($(gray "$(brew cask ls --versions "$cask")"))"
            fi
        done

        echo ""
    fi
fi

if is_linux; then
    # Retrieve new lists of packages
    if is_ubuntu; then
        title1 "Retrieve new lists of packages"

        apt-get update

        echo ""
    fi

    # Install packages
    if is_ubuntu; then
        title1 "Install packages"

        for package in "jq"; do
            # if ! brew ls --versions "$formula" > /dev/null 2>&1; then
            if ! dpkg -l "$package" 2>&1 > /dev/null 2>&1; then
                apt-get install -y jq

                ok "$(blue "$package") has installed"
            else
                ok "$(blue "$package") is already installed"
            fi
        done

        echo ""
    fi

    # Install 1Password CLI
    # See: https://1password.com/downloads/command-line/
    title1 "Install 1Password CLI"

    tmpdir="$(mktemp -d)"
    if is_x86_64; then
        curl -Ls "https://cache.agilebits.com/dist/1P/op/pkg/v0.9.2/op_linux_amd64_v0.9.2.zip" -o "$tmpdir/op.zip"

        unzip -o "$tmpdir/op.zip" -d "$tmpdir/op"

        cp "$tmpdir/op/op" /usr/local/bin/op

        ok "$(blue "op") has installed"
    else
        error "Installing 1Password CLI for $(blue "$(uname -m)") is not implemented"
    fi
    rm -rf "$tmpdir"

    echo ""

    # Install Terraform
    # See: https://www.terraform.io/downloads.html
    title1 "Install Terraform"

    tmpdir="$(mktemp -d)"
    if is_x86_64; then
        curl -Ls "https://releases.hashicorp.com/terraform/0.12.24/terraform_0.12.24_linux_amd64.zip" -o "$tmpdir/terraform.zip"

        unzip -o "$tmpdir/terraform.zip" -d "$tmpdir/terraform"

        cp "$tmpdir/terraform/terraform" /usr/local/bin/terraform

        ok "$(blue "terraform") has installed"
    else
        error "Installing Terraform for $(blue "$(uname -m)") is not implemented"
    fi
    rm -rf "$tmpdir"

    echo ""
fi

# Install NPM packages
title1 "Install NPM packages"

for package in "node-gyp" "node-static" "uuid" "prettier" "ramda-cli"; do
    if ! npm list "$package" -g --depth 0 > /dev/null 2>&1 || [[ "$(npm list "$package" -g --depth 0 --json | jq ".dependencies.\"${package}\".version" -r > /dev/null)" -ne "null" ]]; then
        npm install -g "$package"

        ok "$(blue "$package") has installed ($(gray "$(npm list "$package" -g --depth 0 --json | jq ".dependencies.\"${package}\".version" -r)"))"
    else
        ok "$(blue "$package") is already installed ($(gray "$(npm list "$package" -g --depth 0 --json | jq ".dependencies.\"${package}\".version" -r)"))"
    fi
done

echo ""

# Install modules
title1 "Install modules"

for module in *; do
    if [ -f "$module" ]; then
        continue
    fi

    if [ ! -f "$module/install.sh" ]; then
        continue
    fi

    title2 "Install $module"

    if [[ $is_force == true ]]; then
        "$module/install.sh" -f
    else
        "$module/install.sh"
    fi

    echo ""
done
