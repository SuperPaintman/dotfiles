#!/usr/bin/env bash

#
# $ time bash ./theme_benchmark_test.sh
# $ time zsh ./theme_benchmark_test.sh
#

. ./theme.sh

for ((i = 0; i < 256; i++)); do
    # __dotfiles_theme_fishpwd "$PWD" "$HOME" 2>&1 > /dev/null
    __dotfiles_theme_ps1 2>&1 > /dev/null
done
