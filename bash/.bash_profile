#!/usr/bin/env bash
# Start tmux
if which tmux > /dev/null 2>&1; then
    if [ -z "$TMUX" ] && [ "$TERM_PROGRAM" = "iTerm.app" ]; then
        if tmux list-session > /dev/null 2>&1; then
            tmux attach-session && exit
        else
            tmux && exit
        fi
    fi
fi

# Init
if [ -x /usr/bin/lesspipe ]; then
    eval "$(SHELL=/bin/sh lesspipe)"
fi

if [ -x /usr/bin/dircolors ]; then
    if [ -f ~/.dircolors ]; then
        eval "$(dircolors -b ~/.dircolors)"
    else
        eval "$(dircolors -b)"
    fi
fi

_is_osx() {
    case "$(uname)" in
        Darwin*)
            return 0
            ;;
    esac

    return 1
}

# Env
if [ -f ~/.bash/env.sh ]; then source ~/.bash/env.sh; fi

# Path
if [ -f ~/.bash/path.sh ]; then source ~/.bash/path.sh; fi

# Functions
if [ -f ~/.bash/functions.sh ]; then source ~/.bash/functions.sh; fi

# Aliases
if [ -f ~/.bash/aliases.sh ]; then source ~/.bash/aliases.sh; fi

# Theme
if [ -f ~/.bash/theme.sh ]; then source ~/.bash/theme.sh; fi


# === Bash only ===
if [ -n "$ZSH_VERSION" ]; then
    return 0 2> /dev/null || exit 0
fi

# Bash history
export HISTTIMEFORMAT='[%F %T] '
export HISTCONTROL=ignoreboth
export HISTSIZE=2000
export HISTFILESIZE="$HISTSIZE"
export HISTIGNORE="&:[ ]*:history:clear"

shopt -s histappend
shopt -s checkwinsize

# Completion
if [ -f ~/.bash/completion.sh ]; then source ~/.bash/completion.sh; fi
