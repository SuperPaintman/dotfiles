PS1=''
__dotfiles_theme_prompt_command() {
    local ret="$?"

    __dotfiles_theme_fishpwd "${PWD:-/}" "${HOME:-/home/nobody}" \
        || __DOTFILES_THEME_FISHPWD_RES="error($?)"

    __dotfiles_theme_ps1 "$ret"
    PS1="$__DOTFILES_THEME_PS1_RES"
}

# PS1='$(__dotfiles_theme_ps1)'
PROMPT_COMMAND=__dotfiles_theme_prompt_command
