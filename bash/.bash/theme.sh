#!/usr/bin/env bash

# Constants.
_theme_color_red="\[\033[01;31m\]"
_theme_color_green="\[\033[01;32m\]"
_theme_color_cyan="\[\033[01;36m\]"
_theme_color_cyan_bold="\[\033[01;36;1m\]"
_theme_color_reset="\[\033[00m\]"

# User specific variables.
_theme_user_color="$_theme_color_green"
if [ "$UID" = 0 ]; then
    _theme_user_color="$_theme_color_red"
fi

_theme_user_caret="$"
if [ "$UID" = 0 ]; then
    _theme_user_caret="#"
fi

# Helpers.
_theme_fish_pwd() {
    echo $(pwd | perl -pe '
    BEGIN {
        binmode STDIN,  ":encoding(UTF-8)";
        binmode STDOUT, ":encoding(UTF-8)";
    }; s|^$ENV{HOME}|~|g; s|/([^/.])[^/]*(?=/)|/$1|g; s|/\.([^/])[^/]*(?=/)|/.$1|g
    ')
}

# Parts.
_theme_username="${_theme_color_cyan}\u${_theme_color_reset}"
_theme_hostname="@${_theme_color_cyan_bold}\h${_theme_color_reset}"
_theme_ret_status="${_theme_user_color}${_theme_user_caret}${_theme_color_reset}"

# Left prompt.
PS1="${_theme_username}${_theme_hostname} ${_theme_pwd} ${_theme_ret_status} "
