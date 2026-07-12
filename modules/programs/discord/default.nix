{ config, lib, pkgs, ... }:

with lib;

let
  inherit (config.modules.home) standalone;
  cfg = config.modules.programs.discord;

  json = pkgs.formats.json { };
in

{
  # Options.
  options.modules.programs.discord = with types; {
    enable = mkOption {
      type = bool;
      default = false;
      description = ''
        Whenever to configure Discord.
      '';
    };

    package = mkOption {
      type = package;
      default = pkgs.discord;
      defaultText = literalExpression "pkgs.discord";
      description = ''
        The Discord package to use.
      '';
    };
  };

  # Config.
  config = mkIf cfg.enable {
    modules = {
      users.packages = [ cfg.package ];

      home.configFiles = {
        "discord/settings.json".source = json.generate "discord-settings.json" {
          OPEN_ON_STARTUP = false;
          SKIP_HOST_UPDATE = true;
        };
      };
    };
  };
}
