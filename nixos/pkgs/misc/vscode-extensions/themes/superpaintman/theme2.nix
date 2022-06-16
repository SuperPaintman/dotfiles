
# See: https://github.com/akamud/vscode-theme-onedark
# See: https://github.com/doomemacs/themes/blob/master/themes/doom-one-theme.el
# See: https://github.com/joshdick/onedark.vim/blob/main/colors/onedark.vim
# See: VS Code > F1 > Developer: Inspect Editor Tokens and Scopes.
#
#     nix-build \
#         -E 'with import <nixpkgs> {}; callPackage ./nixos/pkgs/misc/vscode-extensions { unstable = import <nixos-unstable> {}; }' \
#         -A themes.superpaintman \
#         --out-link "result-vscode-extensions-themes-superpaintman"
#
#     code --extensionDevelopmentPath=$(pwd)/result-vscode-extensions-themes-superpaintman/share/vscode/extensions/SuperPaintman.themes-superpaintman/ -n .

{ pkgs }:
let
  lib =
    if pkgs.lib ? x
    then pkgs.lib
    else
      (pkgs.lib.extend (self: super: {
        x = pkgs.callPackage ../../../../../lib { lib = self; };
      }));

  colors = rec {
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
    cursor = { gui = lib.x.colors.brighten 10 foreground.gui; };
  } // (lib.listToAttrs (lib.flatten (map
    (name: [
      {
        name = "dark-${name}";
        value = {
          gui = lib.x.colors.darken 10 colors.${name}.gui;
        };
      }
      {
        name = "bright-${name}";
        value = {
          gui = lib.x.colors.brighten 10 colors.${name}.gui;
        };
      }
    ])
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
  )));

  theme = {
    terminal = { }; # TODO

    # See: https://code.visualstudio.com/api/references/theme-color
    vscode = with colors; {
      activityBar = {
        background = base2;
        foreground = white;
      };

      activityBarBadge = {
        background = dark-blue;
        foreground = white;
      };

      button = {
        background = dark-blue;
        foreground = white;
        hoverBackground = blue;
      };

      diffEditor = {
        insertedTextBackground = { gui = lib.x.colors.alpha 0.3 green.gui; };
        removedTextBackground = { gui = lib.x.colors.alpha 0.3 red.gui; };
      };

      diffEditorGutter = {
        insertedLineBackground = { gui = lib.x.colors.alpha 0.4 green.gui; };
        removedLineBackground = { gui = lib.x.colors.alpha 0.4 red.gui; };
      };

      diffEditorOverview = {
        insertedForeground = green;
        removedForeground = red;
      };

      dropdown = {
        background = base2;
        foreground = white;
      };

      editorIndentGuide = {
        background = { gui = lib.x.colors.alpha 0.05 foreground.gui; };
        activeBackground = { gui = lib.x.colors.alpha 0.2 foreground.gui; };
      };

      editor = {
        inherit background foreground;
        lineHighlightBackground = { gui = lib.x.colors.alpha 0.05 foreground.gui; };
        selectionBackground = { gui = lib.x.colors.alpha 0.2 foreground.gui; };
        findMatchHighlightBackground = { gui = lib.x.colors.alpha 0.4 blue.gui; };
      };

      editorCursor = {
        foreground = cursor;
      };

      editorGroupHeader = {
        tabsBackground = base2;
      };

      editorGutter = {
        addedBackground = green;
        modifiedBackground = blue;
        deletedBackground = red;
      };

      editorLineNumber = {
        foreground = base5;
        activeForeground = base7;
      };

      editorWhitespace = {
        foreground = base4;
      };

      editorRuler = {
        foreground = base4;
      };

      editorHoverWidget = {
        background = base3;
        foreground = white;
        border = { gui = "#00000000"; };
      };

      editorSuggestWidget  = {
        background = base3;
        foreground = white;
        border = { gui = "#00000000"; };
        selectedBackground = base4;
      };

      editorWidget = {
        background = base3;
        foreground = white;
        border = { gui = "#00000000"; };
      };

      gitDecoration = {
        addedResourceForeground = green;
        modifiedResourceForeground = yellow;
        deletedResourceForeground = red;
        renamedResourceForeground = blue;
        stageModifiedResourceForeground = green;
        stageDeletedResourceForeground = red;
        untrackedResourceForeground = green;
        ignoredResourceForeground = grey;
        conflictingResourceForeground = magenta;
        submoduleResourceForeground = { gui = "#00FF00"; }; # TODO
      };

      input = {
        background = base4;
        foreground = white;
        placeholderForeground = base7;
        border = base3;
      };

      focusBorder = dark-blue;

      list = {
        activeSelectionBackground = base4;
        activeSelectionForeground = white;
        focusBackground = { gui = lib.x.colors.alpha 0.2 foreground.gui; };
        hoverBackground = { gui = lib.x.colors.alpha 0.05 foreground.gui; };
        highlightForeground = dark-blue;
        inactiveSelectionBackground = { gui = lib.x.colors.alpha 0.02 foreground.gui; };
        inactiveSelectionForeground = base7;
      };

      notification = {
        background = red; # TODO
      };

      scrollbarSlider = {
        background = base4;
        hoverBackground = base5;
        activeBackground = base6;
      };

      sideBar = {
        background = base3;
        foreground = white;
      };

      sideBarSectionHeader = {
        background = base2;
        foreground = white;
      };

      statusBar = {
        background = red; # TODO
        foreground = white;
        noFolderBackground = red; # TODO
        debuggingForeground = green; # TODO
        debuggingBackground = red; # TODO
      };

      statusBarItem = {
        hoverBackground = dark-blue;
      };

      tab = {
        activeBackground = background;
        activeForeground = white;
        inactiveBackground = base2;
        border = base1;
      };

      titleBar = {
        activeBackground = red; # TODO
        activeForeground = green; # TODO
      };

      badge = {
        background = dark-blue;
        foreground = white;
      };

      widget = {
        shadow = { gui = lib.x.colors.alpha 0.03 black; };
      };
    };

    tokens = with colors; rec {
      comment = base5;
      keyword = magenta;
      operator = magenta;
      punctuation = magenta; # TODO: rename it.
      constant = dark-yellow;
      variable = violet;
      string = green;
      type = blue;
      function = blue;
    };
  };
in
{
  author = "SuperPaintman";
  name = "SuperPaintman";
  colors = theme.vscode;
  tokenColors = [
    {
      name = "Comment";
      scope = "comment";
      settings = {
        foreground = theme.tokens.comment.gui;
        fontStyle = "italic";
      };
    }
    {
      name = "Keyword";
      scope = "keyword";
      settings = {
        foreground = theme.tokens.keyword.gui;
      };
    }
    {
      name = "Keyword Operator";
      scope = "keyword.operator";
      settings = {
        foreground = theme.tokens.operator.gui;
      };
    }
    {
      name = "Storage";
      scope = "storage";
      settings = {
        foreground = theme.tokens.keyword.gui;
      };
    }
    {
      name = "Constant";
      scope = "constant";
      settings = {
        foreground = theme.tokens.constant.gui;
      };
    }
    # TODO: constant.character.escape
    {
      name = "Variable";
      scope = [
        "variable"
      ];
      settings = {
        foreground = theme.tokens.variable.gui;
      };
    }
    {
      name = "String";
      scope = "string";
      settings = {
        foreground = theme.tokens.string.gui;
      };
    }
    # TODO: String > source and String Embedded
    # TODO: Regexp
    {
      name = "Punctuation";
      scope = [
        "punctuation.separator.key-value"
        "punctuation.other.colon"
        "punctuation.other.period"
      ];
      settings = {
        foreground = theme.tokens.punctuation.gui;
      };
    }
    {
      name = "Support Type";
      scope = [
        "support.type"
        "source.go storage.type"
        "source.rust entity.name.type"
      ];
      settings = {
        foreground = theme.tokens.type.gui;
      };
    }
    {
      name = "Support Function";
      scope = [
        "entity.name.function"
      ];
      settings = {
        foreground = theme.tokens.function.gui;
      };
    }
  ];
}
