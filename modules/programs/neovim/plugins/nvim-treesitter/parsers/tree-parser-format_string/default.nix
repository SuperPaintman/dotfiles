{ buildTreesitterParser, runCommand, ... }:

buildTreesitterParser rec {
  language = "format_string";
  version = "dotfiles";
  src = runCommand "format_string-src" { } ''
    mkdir -p "$out/src"
    cp "${./grammar.js}" "$out/grammar.js"
  '';
  generate = true;
}

