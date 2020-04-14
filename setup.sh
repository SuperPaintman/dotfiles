#!/usr/bin/env bash

source "$(dirname "$(realpath "${BASH_SOURCE[0]}")")/common.sh"

# Setup default shell
title1 "Setup default shell"

if which zsh > /dev/null 2>&1; then
    chsh -s "$(which zsh)" "$USER"

    ok "Set $(blue ZSH) as default shell"
else
    error "$(blue ZSH) is not installed"
fi

echo ""

# Setup modules
title1 "Setup modules"

for module in *; do
    if [ -f "$module" ]; then
        continue
    fi

    if [ ! -f "$module/setup.sh" ]; then
        continue
    fi

    title2 "Setup $module"

    "$module/setup.sh"

    echo ""
done
