# See: https://github.com/akamud/vscode-theme-onedark
# See: https://github.com/doomemacs/themes/blob/master/themes/doom-one-theme.el
# See: https://github.com/joshdick/onedark.vim/blob/main/colors/onedark.vim

{ callPackages, lib }:
let
  libColors = (callPackages ../../nixos/lib { }).colors;

  colors = with libColors; rec {
    base0 = { gui = "#1B2229"; };
    base1 = { gui = "#1C1F24"; };
    base2 = { gui = "#202328"; };
    base3 = { gui = "#23272E"; };
    base4 = { gui = "#3F444A"; };
    base5 = { gui = "#5B6268"; };
    base6 = { gui = "#73797E"; };
    base7 = { gui = "#9CA0A4"; };
    base8 = { gui = "#DFDFDF"; };

    black = base0;
    white = base8;
    grey = base4;
    red = { gui = "#FF6C6B"; };
    orange = { gui = "#DA8548"; };
    yellow = { gui = "#ECBE7B"; };
    green = { gui = "#98C379"; };
    teal = { gui = "#51AFEF"; };
    cyan = { gui = "#46D9FF"; };
    blue = { gui = "#51AFEF"; };
    magenta = { gui = "#C678DD"; };
    violet = { gui = "#A9A1E1"; };

    background = { gui = "#282C34"; };
    foreground = { gui = "#BBC2CF"; };
    cursor = { gui = brighten 10 foreground.gui; };
  }
  // (
    lib.listToAttrs (
      lib.flatten (
        map
          (
            name: [
              {
                name = "dark-${name}";
                value = {
                  gui = libColors.darken 10 colors.${name}.gui;
                };
              }
              {
                name = "bright-${name}";
                value = {
                  gui = libColors.brighten 10 colors.${name}.gui;
                };
              }
            ]
          )
          [
            "red"
            "orange"
            "yellow"
            "green"
            "teal"
            "cyan"
            "blue"
            "magenta"
            "violet"
          ]
      )
    )
  );

  vcs = with colors; rec {
    modified = yellow;
    added = green;
    deleted = red;
    conflicting = magenta;
  };

  syntax = with libColors; with colors; rec {
    # Comment.
    comment = { foreground = base5; };

    # An illegal token, e.g. an ampersand or lower-than character in HTML
    # (which is not part of an entity/tag).
    illegal = { foreground = dark-red; };

    # Various forms of constants.
    constant = { foreground = violet; };

    # A suffix for unit type.
    unit = { foreground = red; };

    # An escape sequences like `\e`.
    escape = constant;

    # A string.
    string = { foreground = green; };

    # An interpolation in a string (e.g. ${} in JS).
    interpolation = { foreground = red; };

    # An placeholder in a string (e.g. %s).
    placeholder = interpolation;

    # A regexp string.
    regexp = { foreground = cyan; };

    # Mainly related to flow control like continue, while, return, etc.
    keyword = { foreground = magenta; };

    # Operators can either be textual (e.g. or) or be characters.
    operator = { foreground = magenta; };

    # A variable.
    variable = { inherit foreground; };

    # A parameter.
    parameter = variable;

    # A function name or a method name.
    function = { foreground = blue; };

    # Name of a type declaration, interface or class.
    type = { foreground = yellow; };

    # Name of a type declaration or class.
    primitive = type;

    # A key-value or a namespace accessor (e.g. `.`, `::`, `:`).
    #
    # TODO(SuperPaintman):
    #     Maybe I should remove this token type and replace it with `operator`;
    accessor = operator;

    # A property name (e.g. a property in json, key in JS object, attribute
    # in HTML).
    property = { foreground = red; };

    # A HTML tag name.
    tag = { foreground = red; };

    # A HTML attribute.
    attribute = { foreground = yellow; };

    # Markup specific syntax.
    markup = {
      heading = { foreground = red; };
      list = { foreground = violet; };
      bold = { foreground = yellow; bold = true; };
      italic = { foreground = yellow; italic = true; };
      underline = { underline = true; };
      strikethrough = { foreground = yellow; strikethrough = true; };
      link = constant // { underline = true; };
      quote = { foreground = violet; italic = true; };
      code = { foreground = magenta; };
      separator = comment;
    };
  };
in
{
  inherit (libColors) lighten brighten darken alpha;
  inherit syntax vcs;
}
  // colors
