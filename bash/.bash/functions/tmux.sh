#!/usr/bin/env bash
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
