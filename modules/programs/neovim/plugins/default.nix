{ pkgs, neovim, ... }:

let
  inherit (pkgs) callPackage;
in

{
  lazy-nvim = callPackage ./lazy-nvim { inherit neovim; };
}
