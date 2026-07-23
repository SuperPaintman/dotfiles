. ./theme.sh

PS1=''
__dotfiles_theme_prompt_command() {
    __dotfiles_theme_ps1
    PS1="$__DOTFILES_THEME_PS1_RES"
}

# PS1='$(__dotfiles_theme_ps1)'
PROMPT_COMMAND=__dotfiles_theme_prompt_command
