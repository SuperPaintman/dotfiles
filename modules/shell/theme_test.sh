#!/usr/bin/env bash

. ./theme.sh

test_dotfiles_theme_fishpwd() {
    local code=0

    local tests
    declare -ar tests=(
        "/" "/home/user" "/"
        "/tmp/mydir" "/home/user" "/t/mydir"
        "/home/user" "/home/user" "~"
        "/home/user/" "/home/user" "~"
        "/home/user/Projects/github.com/myuser/project" "/home/user" "~/P/g/m/project"
        "/a/b/c/d/e" "/home/user" "/a/b/c/d/e"
        "/a/b/c/d/e/" "/home/user" "/a/b/c/d/e"
        "" "" "/"
        "" "/home/user" "/"
        "/" "" "/"
    )

    local pwd home want got
    for (( i = 0; i < ${#tests[@]}; i+=3 )); do
        pwd="${tests[i + 0]}"
        home="${tests[i + 1]}"
        want="${tests[i + 2]}"

        __dotfiles_theme_fishpwd "$pwd" "$home" || code=1
        got="$__DOTFILES_THEME_FISHPWD_RES"
        if [[ "$got" != "$want" ]]; then
            echo "FAILED: __dotfiles_theme_fishpwd \"$pwd\" \"$home\" = \"$got\", want \"$want\"" >&2
            code=1
        else
            echo "OK:     __dotfiles_theme_fishpwd \"$pwd\" \"$home\" = \"$got\"" >&2
        fi
    done

    return "$code"
}

CODE=0
test_dotfiles_theme_fishpwd || CODE=1

if [ "$CODE" -ne 0 ]; then
    echo "SOME TESTS FAILED" >&2
else
    echo "ALL TESTS PASSED" >&2
fi
exit "$CODE"
