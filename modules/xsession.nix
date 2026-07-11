{ config, options, lib, libx, pkgs, ... }:

with lib;

let
  inherit (config.modules.home) standalone;
  inherit (config.modules.themes) theme;
  inherit (libx.colors) toHEXColor;
  cfg = config.modules.xsession;

  mkBin = package: name: if standalone then name else "${package}/bin/${name}";

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

  assertion = cond: message: {
    assertions = [ { assertion = cond; inherit message; } ];
  };
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
          Whenever to configure `xresources`.
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

    xmodmap = {
      enable = mkOption {
        type = bool;
        default = false;
        description = ''
          Whenever to configure `xmodmap`.
        '';
      };
    };
  };

  # Config.
  config = mkMerge [
    {
      home-manager.users = (mapAttrs'
        (username: _: nameValuePair config.modules.users.users.${username}.name {
          xresources.path = "${normalizeHome username config.modules.xdg.configHome}/x11/resources";
          xsession.scriptPath = "${normalizeHome username config.modules.xdg.configHome}/x11/session";
        })
        config.modules.users.users);
    }

    (assertion (cfg.xresources.enable -> pkgs.stdenv.hostPlatform.isLinux || standalone)
      "[modules.xsession]: xresources available only on Linux")
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
          xresources.properties = mkAliasDefinitions options.modules.xsession.xresources.properties;
        })
        config.modules.users.users);

      # services.xserver.displayManager.sessionCommands = ''
      #   if [ -f "${config.modules.xdg.configHome}/x11/resources" ]; then
      #     ${pkgs.xorg.xrdb}/bin/xrdb -merge "${config.modules.xdg.configHome}/x11/resources"
      #   fi
      # '';
    })

    (assertion (cfg.xmodmap.enable -> pkgs.stdenv.hostPlatform.isLinux || standalone)
      "[modules.xsession]: xmodmap available only on Linux")
    (mkIf cfg.xmodmap.enable (let
      xmodmapScript = pkgs.writeShellScriptBin "xmodmap-setup" ''
        set -euo pipefail

        # Create a state dir. 
        if [ ! -d "${config.modules.xdg.stateHome}/x11" ]; then
          (umask 077 && mkdir "${config.modules.xdg.stateHome}/x11")
        fi
        chmod 0700 "${config.modules.xdg.stateHome}/x11"

        # Load the previous state and save the current one.
        if [ -f "${config.modules.xdg.stateHome}/x11/xmodmap.orig" ]; then
          ${pkgs.xorg.xmodmap}/bin/xmodmap "${config.modules.xdg.stateHome}/x11/xmodmap.orig"
        fi
        (umask 077 && ${pkgs.xorg.xmodmap}/bin/xmodmap -pke > "${config.modules.xdg.stateHome}/x11/xmodmap.orig")

        if [ -f "${config.modules.xdg.configHome}/x11/xmodmap" ]; then
          ${pkgs.xorg.xmodmap}/bin/xmodmap "${config.modules.xdg.configHome}/x11/xmodmap"
        fi
      '';
    in {
      home-manager.users = (mapAttrs'
        (username: _: nameValuePair config.modules.users.users.${username}.name {
          xsession.initExtra = ''
            ${xmodmapScript}/bin/xmodmap-setup
          '';
        })
        config.modules.users.users);

      services.xserver.displayManager.sessionCommands = ''
        ${xmodmapScript}/bin/xmodmap-setup
      '';

      modules.home.configFiles = {
        "x11/xmodmap" = {
          # Refer the `xmodmap-setup` script to thigger the onChange.
          text = ''
            ! ${mkBin xmodmapScript "xmodmap-setup"}
            !
            ! See: xmodmap -pke
            ! See: xev

            ! Remap some russian symbols for Moonlander.

            ! \ -> х
            ! / -> Х
            keycode  51 = backslash bar Cyrillic_ha Cyrillic_HA

            ! Ь -> ъ
            keycode  58 = m M Cyrillic_softsign Cyrillic_hardsign
          '';
          onChange = ''
            ${xmodmapScript}/bin/xmodmap-setup
          '';
        };
      };
    }))
  ];
}
