#
# Make sure the function doesn't have any external dependancies:
#
#     $ strace -f -qq -e trace=%process bash ./theme.sh
#
#

if [ -n "$ZSH_VERSION" ]; then
    declare -g __DOTFILES_THEME_CR='%f%b'
    declare -g __DOTFILES_THEME_CRED='%F{red}'
    declare -g __DOTFILES_THEME_CBRED='%B%F{red}'
    declare -g __DOTFILES_THEME_CGREEN='%F{green}'
    declare -g __DOTFILES_THEME_CBGREEN='%B%F{green}'
    declare -g __DOTFILES_THEME_CYELLOW='%F{yellow}'
    declare -g __DOTFILES_THEME_CBYELLOW='%B%F{yellow}'
    declare -g __DOTFILES_THEME_CBLUE='%F{blue}'
    declare -g __DOTFILES_THEME_CBBLUE='%B%F{blue}'
else
    declare -g __DOTFILES_THEME_CR='\033[00m'
    declare -g __DOTFILES_THEME_CRED='\033[00;31m'
    declare -g __DOTFILES_THEME_CBRED='\033[01;31m'
    declare -g __DOTFILES_THEME_CGREEN='\033[00;32m'
    declare -g __DOTFILES_THEME_CBGREEN='\033[01;32m'
    declare -g __DOTFILES_THEME_CYELLOW='\033[00;33m'
    declare -g __DOTFILES_THEME_CBYELLOW='\033[01;33m'
    declare -g __DOTFILES_THEME_CBLUE='\033[00;34m'
    declare -g __DOTFILES_THEME_CBBLUE='\033[01;34m'
fi

declare -g __DOTFILES_THEME_USER="${USER:-"$(whoami)"}"
declare -g __DOTFILES_THEME_HOST="${HOST:-"${HOSTNAME:-"$(hostname)"}"}"
if [ "${UID:-1000}" = "0" ]; then
    declare -g __DOTFILES_THEME_CCARET="$__DOTFILES_THEME_CRED"
    declare -g __DOTFILES_THEME_CARET='#'
else
    declare -g __DOTFILES_THEME_CCARET="$__DOTFILES_THEME_CGREEN"
    declare -g __DOTFILES_THEME_CARET='$'
fi

declare -g __DOTFILES_THEME_CUSER="$__DOTFILES_THEME_CBGREEN"
declare -g __DOTFILES_THEME_CHOST="$__DOTFILES_THEME_CBGREEN"
declare -g __DOTFILES_THEME_CPWD="$__DOTFILES_THEME_CRED"
declare -g __DOTFILES_THEME_CSTATUS="$__DOTFILES_THEME_CBRED"
declare -g __DOTFILES_THEME_CCARET_FAILED="$__DOTFILES_THEME_CRED"
declare -g __DOTFILES_THEME_CSHLVL="$__DOTFILES_THEME_CBLUE"
declare -g __DOTFILES_THEME_CTIMER="$__DOTFILES_THEME_CBLUE"

# declare -g __DOTFILES_THEME_SSHLVL=""
declare -g __DOTFILES_THEME_SSHLVL=""
declare -g __DOTFILES_THEME_STIMER=""

# bash ./theme_benchmark_test.sh  3.18s user 0.72s system 101% cpu 3.850 total
# zsh  ./theme_benchmark_test.sh  3.19s user 0.75s system 100% cpu 3.936 total
#
# __dotfiles_theme_fishpwd_perl() {
#     echo "$1" | perl -pe '
#         BEGIN {
#             binmode STDIN,  ":encoding(UTF-8)";
#             binmode STDOUT, ":encoding(UTF-8)";
#         }; s|^$ENV{HOME}|~|g; s|/([^/.])[^/]*(?=/)|/$1|g; s|/\.([^/])[^/]*(?=/)|/.$1|g
#     '
# }

#
# bash ./theme_benchmark_test.sh  0.04s user 0.02s system 98% cpu 0.064 total
# zsh  ./theme_benchmark_test.sh  0.04s user 0.03s system 97% cpu 0.072 total
#
declare -g __DOTFILES_THEME_FISHPWD_RES
__dotfiles_theme_fishpwd_native() {
    local pwd="${1:-/}"
    local home="${2:-/home/nobody}"

    local res=''
    local prefix='/'
    local rest="$1"
    if [[ "$pwd" = "$home"* ]]; then
        rest="${pwd:${#home}}"
        res='~'
        prefix='~'
    fi
    rest="${rest#/}"
    rest="${rest%/}"

    if [[ "$rest" == '' ]]; then
        res="$prefix"
    else
        local last=''
        local code=0
        while true; do
            LANG=C IFS='' read -r -d '/' part
            code="$?"

            last="${part:0:-1}" # Cut '\n'
            res+="/${part:0:1}"
            
            if [ "$code" -ne 0 ]; then
                break
            fi
        done <<< "$rest"

        res="${res}${last:1}"
    fi


    # Avoid cloning the process in $().
    #     echo -n "$res"
    __DOTFILES_THEME_FISHPWD_RES="$res"
}

__dotfiles_theme_fishpwd() {
    __dotfiles_theme_fishpwd_native "$1" "$2"
    # __dotfiles_theme_fishpwd_perl "$1" "$2"
}


__dotfiles_theme_now_ms() { 
    local -i ms
    (( ms = EPOCHREALTIME * 1000 ))
    __DOTFILES_THEME_NOW_MS_RES="$ms"
}

declare -g __DOTFILES_THEME_FMT_MS_RES=''
__dotfiles_theme_fmt_ms() {
    local ms="$1"

    if (( ms < 1000 )); then
        __DOTFILES_THEME_FMT_MS_RES="${ms}ms"
    elif (( ms < 60000 )); then
        __DOTFILES_THEME_FMT_MS_RES="$(( ms / 1000 )).$(( ms % 1000 / 100 ))s"
    elif (( ms < 3600000 )); then
        __DOTFILES_THEME_FMT_MS_RES="$(( ms / 60000 ))m$(( ms % 60000 / 1000 ))s"
    else
        __DOTFILES_THEME_FMT_MS_RES="$(( ms / 3600000 ))h$(( ms % 3600000 / 60000 ))m"
    fi
}

if [ -n "$ZSH_VERSION" ]; then
    declare -g __DOTFILES_THEME_PREEXEC_RES=0
else
    declare -g __DOTFILES_THEME_PREEXEC_RES=
fi
__dotfiles_theme_preexec() {
    # Don't measure some commands.
    local cmd="$2"
    cmd="${cmd##*/}"
    cmd="${cmd%%' '*}"

    case "$cmd" in
    clear|pwd|reset|ls|exa|eza|man)
        return 0 ;;
    esac

    __dotfiles_theme_now_ms
    __DOTFILES_THEME_PREEXEC_RES="$__DOTFILES_THEME_NOW_MS_RES"
}

declare -g __DOTFILES_THEME_PREEXEC_LAST_DRAWN=0
declare -g __DOTFILES_THEME_PS1_RES
__dotfiles_theme_ps1() {
    local ret="${1:-0}"

    # __dotfiles_theme_fishpwd "${PWD:-/}" "${HOME:-/home/nobody}" \
    #     || __DOTFILES_THEME_FISHPWD_RES="error($?)"

    local theme_ccaret="$__DOTFILES_THEME_CCARET"
    local theme_ret=''
    if [ "$ret" -ne 0 ]; then
        theme_ccaret="$__DOTFILES_THEME_CCARET_FAILED"
        theme_ret=" [${__DOTFILES_THEME_CSTATUS}${ret}${__DOTFILES_THEME_CR}]"
    fi

    local theme_shell_depth="${SHLVL:-1}"
    theme_shell_depth="$((theme_shell_depth - 1))"
    if [ -n "$TMUX" ] ; then
        theme_shell_depth="${SHLVL:-2}"
        theme_shell_depth="$((theme_shell_depth - 2))"
    fi

    local theme_timer=''
    if [ -n "$__DOTFILES_THEME_PREEXEC_RES" ] && [[ "$__DOTFILES_THEME_PREEXEC_RES" != "$__DOTFILES_THEME_PREEXEC_LAST_DRAWN" ]]; then
        __DOTFILES_THEME_PREEXEC_LAST_DRAWN="$__DOTFILES_THEME_PREEXEC_RES"

        __dotfiles_theme_now_ms
        local elapsed=$(( __DOTFILES_THEME_NOW_MS_RES - __DOTFILES_THEME_PREEXEC_RES ))
        if (( elapsed >= 0 )); then
            __dotfiles_theme_fmt_ms "$elapsed"
            theme_timer=" ${__DOTFILES_THEME_STIMER} ${__DOTFILES_THEME_CTIMER}${__DOTFILES_THEME_FMT_MS_RES}${__DOTFILES_THEME_CR}"
        fi
    fi

    local theme_shell_deep=''
    for (( i = 0; i < theme_shell_depth; i++ )); do
        theme_shell_deep+=" ${__DOTFILES_THEME_CSHLVL}${__DOTFILES_THEME_SSHLVL}${__DOTFILES_THEME_CR}"
    done

    __DOTFILES_THEME_PS1_RES="\
${__DOTFILES_THEME_CUSER}${__DOTFILES_THEME_USER}${__DOTFILES_THEME_CR}\
@\
${__DOTFILES_THEME_CHOST}${__DOTFILES_THEME_HOST}${__DOTFILES_THEME_CR}\
 \
${__DOTFILES_THEME_CPWD}${__DOTFILES_THEME_FISHPWD_RES}${__DOTFILES_THEME_CR}\
$theme_shell_deep\
$theme_ret\
$theme_timer\
 \
${theme_ccaret}${__DOTFILES_THEME_CARET}${__DOTFILES_THEME_CR}\
 \
"
}

