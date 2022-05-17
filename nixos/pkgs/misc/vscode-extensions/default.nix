{ pkgs, unstable, ... }:

with pkgs; rec {
  sumneko.lua = callPackage ./lua {
    inherit (unstable) sumneko-lua-language-server;
  };
}
