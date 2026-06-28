# See: https://www.lua.org/manual/5.1/manual.html#6

{ pkgs, config, lib, ... }:

with lib;

let
  cfg = config.modules.development.lua;
in

{
  # Options.
  options.modules.development.lua = with types; {
    enable = mkOption {
      type = bool;
      default = false;
      description = ''
        Whenever to enable Lua.
      '';
    };

    package = mkOption {
      type = package;
      default = pkgs.luajit;
      defaultText = literalExpression "pkgs.luajit";
      description = ''
        The Lua package to use.
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
