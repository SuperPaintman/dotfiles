{ pkgs }:

pkgs.lib.makeExtensible (self:
  let
    callLibs = file: import file { lib = self; inherit pkgs; };
  in
  pkgs.lib // {
    x = {
      # Builders.
      builders = callLibs ./builders.nix;

      # Colors.
      colors = callLibs ./colors.nix;

      # Serialization.
      generators = callLibs ./generators.nix;

      # Logger.
      logger = callLibs ./logger.nix;
    };
  })
