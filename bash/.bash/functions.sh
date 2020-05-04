#!/usr/bin/env bash

# Internal.
_get_funcname() {
    local funcname="$FUNCNAME[1]"
    [ "$funcname" = "" ] && funcname="$funcstack[2]"

    echo "$funcname"
}

# Common.
reload() {
    source ~/.bashrc
}

nicediff() {
    git difftool -y -x "diff -W $(tput cols) -y" | colordiff | less
}

lfcd() {
    if ! which lf > /dev/null 2>&1; then
        echo "Please install lf" 1>&2
        return 1
    fi

    tmp="$(mktemp)"
    lf -last-dir-path="$tmp" "$@"
    if [ -f "$tmp" ]; then
        dir="$(cat "$tmp")"
        rm -f "$tmp"
        if [ -d "$dir" ]; then
            if [ "$dir" != "$(pwd)" ]; then
                cd "$dir"
            fi
        fi
    fi
}

# Docker.
drmall() {
    local funcname="$(_get_funcname)"
    local is_force=false

    for arg in "$@"; do
        case $arg in
            -f | --force)
                is_force=true
                ;;
            -h | --help)
                echo -e "Usage: $funcname [-f|--force]"
                echo -e "  -f | --force   - remove all containers force"

                return 0
                ;;
        esac
    done

    if [[ $is_force == true ]]; then
        docker rm -f $(docker ps -qa)
    else
        docker rm $(docker ps -qa)
    fi
}

drmiall() {
    local funcname="$(_get_funcname)"
    local is_force=false

    for arg in "$@"; do
        case $arg in
            -f | --force)
                is_force=true
                ;;
            -h | --help)
                echo -e "Usage: $funcname [-f|--force]"
                echo -e "  -f | --force   - remove all images force"

                return 0
                ;;
        esac
    done

    if [[ $is_force == true ]]; then
        docker rmi -f $(docker ps -qa)
    else
        docker rmi $(docker ps -qa)
    fi
}
