#!/usr/bin/env bash

COLOR_RESET="\033[0m"
COLOR_GREEN="\033[0;32m"
COLOR_RED="\033[31;01m"
COLOR_YELLOW="\033[33;01m"
COLOR_BLUE="\033[0;34m"
COLOR_GRAY="\033[90m"

green() {
    echo -e "${COLOR_GREEN}$@${COLOR_RESET}"
}

red() {
    echo -e "${COLOR_RED}$@${COLOR_RESET}"
}

yellow() {
    echo -e "${COLOR_YELLOW}$@${COLOR_RESET}"
}

blue() {
    echo -e "${COLOR_BLUE}$@${COLOR_RESET}"
}

gray() {
    echo -e "${COLOR_GRAY}$@${COLOR_RESET}"
}

title1() {
    yellow "=== $1 ==="
}

title2() {
    yellow "--- $1 ---"
}

ok() {
    echo "$(green "[ok]")" $@
}

error() {
    echo "$(red "[error]")" $@
}

is_osx() {
    case "$(uname)" in
        Darwin*)
            return 0
            ;;
    esac

    return 1
}

linkall() {
    local source_root="$1"
    local target_root="$2"
    local is_force="$3"
    local targets=${@:4}

    for target in $targets; do
        ln_target="$target_root/$target"
        ln_source="$source_root/$target"

        if [[ -e "$ln_target" || -L "$ln_target" ]]; then
            if [[ "$is_force" = true ]]; then
                rm -fr "$ln_target"
            else
                error "$(blue "$target") already exists ($(gray "$ln_target"))"
                continue
            fi
        fi

        ln -s "$ln_source" "$ln_target"

        ok "$(blue "$target") has linked ($(gray "$ln_source") => $(gray "$ln_target"))"
    done
}
