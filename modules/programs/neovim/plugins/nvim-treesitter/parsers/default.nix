# See: https://github.com/NixOS/nixpkgs/blob/master/pkgs/applications/editors/vim/plugins/nvim-treesitter/generated.nix
# See: https://github.com/NixOS/nixpkgs/tree/master/pkgs/development/tools/parsing/tree-sitter/grammars/
# See: https://github.com/nvim-treesitter/nvim-treesitter/blob/master/lua/nvim-treesitter/parsers.lua

{ pkgs, ... }:

let
  inherit (pkgs) callPackage;

  buildTreesitterParser = callPackage <nixpkgs/pkgs/development/tools/parsing/tree-sitter/grammar.nix> { };
in

{
  tree-sitter-go = callPackage ./tree-sitter-go.nix { inherit buildTreesitterParser; };
  tree-sitter-lua = callPackage ./tree-sitter-lua.nix { inherit buildTreesitterParser; };
  tree-sitter-nix = callPackage ./tree-sitter-nix.nix { inherit buildTreesitterParser; };
}
