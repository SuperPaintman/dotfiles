#!/usr/bin/env bash

COLOR_RESET="\033[0m"
COLOR_GREEN="\033[0;32m"
COLOR_RED="\033[31;01m"
COLOR_YELLOW="\033[33;01m"
COLOR_BLUE="\033[0;34m"
COLOR_GRAY="\033[90m"

YES="yes"
NO=""

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

info() {
    echo "$(yellow "[info]")" $@
}

error() {
    echo "$(red "[error]")" $@
}

point() {
    echo "$(gray " * ")" $@
}

is_osx() {
    case "$(uname)" in
        Darwin*)
            return 0
            ;;
    esac

    return 1
}

is_linux() {
    case "$(uname)" in
        Linux)
            return 0
            ;;
    esac

    return 1
}

is_x86_64() {
    case "$(uname -m)" in
        x86_64)
            return 0
            ;;
    esac

    return 1
}

is_ubuntu() {
    if [ -f "/etc/os-release" ]; then
        case "$(eval "$(cat /etc/os-release) echo \$NAME")" in
            Ubuntu)
                return 0
                ;;
        esac
    fi

    return 1
}

_dry() {
    local is_it="$1"

    shift 1

    if [ "$is_it" == "" ]; then
        exec $@
    else
        echo " $(gray '$')" $@
    fi
}

_link() {
    local is_force="$NO"
    local is_dry="$NO"
    local is_optional="$NO"

    for arg in "$@"; do
        case "$arg" in
            -f | --force)
                is_force="$YES"
                ;;
            --dry | --dry-run | --check)
                is_dry="$YES"
                ;;
            --optional)
                is_optional="$YES"
                ;;
            -*)
                error "Unknown argument $(blue "$arg")"
                return 1
                ;;
            *)
                continue
                ;;
        esac

        shift 1
    done

    local source="$1"
    local target="$2"

    if [ ! -e "$source" ]; then
        if [ "$is_optional" == "$YES" ]; then
            info "$(blue "$target") is optional and does not exist (skipped)"
            return 0
        else
            error "$(blue "$target") is not optional and does not exist ($(gray "$source"))"
            return 1
        fi
    fi

    if [[ -e $target ]]; then
        if [[ $is_force == "$YES" ]]; then
            _dry "$is_dry" rm -fr "$target"
        else
            error "$(blue "$target") already exists ($(gray "$target"))"
            return 1
        fi
    fi

    _dry "$is_dry" ln -s "$source" "$target"

    ok "$(blue "$target") has linked ($(gray "$source") => $(gray "$target"))"
}

_linkall() {
    local args=""

    for arg in "$@"; do
        case "$arg" in
            -*)
                args="$args $arg"
                shift 1
                ;;
        esac
    done

    local source_root="$1"
    local target_root="$2"
    local targets=${@:4}

    local return_code=0

    for f in $targets; do
        local source="$source_root/$f"
        local target="$target_root/$f"

        _link $args "$source" "$target" "$is_force" || { return_code="$?"; }
    done

    return "$return_code"
}

link() {
    _link $@
}

linkoptional() {
    _link --optional $@
}

linkall() {
    _linkall $@
}

linkalloptional() {
    _linkall --optional $@
}
