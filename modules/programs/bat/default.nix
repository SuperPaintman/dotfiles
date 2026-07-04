# Packages and common settings I prefer to always have.
#
# See: https://github.com/sharkdp/bat
# See: https://github.com/sharkdp/bat/blob/391e7ff072e9349dd7d2f695d84f0650e895a183/src/bin/bat/main.rs#L301
{ pkgs, config, lib, ... }:

with lib;

let
  inherit (config.modules.home) standalone;
  cfg = config.modules.programs.bat;
  themes = pkgs.callPackage ../../../themes { };

  mkBin = package: name: if standalone then name else "${package}/bin/${name}";

  BAT_CONFIG_DIR = "$XDG_CONFIG_HOME/bat";
  BAT_CONFIG_PATH = "${BAT_CONFIG_DIR}/bat.conf";
  BAT_CACHE_PATH = "$XDG_CACHE_HOME/bat";
  BAT_THEME = "SuperPaintman";
  # BAT_THEME = "TwoDark";
in

{
  # Options.
  options.modules.programs.bat = with types; {
    enable = mkOption {
      type = bool;
      default = false;
      description = ''
        Whenever to configure bat.
      '';
    };

    package = mkOption {
      type = package;
      default = pkgs.bat;
      defaultText = literalExpression "pkgs.bat";
      description = ''
        The bat package to use.
      '';
    };
  };

  # Config.
  config = mkIf cfg.enable {
    modules = {
      users.packages = [ cfg.package ];

      shell.variables = {
        inherit 
          BAT_CONFIG_DIR
          BAT_CONFIG_PATH
          BAT_CACHE_PATH
          BAT_THEME;
      };

      shell.aliases = {
        cat = mkBin pkgs.bat "bat";
      };

      home.configFiles = {
        "bat/bat.conf".text = ''
          # This is `bat`s configuration file.
          --theme="${BAT_THEME}"
        '';
        "bat/themes/SuperPaintman/SuperPaintman.tmTheme" = {
          source = themes.applications.textmate.writeTextmateThemeFile {
            name = "SuperPaintman";
            author = "SuperPaintman";
            semanticClass = "theme.dark.superpaintman";
            uuid = "ad17b280-ee9e-11ec-a8bd-43d0ce50926a";
          };
          onChange = ''
            ${pkgs.bat}/bin/bat cache --build
          '';
        };
      };

      # home.activation.batCache = ''
      #   if [ ! -d "${BAT_CACHE_PATH}" ]; then
      #     mkdir "${BAT_CACHE_PATH}"
      #   fi
      #   ${pkgs.bat}/bin/bat cache --clear
      #   ${pkgs.bat}/bin/bat cache --build
      # '';
    };
  };
}
