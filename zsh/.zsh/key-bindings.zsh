#!/usr/bin/env zsh

# Note: List of all key bindings: `bindkey -l; bindkey -M main`.

# Note: ^ - Ctrl .

# Use vim key bindings.
# TDDO(SuperPaintman):
#     One day... I wanna add mode indicator in the prompt.
#     But I dont know how to detect VISUAL and REPLACE modes.
# bindkey -v

# Escape back to the normal mode.
# bindkey -M viins 'jk' vi-cmd-mode

# Accepts the current `zsh-autosuggestions` suggestion.
bindkey -M viins '^ ' autosuggest-accept

if can fzf-share && [ -f "$(fzf-share)/key-bindings.zsh" ]; then
    source "$(fzf-share)/key-bindings.zsh"
elif can brew && brew --prefix fzf > /dev/null 2>&1 && [ -f "$(brew --prefix fzf)/shell/key-bindings.zsh" ]; then
    source "$(brew --prefix fzf)/shell/key-bindings.zsh"
fi

if can git-fzf; then
    eval "$(git-fzf shell zsh status '^g^s')"
    eval "$(git-fzf shell zsh branch '^g^b')"
    eval "$(git-fzf shell zsh log '^g^l')"
fi

if can project-find; then
    project-find-widget() {
        local dir="$(project-find)"
        if [ "$dir" = "" ]; then
            return
        fi

        zle reset-prompt
        LBUFFER+="$dir"
    }

    project-find-cd-widget() {
        local dir="$(project-find)"
        if [ "$dir" = "" ]; then
            return
        fi

        cd "$dir"
        local ret="$?"
        zle fzf-redraw-prompt
        return "$ret"
    }

    zle -N project-find-cd-widget
    bindkey '\ep' project-find-cd-widget
fi

## Edit buffer in $EDITOR.
edit-zsh-buffer() {
    local temp_file="/tmp/edit-zsh-buffer.$$.zsh"
    rm -f "$temp_file"
    touch "$temp_file"
    echo "$LBUFFER" > "$temp_file"

    local editor="$EDITOR"
    if [ -z "$editor" ]; then
        editor="vim"
    fi

    local options=()
    case "$editor" in
        nvim | vim)
            # Auto enter into INSERT mode.
            options=('-c' 'set syntax=zsh | set filetype=zsh | call feedkeys("\<Esc>GA")')
            ;;
    esac

    $editor $options "$temp_file" < /dev/tty > /dev/tty || {
        local ret="$?"
        rm -f "$temp_file"
        return "$ret"
    }

    LBUFFER="$(cat "$temp_file")"
    rm -r "$temp_file"
    # Apply colors.
    zle redisplay
}
zle -N edit-zsh-buffer
bindkey '^e' edit-zsh-buffer
# bindkey '\ee' edit-zsh-buffer

# Unbindings.
bindkey -r '^s' # history-incremental-search-forward.
