#!/usr/bin/env zsh
myip() {
    dig +short myip.opendns.com @resolver1.opendns.com
}

markdown() {
    local funcname="$(_get_funcname)"

    if [[ $# != 1 ]]; then
        echo -e "Usage: $funcname <file_name>" 1>&2
        return 1
    fi

    pandoc -s -f markdown -t man "$1" | man -l -
}

if ! which serve >/dev/null; then
    serve() {
        if ! which python >/dev/null; then
            echo "Please install python" 1>&2
            return 1
        fi

        if [[ $# -gt 0 ]]; then
            port="$1"
        else
            port=8000
        fi

        python -m SimpleHTTPServer $port
    }
fi

nicediff() {
    git difftool -y -x "diff -W $(tput cols) -y" | colordiff | less
}

sshkey() {
    local file="$HOME/.ssh/id_rsa.pub"

    if [ ! -f "$file" ]; then
        echo "id_rsa file is not exist" 1>&2
        return 1
    fi

    cat "$file"
}

clipsshkey() {
    sshkey | xclip -in -selection clipboard
}

extract() {
    local funcname="$(_get_funcname)"

    if [ -f "$1" ]; then
        case "$1" in
          *.tar.bz2)
              tar -jxvf "$1"
              ;;
          *.tar.gz)
              tar -zxvf "$1"
              ;;
          *.bz2)
              bunzip2 "$1"
              ;;
          *.dmg)
              hdiutil mount "$1"
              ;;
          *.gz)
              gunzip "$1"
              ;;
          *.tar)
              tar -xvf "$1"
              ;;
          *.tbz2)
              tar -jxvf "$1"
              ;;
          *.tgz)
              tar -zxvf "$1"
              ;;
          *.zip)
              unzip "$1"
              ;;
          *.ZIP)
              unzip "$1"
              ;;
          *.pax)
              cat "$1" | pax -r
              ;;
          *.pax.Z)
              uncompress "$1" --stdout | pax -r
              ;;
          *.rar)
              unrar x "$1"
              ;;
          *.Z)
              uncompress "$1"
              ;;
          *)
              echo "'$1' cannot be extracted/mounted via $funcname" 1>&2
              return 1
              ;;
        esac
    else
        echo "'$1' is not a valid file" 1>&2
        return 1
    fi
}

image() {
    if ! which convert >/dev/null; then
        echo "Please install imagemagick" 1>&2
        return 1
    fi
    if ! which jp2a >/dev/null; then
        echo "Please install jp2a" 1>&2
        return 1
    fi

    local funcname="$(_get_funcname)"

    if [[ $# != 1 ]]; then
        echo -e "Usage: $funcname <file>" 1>&2
        return 1
    fi

    convert "$1" jpg:- | jp2a --color -
}
