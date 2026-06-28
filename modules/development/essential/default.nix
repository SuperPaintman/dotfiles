# Development packages I prefer to always have.
{ pkgs, config, lib, ... }:

with lib;

let
  inherit (config.modules.home) standalone;
  cfg = config.modules.development.essential;

  mkBin = package: name: if standalone then name else "${package}/bin/${name}";
in

{
  # Options.
  options.modules.development.essential = with types; {
    enable = mkOption {
      type = bool;
      default = false;
      description = ''
        Whenever to configure essential development programs.
      '';
    };
  };

  # Config.
  config = mkIf cfg.enable {
    modules = {
      users.packages = with pkgs; [ 
        gnumake # make
      ];
    };
  };
}
