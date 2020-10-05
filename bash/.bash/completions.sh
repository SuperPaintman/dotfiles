#!/usr/bin/env bash

if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
fi

if can fzf-share && [ -f "$(fzf-share)/completion.bash" ]; then
    source "$(fzf-share)/completion.bash"
elif can brew && brew --prefix fzf > /dev/null 2>&1 && [ -f "$(brew --prefix fzf)/shell/completion.bash" ]; then
    source "$(brew --prefix fzf)/shell/completion.bash"
fi
