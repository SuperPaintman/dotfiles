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
declare -g __DOTFILES_THEME_HOST="${HOST:-"$(hostname)"}"
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
    local rest="$1"
    if [[ "$pwd" = "$home"* ]]; then
        rest="${pwd:${#home}}"
        res='~'
    fi
    rest="${rest#/}"
    rest="${rest%/}"

    if [[ "$rest" == '' ]]; then
        res='/'
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

declare -g __DOTFILES_THEME_PS1_RES
__dotfiles_theme_ps1() {
    __dotfiles_theme_fishpwd "${PWD:-/}" "${HOME:-/home/nobody}" \
        || __DOTFILES_THEME_FISHPWD_RES="error($?)"
    __DOTFILES_THEME_PS1_RES="\
${__DOTFILES_THEME_CUSER}${__DOTFILES_THEME_USER}${__DOTFILES_THEME_CR}\
@\
${__DOTFILES_THEME_CHOST}${__DOTFILES_THEME_HOST}${__DOTFILES_THEME_CR}\
 \
${__DOTFILES_THEME_CPWD}${__DOTFILES_THEME_FISHPWD_RES}${__DOTFILES_THEME_CR}\
 \
${__DOTFILES_THEME_CCARET}${__DOTFILES_THEME_CARET}${__DOTFILES_THEME_CR}\
 \
"
}

