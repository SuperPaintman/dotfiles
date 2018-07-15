#!/usr/bin/env zsh
# Prompt
## Common
_user_color="green"; [ $UID -eq 0 ] && _user_color="red"
_user_emoji="$emoji[sheep]"; [ $UID -eq 0 ] && _user_emoji="$emoji[skull]"
_user_caret=">"; [ $UID -eq 0 ] && _user_caret="#"

#### Cygwin not support emojis
if [ "$TERM" = cygwin ]; then
    _user_emoji=""
fi

_fish_pwd() {
    echo $(pwd | perl -pe '
    BEGIN {
        binmode STDIN,  ":encoding(UTF-8)";
        binmode STDOUT, ":encoding(UTF-8)";
    }; s|^$ENV{HOME}|~|g; s|/([^/.])[^/]*(?=/)|/$1|g; s|/\.([^/])[^/]*(?=/)|/.$1|g
    ')
}

_git_prompt_info_short() {
    local ref

    if [[ "$(command git config --get oh-my-zsh.hide-status 2>/dev/null)" != "1" ]]; then
        ref=$(command git symbolic-ref HEAD 2> /dev/null) || \
        ref=$(command git rev-parse --short HEAD 2> /dev/null) || return 0
        echo "%{$fg[magenta]%}${ref#refs/heads/}$(parse_git_dirty)%{$reset_color%}"
    fi
}


## Left
_prompt_left_long() {
    local username="%{$fg[cyan]%}%n%{$reset_color%}"
    local hostname="%{$fg[cyan]%}%m%{$reset_color%}"
    local fpwd="%{$fg[red]%}$(_fish_pwd)%{$reset_color%}"
    local ret_status="%(?:%{$fg[$_user_color]%}:%{$fg[red]%})$_user_emoji %{$reset_color%}"

    echo "$username@$hostname $fpwd $ret_status$_user_caret "
}
_prompt_left_medium() {
    local hostname="%{$fg[cyan]%}%m%{$reset_color%}"
    local fpwd="%{$fg[red]%}$(_fish_pwd)%{$reset_color%}"
    local ret_status="%(?:%{$fg[$_user_color]%}:%{$fg[red]%})$_user_emoji %{$reset_color%}"

    echo "@$hostname $fpwd $ret_status$_user_caret "
}
_prompt_left_short() {
    local hostname="%{$fg[cyan]%}%m%{$reset_color%}"
    local ret_status="%(?:%{$fg[$_user_color]%}:%{$fg[red]%})$_user_emoji %{$reset_color%}"

    echo "@$hostname $ret_status$_user_caret "
}

_prompt_left_super_short() {
    local ret_status="%(?:%{$fg[$_user_color]%}:%{$fg[red]%})$_user_emoji %{$reset_color%}"
    echo "$ret_status$_user_caret "
}
_prompt_left() {
    if [ "$COLUMNS" -ge 80 ]; then
        _prompt_left_long
    elif [ "$COLUMNS" -ge 60 ]; then
        _prompt_left_medium
    elif [ "$COLUMNS" -ge 30 ]; then
        _prompt_left_short
    else
        _prompt_left_super_short
    fi
}
PROMPT='$(_prompt_left)'


## Right
_prompt_right_long() {
    local ret_status="%{$fg_bold[red]%}%(?..%?)%{$reset_color%}"
    local git_i="$(git_prompt_info)"
    local git_s="$(git_prompt_status)"

    echo "$ret_status$git_i$git_s%{$reset_color%}"
}
_prompt_right_medium() {
    local ret_status="%{$fg_bold[red]%}%(?..%?)%{$reset_color%}"
    local git_i="$(_git_prompt_info_short)"
    local git_s="$(git_prompt_status)"

    echo "$ret_status $git_i$git_s%{$reset_color%}"
}
_prompt_right_short() {
    local ret_status="%{$fg_bold[red]%}%(?..%?)%{$reset_color%}"
    local git_d="$(parse_git_dirty)"
    local git_s="$(git_prompt_status)"

    echo "$ret_status $git_d$git_s%{$reset_color%}"
}
_prompt_right() {
    if [ "$COLUMNS" -ge 50 ]; then
        _prompt_right_long
    elif [ "$COLUMNS" -ge 40 ]; then
        _prompt_right_medium
    else
        _prompt_right_short
    fi
}
RPROMPT='$(_prompt_right)'
