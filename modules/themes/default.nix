{ config, lib, ... }:

with lib;

let
  inherit (builtins) match;

  cfg = config.modules.themes;

  defaultColorChannels = { r ? 0, g ? 0, b ? 0, a ? 1 }: { inherit r g b a; };

  hexRe = "([0-9a-fA-F])";
  hexPairRe = hexRe + hexRe;
  matchRGBHex = match "^#${hexPairRe}${hexPairRe}${hexPairRe}$";
  matchRGBAHex = match "^#${hexPairRe}${hexPairRe}${hexPairRe}${hexPairRe}$";

  fromHex = v:
    if v == "0" then 0
    else if v == "1" then 1
    else if v == "2" then 2
    else if v == "3" then 3
    else if v == "4" then 4
    else if v == "5" then 5
    else if v == "6" then 6
    else if v == "7" then 7
    else if v == "8" then 8
    else if v == "9" then 9
    else if v == "a" || v == "A" then 10
    else if v == "b" || v == "B" then 11
    else if v == "c" || v == "C" then 12
    else if v == "d" || v == "D" then 13
    else if v == "e" || v == "E" then 14
    else if v == "f" || v == "F" then 15
    else
      assertMsg false "Invalid hex number.";

  fromStringColor = color:
    if stringLength color == 7 # #000000
    then
      let
        parts = matchRGBHex color;
      in
      assert assertMsg (parts != null) "Invalid hex RGB color.";
      let
        r1 = fromHex (elemAt parts 0);
        r2 = fromHex (elemAt parts 1);
        g1 = fromHex (elemAt parts 2);
        g2 = fromHex (elemAt parts 3);
        b1 = fromHex (elemAt parts 4);
        b2 = fromHex (elemAt parts 5);
      in
      {
        r = r1 * 16 + r2;
        g = g1 * 16 + g2;
        b = b1 * 16 + b2;
        a = 1.0;
      }
    else if stringLength color == 9 # #00000000
    then
      let
        parts = matchRGBAHex color;
      in
      assert assertMsg (parts != null) "Invalid hex RGBA color.";
      let
        r1 = fromHex (elemAt parts 0);
        r2 = fromHex (elemAt parts 1);
        g1 = fromHex (elemAt parts 2);
        g2 = fromHex (elemAt parts 3);
        b1 = fromHex (elemAt parts 4);
        b2 = fromHex (elemAt parts 5);
        a1 = fromHex (elemAt parts 6);
        a2 = fromHex (elemAt parts 7);
      in
      {
        r = r1 * 16 + r2;
        g = g1 * 16 + g2;
        b = b1 * 16 + b2;
        a = (a1 * 16 + a2) / 255.0;
      }
    else
      assertMsg false "Invalid color format.";

  mkColorOption = name: color: ansiFG: ansiBG: with types; mkOption {
    type = submodule colorOptions;
    default = {
      inherit color;
      ansi = {
        foreground = ansiFG;
        background = ansiBG;
      };
    };
  };

  mkColorChannelOption = name: type: default: with types; mkOption {
    inherit type default;
  };

  rgbaOptions = with types; {
    options = {
      r = mkColorChannelOption "r" ints.u8 0;
      g = mkColorChannelOption "g" ints.u8 0;
      b = mkColorChannelOption "b" ints.u8 0;
      a = mkColorChannelOption "a" (addCheck float (x: x >= 0.0 && x <= 1.0)) 1.0;
    };
  };

  colorOptions = with types; {
    options = {
      color = mkOption {
        type = oneOf [ str (submodule rgbaOptions) ];
        default = { };
        apply = v:
          if isString v
          then defaultColorChannels (fromStringColor v)
          else defaultColorChannels v;
      };

      ansi = {
        foreground = mkOption {
          type = str;
          default = "30";
          # TODO(SuperPaintman): add checks.
        };

        background = mkOption {
          type = str;
          default = "40";
          # TODO(SuperPaintman): add checks.
        };
      };
    };
  };

  themeOptions = with types; {
    options = {
      colors = {
        # ANSI colors.
        black = mkColorOption "black" "#000000" "30" "40";
        red = mkColorOption "red" "#AA0000" "31" "41";
        green = mkColorOption "green" "#00AA00" "32" "42";
        yellow = mkColorOption "yellow" "#AAAA00" "33" "43";
        blue = mkColorOption "blue" "#0000AA" "34" "44";
        magenta = mkColorOption "magenta" "#AA00AA" "35" "45";
        cyan = mkColorOption "cyan" "#00AAAA" "36" "46";
        white = mkColorOption "white" "#AAAAAA" "37" "47";

        brightBlack = mkColorOption "brightBlack" "#555555" "90" "100";
        brightRed = mkColorOption "brightRed" "#FF0000" "91" "101";
        brightGreen = mkColorOption "brightGreen" "#00ff00" "92" "102";
        brightYellow = mkColorOption "brightYellow" "#FFFF00" "93" "103";
        brightBlue = mkColorOption "brightBlue" "#0000FF" "94" "104";
        brightMagenta = mkColorOption "brightMagenta" "#FF00FF" "95" "105";
        brightCyan = mkColorOption "brightCyan" "#00FFFF" "96" "106";
        brightWhite = mkColorOption "brightWhite" "#FFFFFF" "97" "107";

        # Non-standard.
        grey = mkColorOption "grey" "#555555" "90" "100";
        orange = mkColorOption "orange" "#AA4000" "31" "41";
        brightOrange = mkColorOption "brightOrange" "#FF8000" "91" "101";
        violet = mkColorOption "violet" "#4000AA" "35" "95";
        brightViolet = mkColorOption "brightViolet" "#8000FF" "95" "105";

        # GUI.
        background = mkColorOption "background" "#000000" "30" "40";
        foreground = mkColorOption "foreground" "#AAAAAA" "37" "47";
        cursor = mkColorOption "cursor" "#FFFFFF" "97" "107";
        base0 = mkColorOption "base0" "#000000" "30" "40";
        base1 = mkColorOption "base1" "#121212" "30" "40";
        base2 = mkColorOption "base2" "#242424" "30" "40";
        base3 = mkColorOption "base3" "#373737" "30" "40";
        base4 = mkColorOption "base4" "#494949" "90" "100";
        base5 = mkColorOption "base5" "#5B5B5B" "90" "100";
        base6 = mkColorOption "base6" "#6D6D6D" "90" "100";
        base7 = mkColorOption "base7" "#808080" "37" "47";
        base8 = mkColorOption "base8" "#929292" "37" "47";
        base9 = mkColorOption "base9" "#A4A4A4" "37" "47";
        base10 = mkColorOption "base10" "#B6B6B6" "37" "47";
        base11 = mkColorOption "base11" "#C8C8C8" "97" "107";
        base12 = mkColorOption "base12" "#DBDBDB" "97" "107";
        base13 = mkColorOption "base13" "#EDEDED" "97" "107";
        base14 = mkColorOption "base14" "#FFFFFF" "97" "107";
      };
    };
  };

  mkTheme' = super: theme:
    let
      getColor' = ns: name: {
        color = theme.${ns}.${name}.color or super.${ns}.${name}.color;
        ansi = {
          foreground = theme.${ns}.${name}.ansi.foreground or super.${ns}.${name}.ansi.foreground;
          background = theme.${ns}.${name}.ansi.background or super.${ns}.${name}.ansi.background;
        };
      };

      getColor = getColor' "colors";
    in
    {
      colors = {
        # ANSI colors.
        black = getColor "black";
        red = getColor "red";
        green = getColor "green";
        yellow = getColor "yellow";
        blue = getColor "blue";
        magenta = getColor "magenta";
        cyan = getColor "cyan";
        white = getColor "white";

        brightBlack = getColor "brightBlack";
        brightRed = getColor "brightRed";
        brightGreen = getColor "brightGreen";
        brightYellow = getColor "brightYellow";
        brightBlue = getColor "brightBlue";
        brightMagenta = getColor "brightMagenta";
        brightCyan = getColor "brightCyan";
        brightWhite = getColor "brightWhite";

        # Non-standard.
        grey = getColor "grey";
        orange = getColor "orange";
        brightOrange = getColor "brightOrange";
        violet = getColor "violet";
        brightViolet = getColor "brightViolet";

        # GUI.
        background = getColor "background";
        foreground = getColor "foreground";
        cursor = getColor "cursor";
        base0 = getColor "base0";
        base1 = getColor "base1";
        base2 = getColor "base2";
        base3 = getColor "base3";
        base4 = getColor "base4";
        base5 = getColor "base5";
        base6 = getColor "base6";
        base7 = getColor "base7";
        base8 = getColor "base8";
        base9 = getColor "base9";
        base10 = getColor "base10";
        base11 = getColor "base11";
        base12 = getColor "base12";
        base13 = getColor "base13";
        base14 = getColor "base14";
      };
    };

  mkTheme = mkTheme' cfg.themes.default;
in

{
  # Options.
  options.modules.themes = with types; {
    theme = mkOption {
      type = oneOf [ str (submodule themeOptions) ];
      default = "superpaintman";
      description = mkDoc ''
        The theme to use.
      '';
      apply = v:
        if isString v
        then cfg.themes.${v}
        else v;
    };

    themes = mkOption {
      type = attrsOf (submodule themeOptions);
      default = { };
      description = mkDoc ''
        The set of available themes.
      '';
    };
  };

  # Config.
  config = {
    modules.themes.themes.default = { };

    modules.themes.themes.superpaintman = mkTheme {
      colors = rec {
        # ANSI colors.
        black.color = base1.color;
        red.color = "#FF6C6B";
        green.color = "#98C379";
        yellow.color = "#ECBE7B";
        blue.color = "#51AFEF";
        magenta.color = "#C678DD";
        cyan.color = "#46D9FF";
        white.color = base12.color;

        brightBlack.color = base5.color;
        brightRed.color = "#FF8584";
        brightGreen.color = "#B1DC92";
        brightYellow.color = "#FFD794";
        brightBlue.color = "#6AC8FF";
        brightMagenta.color = "#DF91F6";
        brightCyan.color = "#5FF2FF";
        brightWhite.color = base14.color;

        # Non-standard.
        grey.color = brightBlack.color;
        orange.color = "#DA8548";
        brightOrange.color = "#F39E61";
        violet.color = "#A9A1E1";
        brightViolet.color = "#C2BAFA";

        # GUI.
        background.color = base3.color;
        foreground.color = base11.color;
        cursor.color = base12.color;
        base0.color  = "#000000";
        base1.color  = "#00030B";
        base2.color  = "#141820";
        base3.color  = "#282C34";
        base4.color  = "#3C4048";
        base5.color  = "#51555D";
        base6.color  = "#656971";
        base7.color  = "#7A7E86";
        base8.color  = "#8E929A";
        base9.color  = "#A2A6AE";
        base10.color = "#B7BBC3";
        base11.color = "#CBCFD7";
        base12.color = "#E0E4EC";
        base13.color = "#F4F8FF";
        base14.color = "#FFFFFF";
      };
    };
  };
}
