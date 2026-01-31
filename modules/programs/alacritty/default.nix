# See: https://alacritty.org/config-alacritty.html
# See: https://github.com/alacritty/alacritty
# See: https://wiki.archlinux.org/title/Alacritty

{ config, lib, pkgs, ... }:

with lib;

let
  inherit (pkgs.lib.x.colors) toHEXColor;

  inherit (config.modules.themes) theme;
  inherit (config.modules.home) standalone;
  cfg = config.modules.programs.alacritty;

  toml = pkgs.formats.toml { };
in

{
  # Options.
  options.modules.programs.alacritty = with types; {
    enable = mkOption {
      type = bool;
      default = false;
      description = mdDoc ''
        Whenever to configure `alacritty`.
      '';
    };

    package = mkOption {
      type = package;
      default = pkgs.alacritty;
      defaultText = literalExpression "pkgs.alacritty";
      description = mdDoc ''
        The alacritty package to use.
      '';
    };
  };

  # Config.
  config = mkIf cfg.enable {
    modules = {
      users.packages = [ cfg.package ];

      home.configFiles = {
        "alacritty/alacritty.toml".source = toml.generate "alacritty.toml" {
          general = {
            import = [
              "~/.config/alacritty/default.toml"
              "~/.config/alacritty/colors.toml"
            ] ++ optionals pkgs.stdenv.isDarwin [
              "~/.config/alacritty/macos.toml"
            ];

            # Live config reload (changes require restart).
            live_config_reload = true;
          };
        };
        "alacritty/default.toml".source = toml.generate "default.toml" {
          env = {
            # Alacritty is not supported over ssh.
            TERM = "xterm-256color";

            # Fix huge font.
            # Set the device pixel ratio to 1.
            WINIT_X11_SCALE_FACTOR = "1";
          };

          window = {
            padding = { x = 2; y = 2; };
            dynamic_padding = true;
            # opacity = 0.95;
          };

          font = {
            size = 12;
            normal.family = "JetBrainsMono Nerd Font";
          };

          mouse = {
            bindings = [
              { mouse = "Middle"; action = "None"; } # No more paste.
            ];
          };

          keyboard = {
            bindings = [ ];
          };
        };
        "alacritty/colors.toml".source = toml.generate "colors.toml" {
          colors.primary = {
            background = toHEXColor theme.colors.background.color;
            foreground = toHEXColor theme.colors.foreground.color;
          };

          colors.cursor = {
            text = toHEXColor theme.colors.base5.color;
            cursor = toHEXColor theme.colors.cursor.color;
          };

          colors.normal = {
            black = toHEXColor theme.colors.black.color;
            red = toHEXColor theme.colors.red.color;
            green = toHEXColor theme.colors.green.color;
            yellow = toHEXColor theme.colors.yellow.color;
            blue = toHEXColor theme.colors.blue.color;
            magenta = toHEXColor theme.colors.magenta.color;
            cyan = toHEXColor theme.colors.cyan.color;
            white = toHEXColor theme.colors.white.color;
          };

          colors.bright = {
            black = toHEXColor theme.colors.brightBlack.color;
            red = toHEXColor theme.colors.brightRed.color;
            green = toHEXColor theme.colors.brightGreen.color;
            yellow = toHEXColor theme.colors.brightYellow.color;
            blue = toHEXColor theme.colors.brightBlue.color;
            magenta = toHEXColor theme.colors.brightMagenta.color;
            cyan = toHEXColor theme.colors.brightCyan.color;
            white = toHEXColor theme.colors.brightWhite.color;
          };
        };
        "alacritty/macos.toml".source = toml.generate "macos.toml" {
          # "\u0001" - ^A
          # "\u0002" - ^B
          # "\u0003" - ^C
          # ...
          #
          #  MacOS.
          #
          #  I use remapped modifier keys. So, my:
          #  - 'control' is 'command' (`control')
          #  - 'option' is 'control' (`super')
          #  - 'command' is 'option' (`meta')
          bindings = let 
            fixChars = v: builtins.fromJSON ''"${v}"'';
          in map (flip pipe [
            (b: if hasAttr "chars" b && isString b.chars then (b // { chars = fixChars b.chars; }) else b)
          ]) [
            { key = "C"; mods = "Command|Shift"; action = "Copy"; }
            { key = "V"; mods = "Command|Shift"; action = "Paste"; }

            { key = "A"; mods = "Command"; chars = "\\u0001"; }
            { key = "B"; mods = "Command"; chars = "\\u0002"; }
            { key = "C"; mods = "Command"; chars = "\\u0003"; }
            { key = "D"; mods = "Command"; chars = "\\u0004"; }
            { key = "E"; mods = "Command"; chars = "\\u0005"; }
            { key = "F"; mods = "Command"; chars = "\\u0006"; }
            { key = "G"; mods = "Command"; chars = "\\u0007"; }
            { key = "H"; mods = "Command"; chars = "\\u0008"; }
            { key = "I"; mods = "Command"; chars = "\\u0009"; }
            { key = "J"; mods = "Command"; chars = "\\u000A"; }
            { key = "K"; mods = "Command"; chars = "\\u000B"; }
            { key = "L"; mods = "Command"; chars = "\\u000C"; }
            { key = "M"; mods = "Command"; chars = "\\u000D"; }
            { key = "N"; mods = "Command"; chars = "\\u000E"; }
            { key = "O"; mods = "Command"; chars = "\\u000F"; }
            { key = "P"; mods = "Command"; chars = "\\u0010"; }
            { key = "Q"; mods = "Command"; chars = "\\u0011"; }
            { key = "R"; mods = "Command"; chars = "\\u0012"; }
            { key = "S"; mods = "Command"; chars = "\\u0013"; }
            { key = "T"; mods = "Command"; chars = "\\u0014"; }
            { key = "U"; mods = "Command"; chars = "\\u0015"; }
            { key = "V"; mods = "Command"; chars = "\\u0016"; }
            { key = "W"; mods = "Command"; chars = "\\u0017"; }

            { key = "Up"; mods = "Command"; chars = "\\u001B[1;5A"; }
            { key = "Down"; mods = "Command"; chars = "\\u001B[1;5B"; }
            { key = "Right"; mods = "Command"; chars = "\\u001B[1;5C"; }
            { key = "Left"; mods = "Command"; chars = "\\u001B[1;5D"; }
          ];
        };
      };
    };
  };
}
