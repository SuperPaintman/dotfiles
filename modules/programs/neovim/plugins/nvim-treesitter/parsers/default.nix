# See: https://github.com/NixOS/nixpkgs/blob/master/pkgs/applications/editors/vim/plugins/nvim-treesitter/generated.nix
# See: https://github.com/NixOS/nixpkgs/tree/master/pkgs/development/tools/parsing/tree-sitter/grammars/
# See: https://github.com/nvim-treesitter/nvim-treesitter/blob/master/lua/nvim-treesitter/parsers.lua

{ pkgs, lib, ... }:

let
  inherit (pkgs) callPackage;

  buildTreesitterParser = callPackage <nixpkgs/pkgs/development/tools/parsing/tree-sitter/grammar.nix> { };
  generated = import ./generated.nix { inherit (pkgs) fetchgit; };
in

lib.mapAttrs
  (name: attrs: buildTreesitterParser
    (builtins.removeAttrs attrs [ "pname" ]))
  generated
