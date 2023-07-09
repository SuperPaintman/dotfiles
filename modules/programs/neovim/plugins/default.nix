{ pkgs, lib, neovim, ... }:

let
  inherit (pkgs) callPackage;

  buildNeovimPlugin = callPackage ./build.nix { inherit neovim; };

  generated = import ./generated.nix { inherit (pkgs) fetchFromGitHub; };
  generatedPlugins = lib.mapAttrs
    (name: buildNeovimPlugin)
    generated;
in

generatedPlugins // {
  lazy-nvim = callPackage ./lazy-nvim { inherit neovim; };
  nvim-treesitter = callPackage ./nvim-treesitter { inherit neovim; };
}
