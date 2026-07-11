# See: https://github.com/davatorium/rofi

{ config, lib, libx, pkgs, ... }:

with lib;

let
  inherit (libx.colors) toHEXColor;

  inherit (config.modules.themes) theme;
  inherit (config.modules.home) standalone;
  cfg = config.modules.programs.rofi;

  mkBin = package: name: if standalone then name else "${package}/bin/${name}";

  isHEXColor = value: isString value && match "^#[0-9a-fA-F]{6,8}$" value != null;

  isVariable = value: isString value && match "^@.+" value != null;

  isUnit = suffix: value: isString value && match ("^[[:digit:]\\.]+" + suffix + "$") value != null;

  isPercentage = isUnit "%";

  isRaw = value: isHEXColor value || isVariable value || isPercentage value;

  mkRasiValue = property: value:
    if isList value then
      if property == "modi" || hasPrefix "kb-" property then builtins.toJSON (concatMapStringsSep "," toString value)
      else if property == "children" then "[ " + (concatMapStringsSep ", " toString value) + " ]"
      else concatMapStringsSep " " toString value
    else if value == "none" then "none"
    else if value == "inherit" then "inherit"
    else if isRaw value then value
    else if isString value then
      if property == "location" || property == "anchor" then value
      else builtins.toJSON value
    else if value == true then "true"
    else if value == false then "false"
    else toString value;

  mkRasiProperty = property: value: "${property}: ${mkRasiValue property value};";

  mkRasiProperties' = { indent ? "  " }: properties: pipe properties [
    (filterAttrs (n: v: v != null))
    attrsToList
    (map ({ name, value }: mkRasiProperty name value))
    (map (line: indent + line))
    (concatStringsSep "\n")
  ];
  mkRasiProperties = mkRasiProperties' { };

  mkRasi = { imports ? [ ], rules ? { } }:
    let
      importsText = pipe imports [
        (map (imp: "@import ${builtins.toJSON imp}"))
        (concatStringsSep "\n")
      ];

      rules' = pipe rules [
        (r:
          if isList r then r
          else mapAttrsToList
            (k: v: { selectors = k; properties = v; })
            r
        )
        (map (r: r // {
          selectorPrefix = if r.selectors == "configuration" || r.selectors == "*" then "" else "#";
          selectors = toList r.selectors; 
        }))
      ];

      rulesetText = pipe rules' [
        (map ({ selectorPrefix, selectors, properties }: ''
          ${selectorPrefix}${concatStringsSep ",\n" selectors} {
          ${mkRasiProperties properties}
          }
        ''))
        (concatStringsSep "\n")
      ];
    in ''
      ${importsText}

      ${rulesetText}

      /* vi: ft=sass
       */
    '';

  rofi = libx.builders.mkWrapper (cfg.package.override {
    plugins = [
      pkgs.rofi-emoji
    ];
  }) { } ''
    for bin in "$out/bin/"* ; do
      if [ -f "$bin" ]; then
        wrapProgram "$bin" \
          --set ROFI_CUSTOM_COLOR_BASE0 ${escapeShellArg (toHEXColor theme.colors.base0.color)} \
          --set ROFI_CUSTOM_COLOR_BASE1 ${escapeShellArg (toHEXColor theme.colors.base1.color)} \
          --set ROFI_CUSTOM_COLOR_BASE2 ${escapeShellArg (toHEXColor theme.colors.base2.color)} \
          --set ROFI_CUSTOM_COLOR_BASE3 ${escapeShellArg (toHEXColor theme.colors.base3.color)} \
          --set ROFI_CUSTOM_COLOR_BASE4 ${escapeShellArg (toHEXColor theme.colors.base4.color)} \
          --set ROFI_CUSTOM_COLOR_BASE5 ${escapeShellArg (toHEXColor theme.colors.base5.color)} \
          --set ROFI_CUSTOM_COLOR_BASE6 ${escapeShellArg (toHEXColor theme.colors.base6.color)} \
          --set ROFI_CUSTOM_COLOR_BASE7 ${escapeShellArg (toHEXColor theme.colors.base7.color)} \
          --set ROFI_CUSTOM_COLOR_BASE8 ${escapeShellArg (toHEXColor theme.colors.base8.color)} \
          --set ROFI_CUSTOM_COLOR_BLACK ${escapeShellArg (toHEXColor theme.colors.black.color)} \
          --set ROFI_CUSTOM_COLOR_RED ${escapeShellArg (toHEXColor theme.colors.red.color)} \
          --set ROFI_CUSTOM_COLOR_GREEN ${escapeShellArg (toHEXColor theme.colors.green.color)} \
          --set ROFI_CUSTOM_COLOR_YELLOW ${escapeShellArg (toHEXColor theme.colors.yellow.color)} \
          --set ROFI_CUSTOM_COLOR_BLUE ${escapeShellArg (toHEXColor theme.colors.blue.color)} \
          --set ROFI_CUSTOM_COLOR_MAGENTA ${escapeShellArg (toHEXColor theme.colors.magenta.color)} \
          --set ROFI_CUSTOM_COLOR_CYAN ${escapeShellArg (toHEXColor theme.colors.cyan.color)}
      fi
    done
  '';
in

{
  # Options.
  options.modules.programs.rofi = with types; {
    enable = mkOption {
      type = bool;
      default = false;
      description = ''
        Whenever to configure `rofi`.
      '';
    };

    package = mkOption {
      type = package;
      default = pkgs.rofi;
      defaultText = literalExpression "pkgs.rofi";
      description = ''
        The Rofi package to use.
      '';
    };

    config = mkOption {
      type = attrsOf (nullOr (oneOf [
        int
        float
        str
        bool
        (listOf (oneOf [ int float str ]))
      ]));
      default = {};
    };
  };

  # Config.
  config = mkMerge [
    {
      modules.programs.rofi.config = let
        mkDefaultAll = attrs: mapAttrs
          (name: value: if isAttrs value then mkDefaultAll value else mkDefault value)
          attrs;
      in mkDefaultAll {
        modi = [
          "window"
          "drun"
          "emoji"
          # "other:~/.config/rofi/modes/other"
          # "other:/home/superpaintman/Projects/github.com/SuperPaintman/dotfiles/pkgs/extras/rofi-modes"
          "other:${mkBin pkgs.extras "rofi-modes"}"
        ];

        show-icons = true;
        icon-theme = "Paper";

        font = "sans 14";
        # font = "JetBrainsMono Nerd Font 14";

        fixed-num-lines = false;

        cycle = true;

        lines = 10;

        # Vim mode.
        kb-mode-complete = "";
        kb-mode-next = [ "Shift+Right" "Control+Tab" "Control+l" ];
        kb-mode-previous = [ "Shift+Left" "Control+Shift+Tab" "Control+h" ];
        kb-row-up = [ "Up" "Control+p" "Control+k" ];
        kb-row-down = [ "Down" "Control+n" "Control+j" ];
        kb-accept-entry = [ "Return" "Control+m" "KP_Enter" ]; # Default `Control+j`.
        kb-remove-to-eol = ""; # Default `Control+k`.
        kb-remove-char-back = [ "BackSpace" ]; # Default `Control+h`.
        # kb-cancel = [ "Escape" "Control+bracketleft" "Control+c" ];
        kb-cancel = [ "Escape" "Control+bracketleft" ];
      };
    }

    (mkIf cfg.enable {
      modules = {
        users.packages = [
          rofi
        ];

        home.configFiles = {
          "rofi/config.rasi".text = mkRasi {
            imports = [
              "~/.config/rofi/theme.rasi"
            ];

            rules.configuration = cfg.config;
          };

          "rofi/colors.rasi".text = mkRasi {
            rules."*" = {
              color-foreground = toHEXColor theme.colors.foreground.color;
              color-background = toHEXColor theme.colors.base2.color;

              color-black = toHEXColor theme.colors.black.color;
              color-red = toHEXColor theme.colors.red.color;
              color-green = toHEXColor theme.colors.green.color;
              color-yellow = toHEXColor theme.colors.yellow.color;
              color-blue = toHEXColor theme.colors.blue.color;
              color-magenta = toHEXColor theme.colors.magenta.color;
              color-cyan = toHEXColor theme.colors.cyan.color;
              color-white = toHEXColor theme.colors.white.color;

              color-black-bright = toHEXColor theme.colors.brightBlack.color;
              color-red-bright = toHEXColor theme.colors.brightRed.color;
              color-green-bright = toHEXColor theme.colors.brightGreen.color;
              color-yellow-bright = toHEXColor theme.colors.brightYellow.color;
              color-blue-bright = toHEXColor theme.colors.brightBlue.color;
              color-magenta-bright = toHEXColor theme.colors.brightMagenta.color;
              color-cyan-bright = toHEXColor theme.colors.brightCyan.color;
              color-white-bright = toHEXColor theme.colors.brightWhite.color;

              color-background-light = toHEXColor theme.colors.base3.color;
            };
          };

          "rofi/theme.rasi".text = mkRasi {
            imports = [
              "~/.config/rofi/colors.rasi"
            ];

            rules = [
              {
                selectors = "*";
                properties = {
                  color-border = "@color-blue";
                };
              }

              {
                selectors = "window";
                properties = {
                  padding = 11;

                  background-color = "@color-background";
                  text-color = "@color-foreground";

                  border = 1;
                  border-radius = 4;
                  border-color = "@color-border";

                  location = "north";
                  anchor = "north";

                  y-offset = "20%";
                };
              }

              {
                selectors = "mainbox";
                properties = {
                  children = [ "inputbar" "message" "listview" ];
                };
              }

              {
                selectors = "textbox";
                properties = {
                  background-color = "@color-red";
                  text-color = "@color-foreground";

                  border-radius = 4;
                };
              }

              {
                selectors = "inputbar";
                properties = {
                  border-radius = 4;

                  background-color = "@color-background-light";

                  children = [
                    "entry"
                    "case-indicator"
                    # "prompt"
                    "mode-switcher"
                  ];
                };
              }

              {
                selectors = [
                  "prompt"
                  "entry"
                  "case-indicator"
                ];
                properties = {
                  background-color = "inherit";
                };
              }

              {
                selectors = "entry";
                properties = {
                  padding = [ 11 11 ];

                  text-color = "@color-foreground";
                  font = "sans 14";
                  vertical-align = 0.5;
                };
              }

              {
                selectors = "listview";
                properties = {
                  # margin-top.
                  margin = [ 5 0 0 ];
                  border = "none";

                  spacing = 0;

                  scrollbar = false;
                };
              }

              {
                selectors = "scrollbar";
                properties = {
                  background-color = "@color-background-light";
                };
              }

              {
                selectors = "element";
                properties = {
                  padding = 11;

                  border = [ 0 0 0 0 ];
                  border-radius = 4;
                  border-color = "@color-background-light";

                  font = "sans 14";

                  children = [ "element-icon" "element-text" ];
                };
              }

              {
                selectors = [
                  "element.normal.normal"
                  "element.normal.urgent"
                  "element.normal.active"
                  "element.alternate.normal"
                  "element.alternate.urgent"
                  "element.alternate.active"
                ];
                properties = {
                  background-color = "@color-background";
                  text-color = "@color-foreground";

                  # border = 1;
                  # border-color = "@color-background";
                };
              }

              {
                selectors = [
                  "element.selected.normal"
                  "element.selected.urgent"
                  "element.selected.active"
                ];
                properties = {
                  background-color = "@color-background-light";

                  # border = 1;
                  # border-color = "@color-blue";
                };
              }

              {
                selectors = "element-icon";
                properties = {
                  size = 24;
                  margin = [ 0 6 0 0 ];
                };
              }

              {
                selectors = "element-text";
                properties = {
                  font = "sans 14";
                  vertical-align = 0.5;
                };
              }

              {
                selectors = "mode-switcher";
                properties = {
                  margin = [ 6 6 ];

                  border-radius = 4;

                  background-color = "@color-background";
                };
              }

              {
                selectors = "button";
                properties = {
                  margin = [ 2 2 ];
                  width = 120;

                  text-color = "@color-foreground";
                  font = "sans 12";
                };
              }

              {
                selectors = "button.selected";
                properties = {
                  background-color = "@color-magenta";

                  border-radius = 4;
                };
              }
            ];
          };
        };
      };
    })
  ];
}
