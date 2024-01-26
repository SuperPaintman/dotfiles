# See: https://github.com/NixOS/nixpkgs/blob/master/pkgs/applications/editors/vim/plugins/nvim-treesitter/generated.nix
# See: https://github.com/NixOS/nixpkgs/tree/master/pkgs/development/tools/parsing/tree-sitter/grammars/
# See: https://github.com/nvim-treesitter/nvim-treesitter/blob/master/lua/nvim-treesitter/parsers.lua

{ pkgs, lib, ... }:

let
  inherit (pkgs) callPackage newScope;

  buildTreesitterParser' = callPackage <nixpkgs/pkgs/development/tools/parsing/tree-sitter/grammar.nix> { };
  buildTreesitterParser = lib.makeOverridable buildTreesitterParser';

  generated = import ./generated.nix { inherit (pkgs) fetchgit; };
  generatedParsers = lib.mapAttrs
    (name: attrs: buildTreesitterParser
      (builtins.removeAttrs attrs [ "pname" ]))
    generated;

  callTreesitterParserPackage = newScope { inherit buildTreesitterParser; };
in

generatedParsers
// (with generatedParsers; {
  tree-sitter-typescript = tree-sitter-typescript.override { generate = false; };
  tree-sitter-tsx = tree-sitter-tsx.override { generate = false; };
})
  // {
  tree-sitter-format_string = callTreesitterParserPackage ./tree-parser-format_string { };
}
