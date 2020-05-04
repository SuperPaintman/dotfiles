#!/usr/bin/env zsh

# Git prompt info settings.
ZSH_THEME_GIT_PROMPT_PREFIX=" on %{$fg[magenta]%}\uE0A0 "
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[red]%}!"
ZSH_THEME_GIT_PROMPT_UNTRACKED="%{$fg[green]%}?"
ZSH_THEME_GIT_PROMPT_CLEAN=""

# User specific variables.
_theme_user_color="green"
if [ "$UID" = 0 ]; then
    _theme_user_color="red"
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
local _theme_username="%{$fg[cyan]%}%n%{$reset_color%}"
local _theme_hostname="@%{$fg_bold[cyan]%}%m%{$reset_color%}"
local _theme_ret_status="%(?::[%{$fg_bold[red]%}%?%{$reset_color%}] )%(?:%{$fg[$_theme_user_color]%}:%{$fg[red]%})$_theme_user_caret%{$reset_color%}"

# Left prompt.
_theme_prompt_left() {
    local theme_pwd="%{$fg[red]%}$(_theme_fish_pwd)%{$reset_color%}"

    if [ "$COLUMNS" -ge 80 ]; then
        echo "$_theme_username$_theme_hostname $theme_pwd $_theme_ret_status "
    elif [ "$COLUMNS" -ge 60 ]; then
        echo "$_theme_hostname $theme_pwd $_theme_ret_status "
    elif [ "$COLUMNS" -ge 30 ]; then
        echo "$_theme_hostname $_theme_ret_status "
    else
        echo "$_theme_ret_status "
    fi
}

PROMPT='$(_theme_prompt_left)'

# Right prompt.
_theme_prompt_right() {
    if [ "$COLUMNS" -ge 80 ]; then
        git_prompt_info
    fi
}

RPROMPT='$(_theme_prompt_right)'
