. ./theme.sh

autoload -Uz add-zsh-hook

PROMPT=''
RPROMPT=''
__dotfiles_theme_precmd() {
    __dotfiles_theme_ps1
    PROMPT="$__DOTFILES_THEME_PS1_RES"
}

add-zsh-hook -d precmd __dotfiles_theme_precmd
add-zsh-hook precmd __dotfiles_theme_precmd

# PROMPT='$(__dotfiles_theme_ps1)'
# RPROMPT=''

