PS1=''

__dotfiles_theme_prompt_command() {
    local ret="$?"
    __dotfiles_theme_fishpwd_update
    __dotfiles_theme_update "$ret"
}

__dotfiles_theme_fishpwd_update
__dotfiles_theme_update 0

PS1="${__DOTFILES_THEME_PS1}"
PROMPT_COMMAND=__dotfiles_theme_prompt_command
