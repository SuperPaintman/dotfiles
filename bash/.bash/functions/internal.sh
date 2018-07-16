#!/usr/bin/env bash
_get_funcname() {
    local funcname="$FUNCNAME[1]"; [ "$funcname" = "" ] && funcname="$funcstack[2]"

    echo "$funcname"
}
