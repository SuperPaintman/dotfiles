#!/usr/bin/env zsh
# Prompt
## Common
_user_color="green"
[ $UID -eq 0 ] && _user_color="red"
_user_caret=">"
[ $UID -eq 0 ] && _user_caret="#"
if [ "$TERM" = cygwin ]; then
    # Cygwin is not supported emojis
    _user_emoji="@"
    [ $UID -eq 0 ] && _user_emoji="!"
else
    _user_emoji="$emoji[panda_face]"
    [ $UID -eq 0 ] && _user_emoji="$emoji[skull]"
fi

_fish_pwd() {
    echo $(pwd | perl -pe '
    BEGIN {
        binmode STDIN,  ":encoding(UTF-8)";
        binmode STDOUT, ":encoding(UTF-8)";
    }; s|^$ENV{HOME}|~|g; s|/([^/.])[^/]*(?=/)|/$1|g; s|/\.([^/])[^/]*(?=/)|/.$1|g
    ')
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
