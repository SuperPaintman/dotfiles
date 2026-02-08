# C/C++

{ pkgs, config, lib, ... }:

with lib;

let
  cfg = config.modules.development.cc;
in

{
  # Options.
  options.modules.development.cc = with types; {
    enable = mkOption {
      type = bool;
      default = false;
      description = ''
        Whenever to enable C/C++.
      '';
    };
  };

  # Config.
  config = mkIf cfg.enable {
    modules = {
      users.packages = with pkgs; [ 
        clang
        clang-tools
        gcc
        cmake
        llvm
        ccls
      ];
    };
  };
}
