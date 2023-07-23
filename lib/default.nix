{ pkgs }:

pkgs.lib.makeExtensible (self:
  let
    callLibs = file: import file { lib = self; };
  in
  pkgs.lib // {
    x = {
      # Colors.
      colors = callLibs ./colors.nix;

      # Serialization.
      generators = callLibs ./generators.nix;
    };
  })
