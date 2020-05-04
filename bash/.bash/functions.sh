#!/usr/bin/env bash

# Internal.
_get_funcname() {
    local funcname="$FUNCNAME[1]"
    [ "$funcname" = "" ] && funcname="$funcstack[2]"

    echo "$funcname"
}

# Common.
myip() {
    dig +short myip.opendns.com @resolver1.opendns.com
}

markdown() {
    local funcname="$(_get_funcname)"

    if [[ $# != 1 ]]; then
        echo -e "Usage: $funcname <file_name>" 1>&2
        return 1
    fi

    pandoc -s -f markdown -t man "$1" | man -l -

}

if ! which serve > /dev/null 2>&1; then
    serve() {
        if ! which python > /dev/null 2>&1; then
            echo "Please install python" 1>&2
            return 1
        fi

        if [[ $# -gt 0 ]]; then
            port="$1"
        else
            port=8000
        fi

        python -m SimpleHTTPServer $port
    }
fi

nicediff() {
    git difftool -y -x "diff -W $(tput cols) -y" | colordiff | less
}

sshkey() {
    local file="$HOME/.ssh/id_rsa.pub"

    if [ ! -f "$file" ]; then
        echo "id_rsa file is not exist" 1>&2
        return 1
    fi

    cat "$file"
}

clipsshkey() {
    sshkey | xclip -in -selection clipboard
}

extract() {
    local funcname="$(_get_funcname)"

    if [ -f "$1" ]; then
        case "$1" in
            *.tar.bz2)
                tar -jxvf "$1"
                ;;
            *.tar.gz)
                tar -zxvf "$1"
                ;;
            *.bz2)
                bunzip2 "$1"
                ;;
            *.dmg)
                hdiutil mount "$1"
                ;;
            *.gz)
                gunzip "$1"
                ;;
            *.tar)
                tar -xvf "$1"
                ;;
            *.tbz2)
                tar -jxvf "$1"
                ;;
            *.tgz)
                tar -zxvf "$1"
                ;;
            *.zip)
                unzip "$1"
                ;;
            *.ZIP)
                unzip "$1"
                ;;
            *.pax)
                cat "$1" | pax -r
                ;;
            *.pax.Z)
                uncompress "$1" --stdout | pax -r
                ;;
            *.rar)
                unrar x "$1"
                ;;
            *.Z)
                uncompress "$1"
                ;;
            *)
                echo "'$1' cannot be extracted/mounted via $funcname" 1>&2
                return 1
                ;;
        esac
    else
        echo "'$1' is not a valid file" 1>&2
        return 1
    fi
}

image() {
    if ! which convert > /dev/null 2>&1; then
        echo "Please install imagemagick" 1>&2
        return 1
    fi
    if ! which jp2a > /dev/null 2>&1; then
        echo "Please install jp2a" 1>&2
        return 1
    fi

    local funcname="$(_get_funcname)"

    if [[ $# != 1 ]]; then
        echo -e "Usage: $funcname <file>" 1>&2
        return 1
    fi

    convert "$1" jpg:- | jp2a --color -
}

crun() {
    local filename="$(mktemp)"
    local exitcode="0"

    clang -o "$filename" $@

    "$filename"
    exitcode="$?"

    rm -f "$filename"

    return "$exitcode"
}

mkd() {
    mkdir -p "$@" && cd "$_"
}

reload() {
    source ~/.bashrc
}

readme() {
    for readme in {readme,README}.{md,MD,markdown,txt,TXT,mkd}; do
        if [ -f "$readme" ]; then
            cat "$readme" | less -RFX
            return 0
        fi
    done

    echo "Readme file is not found"
    return 1
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

# Git.
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
            -h | --help)
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

# Docker.
dstats() {
    docker stats $(docker ps | awk '{print $NF}' | grep -v NAMES)
}

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

drestartnlog() {
    local funcname="$(_get_funcname)"

    if [[ $# != 1 ]]; then
        echo -e "Usage: $funcname <container_name>" 1>&2
        return 1
    fi

    docker restart "$1" && docker logs -f --tail=1 "$1"
}

# Tmux.
_tmpreset1() {
    tmux split-window -v -p 33 &&
        tmux split-window -v -p 50
}

tmpreset() {
    local preset="${1:-1}"

    case $preset in
        "1")
            _tmpreset1
            ;;
        *)
            echo -e "Unknown preset: $preset" 1>&2
            return 1
            ;;
    esac
}
