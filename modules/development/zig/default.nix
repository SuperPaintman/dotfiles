{ pkgs, config, lib, ... }:

with lib;

let
  cfg = config.modules.development.zig;
in

{
  # Options.
  options.modules.development.zig = with types; {
    enable = mkOption {
      type = bool;
      default = false;
      description = ''
        Whenever to enable Zig.
      '';
    };

    package = mkOption {
      type = package;
      default = pkgs.zig;
      defaultText = literalExpression "pkgs.zig";
      description = ''
        The Zig package to use.
      '';
    };
  };

  # Config.
  config = mkIf cfg.enable {
    modules = {
      users.packages = with pkgs; [ 
        cfg.package
      ];
    };
  };
}
