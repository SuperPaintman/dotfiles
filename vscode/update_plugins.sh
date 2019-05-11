#!/usr/bin/env bash

EXTENSIONS_FILE="$(dirname "$(realpath "${BASH_SOURCE[0]}")")/list-extensions.txt"

# Because every OS implements it's own sort function
sort_words() {
    node -e "$(cat <<EOF
process.stdin.resume();
process.stdin.setEncoding('utf8');

var res = '';
process.stdin
    .on('data', function (chunk) {
        res += chunk.toString();
    })
    .on('end', function () {
        var result = res.split('\n').sort().join('\n').trim() + '\n';

        process.stdout.write(result);
    });
EOF
)"
}

code --list-extensions --show-versions | sort_words > "$EXTENSIONS_FILE"
