. ./theme.sh

autoload -Uz add-zsh-hook

zmodload -F zsh/datetime p:EPOCHREALTIME

PROMPT=''
RPROMPT=''
__dotfiles_theme_precmd() {
    __dotfiles_theme_ps1
    PROMPT="$__DOTFILES_THEME_PS1_RES"
}

add-zsh-hook -d precmd __dotfiles_theme_precmd
add-zsh-hook precmd __dotfiles_theme_precmd

add-zsh-hook -d preexec __dotfiles_theme_preexec
add-zsh-hook preexec __dotfiles_theme_preexec

# PROMPT='$(__dotfiles_theme_ps1)'
# RPROMPT=''

