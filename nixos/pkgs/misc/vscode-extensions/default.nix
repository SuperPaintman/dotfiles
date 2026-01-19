{ pkgs, unstable, ... }:

with pkgs; rec {
  sumneko.lua = callPackage ./lua {
    inherit (unstable) lua-language-server;
  };

  themes = {
    superpaintman = callPackage ./themes/superpaintman { };
  };
}
