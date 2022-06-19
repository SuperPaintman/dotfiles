# See: https://macromates.com/manual/en/language_grammars
# See: https://code.visualstudio.com/api/language-extensions/syntax-highlight-guide#semantic-theming
# See: https://www.sublimetext.com/docs/scope_naming.html
#
# See: VS Code > F1 > Developer: Inspect Editor Tokens and Scopes.
#
#     nix-build \
#         -E 'with import <nixpkgs> {}; callPackage ./nixos/pkgs/misc/vscode-extensions { unstable = import <nixos-unstable> {}; }' \
#         -A themes.superpaintman \
#         --out-link "result-vscode-extensions-themes-superpaintman"
#
#     code --extensionDevelopmentPath=$(pwd)/result-vscode-extensions-themes-superpaintman/share/vscode/extensions/SuperPaintman.themes-superpaintman/ -n .

{ pkgs, stdenv, lib, callPackage, runCommand, applications, colors }:
let
  normalizeColors' = prefix: set:
    let
      names = builtins.attrNames set;
    in
    lib.flatten (
      map
        (name:
          let
            value = set.${name};
          in
          if value ? gui && builtins.isString value.gui
          then [{ name = "${prefix}${name}"; value = value.gui; }]
          else normalizeColors' "${prefix}${name}." value
        )
        names
    );

  normalizeColors = set: builtins.listToAttrs (normalizeColors' "" set);

  normalizeTokenColor = color:
    let
      inherit (color) settings;

      styles = {
        bold = false;
        italic = false;
        underline = false;
        strikethrough = false;
      } // settings;
    in
    {
      inherit (color) name;
      scope = lib.flatten color.scope;
      settings =
        (lib.optionalAttrs (settings ? foreground) { foreground = settings.foreground.gui; })
        // (lib.optionalAttrs (settings ? background) { background = settings.background.gui; })
        // (lib.optionalAttrs (lib.any (v: builtins.isBool v && v) (lib.attrValues styles)) {
          fontStyle = lib.concatStringsSep " " (
            (lib.optional (styles.italic) "italic")
            ++ (lib.optional (styles.bold) "bold")
            ++ (lib.optional (styles.underline) "underline")
            ++ (lib.optional (styles.strikethrough) "strikethrough")
          );
        });
    };

  normalizeTokenColors = colors: map normalizeTokenColor colors;

  writeVscodeThemeFile =
    { name, author }:
    let
      themeJSON = {
        inherit author name;

        colors = normalizeColors applications.vscode.colors;

        tokenColors = normalizeTokenColors applications.vscode.tokenColors;
      };
    in
    runCommand "${name}.json"
      {
        buildInputs = with pkgs; [ jq ];

        preferLocalBuild = true;
        allowSubstitutes = false;

        theme = builtins.toJSON themeJSON;

        passAsFile = [ "theme" ];

        passthru = {
          theme = themeJSON;
        };
      } ''
      cat "$themePath" | jq . > "$out"
    '';

  # See: https://github.com/NixOS/nixpkgs/blob/master/pkgs/applications/editors/vscode/extensions/vscode-utils.nix
  buildVscodeTheme =
    { name
    , publisher
    , displayName
    , version ? "0.1.0"
    , categories ? [ "Themes" ]
    , private ? true
    , description ? null
    , icon ? null
    , copyIcon ? true
    , engines ? { }
    , package ? { }
    }:
    let
      packageJSON =
        {
          engines.vscode = "^1.12.0";
          contributes.themes = [
            {
              label = name;
              uiTheme = "vs-dark";
              path = "./themes/theme.json";
            }
          ];
        }
        // {
          inherit name publisher displayName version categories private;
        }
        // (lib.optionalAttrs (description != null) { inherit description; })
        // (lib.optionalAttrs (icon != null) {
          icon = if copyIcon then "./icon.png" else icon;
        })
        // package;

      vscodeExtUniqueId = "${publisher}.${name}";
    in
    stdenv.mkDerivation {
      inherit vscodeExtUniqueId icon copyIcon;

      name = "vscode-extension-${publisher}-${name}-${version}";

      installPrefix = "share/vscode/extensions/${vscodeExtUniqueId}";

      buildInputs = with pkgs; [ jq remarshal ];

      dontUnpack = true;
      dontPatchELF = true;
      dontStrip = true;

      theme = writeVscodeThemeFile {
        inherit name;
        author = publisher;
      };

      package = builtins.toJSON packageJSON;

      passAsFile = [ "package" ];

      buildPhase = ''
        mkdir -p extension/{themes,}

        cat "$packagePath" | jq . > extension/package.json

        cp "$theme" extension/themes/theme.json
        json2yaml  extension/themes/theme.json extension/themes/theme.yml

        if [ "$icon" != "" ] && [ "$copyIcon" != "" ]; then
          cp "$icon" extension/icon.png
        fi
      '';

      installPhase = ''
        runHook preInstall

        mkdir -p "$out/$installPrefix"
        find extension -mindepth 1 -maxdepth 1 | xargs -d'\n' mv -t "$out/$installPrefix/"

        runHook postInstall
      '';

      passthru = {
        package = packageJSON;
      };
    };
in
{
  inherit writeVscodeThemeFile buildVscodeTheme;

  colors = with colors; with vcs; {
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
      insertedTextBackground = { gui = alpha 0.3 added.gui; };
      removedTextBackground = { gui = alpha 0.3 deleted.gui; };
    };

    diffEditorGutter = {
      insertedLineBackground = { gui = alpha 0.4 added.gui; };
      removedLineBackground = { gui = alpha 0.4 deleted.gui; };
    };

    diffEditorOverview = {
      insertedForeground = added;
      removedForeground = deleted;
    };

    dropdown = {
      background = base2;
      foreground = white;
    };

    editorIndentGuide = {
      background = { gui = alpha 0.05 foreground.gui; };
      activeBackground = { gui = alpha 0.2 foreground.gui; };
    };

    editor = {
      inherit background foreground;
      lineHighlightBackground = { gui = alpha 0.05 foreground.gui; };
      selectionBackground = { gui = alpha 0.2 foreground.gui; };
      findMatchHighlightBackground = { gui = alpha 0.4 blue.gui; };
    };

    editorCursor = {
      foreground = cursor;
    };

    editorGroupHeader = {
      tabsBackground = base2;
    };

    editorGutter = {
      addedBackground = added;
      modifiedBackground = modified;
      deletedBackground = deleted;
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

    editorSuggestWidget = {
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
      addedResourceForeground = added;
      modifiedResourceForeground = modified;
      deletedResourceForeground = deleted;
      renamedResourceForeground = blue;
      stageModifiedResourceForeground = modified;
      stageDeletedResourceForeground = deleted;
      untrackedResourceForeground = blue;
      ignoredResourceForeground = grey;
      conflictingResourceForeground = conflicting;
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
      focusBackground = { gui = alpha 0.2 foreground.gui; };
      hoverBackground = { gui = alpha 0.05 foreground.gui; };
      highlightForeground = dark-blue;
      inactiveSelectionBackground = { gui = alpha 0.02 foreground.gui; };
      inactiveSelectionForeground = base7;
    };

    notification = {
      background = red; # TODO
    };

    scrollbarSlider = {
      background = { gui = alpha 0.2 base5.gui; };
      hoverBackground = { gui = alpha 0.4 base5.gui; };
      activeBackground = { gui = alpha 0.5 base5.gui; };
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
      activeBackground = base2;
      activeForeground = white;
      inactiveBackground = base2;
      inactiveForeground = grey;
      border = { gui = "#00000000"; };
    };

    badge = {
      background = dark-blue;
      foreground = white;
    };

    widget = {
      shadow = { gui = alpha 0.03 black; };
    };
  };

  tokenColors = applications.textmate.rules;
}
