{ config, options, lib, libx, pkgs, ... }:

with lib;

let
  inherit (libx.colors) toHEXColor;

  replaceHomeEnv' = replacement: str:
    if hasPrefix "$HOME/" str then replacement + removePrefix "$HOME/" str
    else if hasPrefix "\${HOME}/" str then replacement + removePrefix "\${HOME}/" str
    else str;

  replaceHomeEnv = replacement: replaceHomeEnv' (replacement + "/");

  removeHomeEnv = replaceHomeEnv' "";

  normalizeHome = name: replaceHomeEnv config.home-manager.users.${name}.home.homeDirectory;

  mkDefaultAll = attrs: mapAttrs
    (name: value: if isAttrs value then mkDefaultAll value else mkDefault value)
    attrs;

  inherit (config.modules.themes) theme;
  cfg = config.modules.xsession;
in

{
  # Options.
  options.modules.xsession = with types; {
    # See: https://wiki.archlinux.org/title/X_resources
    xresources = {
      enable = mkOption {
        type = bool;
        default = false;
        description = ''
          Whenever to configure `xsession`.
        '';
      };

      properties = mkOption {
        type = let
          prim = oneOf [ bool int float str ];
          entry = either prim (listOf prim);
        in nullOr (attrsOf entry);
        default = null;
        example = {
          "XTerm*faceName" = "dejavu sans mono";
        };
        description = ''
          X server resources that should be set.
        '';
      };
    };
  };

  # Config.
  config = mkMerge [
    {
      assertions = [
        {
          assertion = cfg.xresources.enable -> pkgs.stdenv.hostPlatform.isLinux;
          message = "[modules.xsession]: xresources available only on Linux";
        }
      ];
    }
    (mkIf cfg.xresources.enable {
      modules.xsession.xresources.properties = mkDefaultAll {
        # Colors.
        "*.foreground" = toHEXColor theme.colors.foreground.color;
        "*.background" = toHEXColor theme.colors.background.color;
        "*.cursorColor" = toHEXColor theme.colors.cursor.color;

        "*.color0" = toHEXColor theme.colors.black.color;
        "*.color1" = toHEXColor theme.colors.red.color;
        "*.color2" = toHEXColor theme.colors.green.color;
        "*.color3" = toHEXColor theme.colors.yellow.color;
        "*.color4" = toHEXColor theme.colors.blue.color;
        "*.color5" = toHEXColor theme.colors.magenta.color;
        "*.color6" = toHEXColor theme.colors.cyan.color;
        "*.color7" = toHEXColor theme.colors.white.color;
        "*.color8" = toHEXColor theme.colors.brightBlack.color;
        "*.color9" = toHEXColor theme.colors.brightRed.color;
        "*.color10" = toHEXColor theme.colors.brightGreen.color;
        "*.color11" = toHEXColor theme.colors.brightYellow.color;
        "*.color12" = toHEXColor theme.colors.brightBlue.color;
        "*.color13" = toHEXColor theme.colors.brightMagenta.color;
        "*.color14" = toHEXColor theme.colors.brightCyan.color;
        "*.color15" = toHEXColor theme.colors.brightWhite.color;

        # Xcursor
        # TODO(SuperPaintman): make configurable.
        "Xcursor.theme" = "Paper";
        "Xcursor.size" = 16;
      };
    })
    (mkIf cfg.xresources.enable {
      home-manager.users = (mapAttrs'
        (username: _: nameValuePair config.modules.users.users.${username}.name {
          xresources.path = "${normalizeHome username config.modules.xdg.configHome}/x11/resources";
          xresources.properties = mkAliasDefinitions options.modules.xsession.xresources.properties;
        })
        config.modules.users.users);

      # services.xserver.displayManager.sessionCommands = ''
      #   if [ -f "${config.modules.xdg.configHome}/x11/resources" ]; then
      #     ${pkgs.xorg.xrdb}/bin/xrdb -merge "${config.modules.xdg.configHome}/x11/resources"
      #   fi
      # '';
    })
  ];
}
