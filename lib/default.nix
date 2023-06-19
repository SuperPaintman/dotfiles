{ pkgs }:

pkgs.lib.makeExtensible (self:
  let
    callLibs = file: import file { lib = self; };
  in
  pkgs.lib // {
    x = {
      # Serialization.
      generators = callLibs ./generators.nix;
    };
  })
