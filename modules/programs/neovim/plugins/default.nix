{ pkgs, neovim, ... }:

let
  inherit (pkgs) callPackage;
in

{
  lazy-nvim = callPackage ./lazy-nvim { inherit neovim; };
  nvim-treesitter = callPackage ./nvim-treesitter { inherit neovim; };
}
