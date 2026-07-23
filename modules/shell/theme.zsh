autoload -Uz add-zsh-hook
zmodload -F zsh/datetime p:EPOCHREALTIME

PROMPT=''
RPROMPT=''

__dotfiles_theme_precmd() {
    __dotfiles_theme_update "$?"
}

__dotfiles_theme_chpwd() {
    __dotfiles_theme_fishpwd_update
}

__dotfiles_theme_fishpwd_update
__dotfiles_theme_update 0

add-zsh-hook -d precmd __dotfiles_theme_precmd
add-zsh-hook precmd __dotfiles_theme_precmd

add-zsh-hook -d chpwd __dotfiles_theme_chpwd
add-zsh-hook chpwd __dotfiles_theme_chpwd

add-zsh-hook -d preexec __dotfiles_theme_preexec
add-zsh-hook preexec __dotfiles_theme_preexec

PROMPT="${__DOTFILES_THEME_PS1}"
