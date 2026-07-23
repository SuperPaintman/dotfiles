autoload -Uz add-zsh-hook

zmodload -F zsh/datetime p:EPOCHREALTIME

__dotfiles_theme_fishpwd "${PWD:-/}" "${HOME:-/home/nobody}" \
    || __DOTFILES_THEME_FISHPWD_RES="error($?)"

PROMPT=''
RPROMPT=''
__dotfiles_theme_precmd() {
    __dotfiles_theme_ps1 "$?"
    PROMPT="$__DOTFILES_THEME_PS1_RES"
}

__dotfiles_theme_chpwd() {
    __dotfiles_theme_fishpwd "${PWD:-/}" "${HOME:-/home/nobody}" \
        || __DOTFILES_THEME_FISHPWD_RES="error($?)"

    __dotfiles_theme_ps1 0
    PROMPT="$__DOTFILES_THEME_PS1_RES"
}

add-zsh-hook -d precmd __dotfiles_theme_precmd
add-zsh-hook precmd __dotfiles_theme_precmd

add-zsh-hook -d chpwd __dotfiles_theme_chpwd
add-zsh-hook chpwd __dotfiles_theme_chpwd

add-zsh-hook -d preexec __dotfiles_theme_preexec
add-zsh-hook preexec __dotfiles_theme_preexec

# PROMPT='$(__dotfiles_theme_ps1)'
# RPROMPT=''

