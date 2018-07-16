#!/usr/bin/env bash
gcurcommit() {
    local cur_branch_name=$(git rev-parse --abbrev-ref HEAD)
    local cur_commit=$(git rev-parse HEAD)

    echo "$fg[cyan][${cur_branch_name}]:$reset_color $fg[green]${cur_commit}$reset_color"
}

gdownload() {
    for repo in $argv; do
        git clone --depth=1 "$repo"
    done
}

gtrackall() {
    local funcname="$(_get_funcname)"

    if [[ $# == 0 ]]; then
        local remote_name=origin
    else
        local remote_name="${1%%/*}"
    fi

    for arg in "$@"; do
        case $arg in
            -h|--help)
                echo -e "Usage: $funcname <remote_name>"

                return 0
                ;;
        esac
    done

    for branch in $(git branch -r | grep -v /HEAD | grep -E "^\s*$remote_name\/" | cut -b 3-); do
        git branch --track "${branch#$remote_name/}" "$branch"
    done
}

gpushall() {
    local funcname="$(_get_funcname)"

    if [[ $# != 1 ]]; then
        echo -e "Usage: $funcname <branch>" 1>&2
        return 1
    fi

    local branch="$1"

    for remote in $(git remote); do
        git push $remote $branch
    done
}

# see: https://gist.github.com/varemenos/e95c2e098e657c7688fd
glogjson() {
    local l="$(git log --pretty=format:'{%n  "commit": "%H",%n  "abbreviated_commit": "%h",%n  "tree": "%T",%n  "abbreviated_tree": "%t",%n  "parent": "%P",%n  "abbreviated_parent": "%p",%n  "refs": "%D",%n  "encoding": "%e",%n  "subject": "%s",%n  "sanitized_subject_line": "%f",%n  "body": "%b",%n  "commit_notes": "%N",%n  "verification_flag": "%G?",%n  "signer": "%GS",%n  "signer_key": "%GK",%n  "author": {%n    "name": "%aN",%n    "email": "%aE",%n    "date": "%aD"%n  },%n  "commiter": {%n    "name": "%cN",%n    "email": "%cE",%n    "date": "%cD"%n  }%n},')"
    l="${l:0:-1}"

    echo '['$l']'
}
