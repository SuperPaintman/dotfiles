#!/usr/bin/env bash
dstats() {
    docker stats $(docker ps | awk '{print $NF}' | grep -v NAMES)
}

drmall() {
    local funcname="$(_get_funcname)"
    local is_force=false

    for arg in "$@"; do
        case $arg in
            -f|--force)
                is_force=true
                ;;
            -h|--help)
                echo -e "Usage: $funcname [-f|--force]"
                echo -e "  -f | --force   - remove all containers force"

                return 0
                ;;
        esac
    done

    if [[ $is_force = true ]]; then
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
            -f|--force)
                is_force=true
                ;;
            -h|--help)
                echo -e "Usage: $funcname [-f|--force]"
                echo -e "  -f | --force   - remove all images force"

                return 0
                ;;
        esac
    done

    if [[ $is_force = true ]]; then
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
