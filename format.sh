#!/usr/bin/env bash

set -e
set -u
set -o pipefail

# Helpers.
filter_bash_content() {
    while read filename; do
        if grep '#!/usr/bin/env \(bash\|zsh\|sh\)' "$filename" > /dev/null; then
            echo "$filename"
        fi
    done
}

# go get github.com/mvdan/sh/cmd/shfmt
shfmt -i 4 -ci -sr -s -w \
    $(
        find . \
            \( -type f -name '*.sh' -or -name '*.bash' -or -name '*.zsh' \) \
            -and -not -path './zsh/.oh-my-zsh/**' \
            -and -not -path './zsh/.oh-my-zsh-custom/**' \
            -and -not -path './vim/.vim/bundle/**' \
            -and -not -path './vim/.vim/plugged/**' \
            -and -not -path './tmux/.tmux/plugins/**' \
            -and -not -path '**/node_modules/**'
    ) \
    $(
        find ./bin/bin ./rofi/modes \
            -type f \
            -and -not -path './bin/bin/neofetch' \
            -and -not -path './bin/bin/styles' |
            filter_bash_content
    )
