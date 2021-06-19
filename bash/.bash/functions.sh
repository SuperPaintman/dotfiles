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

:q() {
    exit 0
}

afk() {
    systemctl suspend -i
}

# Git.
if can git-get && can git-parse && can git-path; then
    # Git get and CD into a downloaded directory.
    gg() {
        local repository="$1"

        local parts=($(git-parse "$repository"))
        if [ ! "$?" = 0 ]; then
            return "$?"
        fi

        local dir="$(git-path $parts)"

        if [ ! -d "$dir" ]; then
            git-get "$repository"
            if [ ! "$?" = 0 ]; then
                return "$?"
            fi
        fi

        cd "$dir"
    }
fi

# Emacs.
if can emacs && [ ! -z "$EMACSIFY_EDITORS" ]; then
    _emacsify() {
        local name="$1"
        local bin="$2"

        shift
        shift

        local skip=""
        local args=()

        for a in $@; do
            if [ "$a" = "--skip-emacs" ]; then
                skip="yes"
            else
                args+=("$a")
            fi
        done

        if [ -z "$skip" ]; then
            echo "Use emacs instead of $name." 1>&2
            echo "" 1>&2
            echo "To force using $name run it with '--skip-emacs' flag." 1>&2

            emacs $@
        else
            $bin $args
        fi
    }

    if can code; then
        if [ -z "$_EMACS_FORCE_CODE" ]; then
            export _EMACS_FORCE_CODE="$(which code)"
        fi

        code() {
            _emacsify "VS Code" "$_EMACS_FORCE_CODE" $@
        }
    fi

    if can vim; then
        if [ -z "$_EMACS_FORCE_VIM" ]; then
            export _EMACS_FORCE_VIM="$(which vim)"
        fi

        vim() {
            _emacsify "vim" "$_EMACS_FORCE_VIM" $@
        }
    fi

    if can vi; then
        if [ -z "$_EMACS_FORCE_VI" ]; then
            export _EMACS_FORCE_VI="$(which vi)"
        fi

        vi() {
            _emacsify "vi" "$_EMACS_FORCE_VI" $@
        }
    fi
fi

# Tmux.
tmx() {
    local detached_session="$(
        tmux list-sessions -F '#{session_id} #{?session_attached,attached,}' 2> /dev/null |
            grep -v attached |
            head -n1
    )"

    if [ -n "$detached_session" ]; then
        tmux attach-session -t "$detached_session"
    else
        tmux new-session
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
