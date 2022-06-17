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
  langs =
    let
      comb = groups:
        if (builtins.length groups) == 0
        then [ "" ]
        else
          let
            head = lib.head groups;
            tail = lib.tail groups;
            variants =
              if builtins.isList head
              then head
              else [ head ];
          in
          # comb' prefix tail;
          lib.flatten (
            map
              (suffix:
                map
                  (variant:
                    "${variant}${suffix}"
                  )
                  variants
              )
              (comb tail)
          );

      source = [ "source." "meta.embedded.block." ];

      lang = names: variants: comb [ source names " " variants ];
    in
    {
      inherit lang;

      c = lang "c";
      css = lang "css";
      go = lang "go";
      html = variants: comb [ [ "text.html" "meta.embedded.block.html" ] " " variants ];
      javascript = lang [ "js" "javascript" "jsx" "ts" "typescript" "tsx" ];
      json = lang "json";
      markdown = variants: comb [ [ "text.html.markdown" "meta.embedded.block.markdown" ] " " variants ];
      nix = lang "nix";
      rust = lang "rust";
      shell = lang [ "shell" "shellscript" ];
      toml = lang "toml";
      yaml = lang "yaml";
    };

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
      shadow = { gui = alpha 0.03 black; };
    };
  };

  tokenColors = with colors; with syntax;
    let
      reset = {
        inherit foreground;
      };

      __debug__1 = { foreground = { gui = "#FF0000"; }; underline = true; };
      __debug__2 = { foreground = { gui = "#00FF00"; }; underline = true; };
      __debug__3 = { foreground = { gui = "#0000FF"; }; underline = true; };
    in
    [
      # Comment.
      {
        name = "Comment";
        scope = [
          "comment"
        ];
        settings = comment;
      }

      # Illegal.
      {
        name = "Illegal";
        scope = [
          "invalid.illegal"
        ];
        settings = illegal;
      }

      # Constant.
      {
        name = "Constant";
        scope = [
          "constant"
          "support.constant"

          # C.
          (langs.c [
            # C - hexademical prefixes.
            "keyword.other.unit.hexadecimal"

            # C - characters.
            "string.quoted.single"
          ])

          # Rust - characters.
          (langs.rust "string.quoted.single")
        ];
        settings = constant;
      }

      # Unit.
      {
        name = "Unit";
        scope = [
          "keyword.other.unit"

          # CSS - hex colors.
          (langs.css "punctuation.definition.constant")

          # Rust.
          (langs.rust "constant.numeric entity.name.type.numeric")
        ];
        settings = unit;
      }

      # Escape.
      {
        name = "Escape";
        scope = [
          "constant.character.escape"
        ];
        settings = escape;
      }

      # String.
      {
        name = "String";
        scope = [
          "string"

          # CSS.
          (langs.css [
            "entity.other.attribute-name.class"
            "variable.parameter.url"
            "support.constant.font-name"
          ])

          # C - characters.
          (langs.c "string.quoted.single punctuation.definition")

          # Rust - characters.
          (langs.rust "string.quoted.single punctuation.definition")

          # Go - imports.
          (langs.go "string.quoted entity.name.import")
        ];
        settings = string;
      }

      # Interpolation.
      {
        name = "Interpolation";
        scope = [
          "punctuation.section.embedded"

          # Shell.
          (langs.shell "string variable")

          # JavaScript  / TypeScript- template strings.
          (langs.javascript "punctuation.definition.template-expression")
        ];
        settings = interpolation;
      }

      {
        name = "Interpolation: content";
        scope = [
          "meta.embedded"
        ];
        settings = reset;
      }

      # Placeholder.
      {
        name = "Placeholder";
        scope = [
          "constant.other.placeholder"

          # Rust.
          (langs.rust "meta.interpolation")
        ];
        settings = syntax.placeholder;
      }

      # Regexp.
      {
        name = "Regexp";
        scope = [
          "string.regexp"
        ];
        settings = regexp;
      }

      # Keyword.
      {
        name = "Keyword";
        scope = [
          "keyword"
        ];
        settings = keyword;
      }

      {
        name = "Keyword: declarations";
        scope = [
          "storage"

          # C.
          (langs.c [
            "storage.type.struct"
            "storage.type.enum"
          ])

          # Go.
          (langs.go [
            "keyword.function"
            "keyword.type"
            "keyword.interface"
            "keyword.struct"
            "keyword.map"
            "keyword.channel"
          ])

          # Rust.
          (langs.rust [
            "storage.type"
            "keyword.other"
          ])

          # JavaScript / TypeScript.
          (langs.javascript "storage.type")
        ];
        settings = keyword;
      }

      {
        name = "Keyword: modifiers";
        scope = [
          "storage.modifier"

          # Rust.
          (langs.rust [
            "punctuation.definition.attribute"
            "punctuation.brackets.attribute"
          ])
        ];
        settings = keyword;
      }

      # Operator.
      {
        name = "Operator";
        scope = [
          "keyword.operator"
        ];
        settings = operator;
      }

      # Variable.
      {
        name = "Variable";
        scope = [
          "variable"
          "support.variable.property"

          # YAML.
          (langs.yaml "entity.name.type.anchor")

          # Rust.
          (langs.rust "meta.attribute")

          # Nix.
          (langs.nix [
            "variable.parameter.name"
            "entity.other.attribute-name"
          ])
        ];
        settings = variable;
      }

      # Parameter.
      {
        name = "Parameter";
        scope = [
          "variable.parameter"

          # Rust.
          (langs.rust "meta.function.definition variable.other")

          # Nix.
          (langs.nix "variable.parameter.function")
        ];
        settings = parameter;
      }

      # Function.
      {
        name = "Function";
        scope = [
          "variable.function"
          "entity.name.function"
          "support.function"

          # Go.
          (langs.go "support.function")

          # YAML.
          (langs.yaml [
            "constant.language.merge"
            "storage.type.tag-handle"
          ])
        ];
        settings = function;
      }

      # Type.
      {
        name = "Type";
        scope = [
          "storage.type"
          "entity.name"
          "entity.other.inherited-class"
          "support.class"
        ];
        settings = type;
      }

      # Primitive.
      {
        name = "Primitive";
        scope = [
          "support.type"

          # C.
          (langs.c [
            "storage.type.built-in"
            "storage.modifier.array"
          ])

          # Go.
          (langs.go "storage.type")

          # Rust.
          (langs.rust [
            "entity.name.type.numeric"
            "entity.name.type.primitive"
          ])
        ];
        settings = primitive;
      }

      # Accessor.
      {
        name = "Accessor";
        scope = [
          "punctuation.accessor"

          # CSS.
          (langs.css [
            "entity.other.attribute-name.pseudo-class punctuation.definition.entity"
            "entity.other.attribute-name.pseudo-element punctuation.definition.entity"
          ])

          # Go.
          (langs.go "punctuation.other.period")

          # Rust.
          (langs.rust [
            "keyword.operator.access"
            "keyword.operator.namespace"
          ])
        ];
        settings = accessor;
      }

      # Property.
      {
        name = "Property";
        scope = [
          "variable.other.member"
          "support.type.property-name"

          # JSON.
          (langs.json "support.type.property-name")

          # YAML.
          (langs.yaml "entity.name.tag")

          # TOML.
          (langs.toml "variable.key")

          # JavaScript / TypeScript.
          (langs.javascript [
            "variable.object.property"
            "meta.object-literal.key"
          ])
        ];
        settings = property;
      }

      # Tag.
      {
        name = "Tag";
        scope = [
          "entity.name.tag"

          # CSS.
          "meta.selector.css"
        ];
        settings = tag;
      }

      # Attribute.
      {
        name = "Attribute";
        scope = [
          "entity.other.attribute-name"

          # CSS.
          (langs.css "ntity.other.attribute-name.id punctuation.definition.entity")
        ];
        settings = attribute;
      }

      # Markup.
      # See: https://www.sublimetext.com/docs/scope_naming.html#markup
      {
        name = "Markup: heading";
        scope = [
          "markup.heading"
          "markup.heading entity.name"
        ];
        settings = markup.heading;
      }

      {
        name = "Markup: list";
        scope = [
          "markup.list punctuation.definition.list"
        ];
        settings = markup.list;
      }

      {
        name = "Markup: bold";
        scope = [
          "markup.bold"
        ];
        settings = markup.bold;
      }

      {
        name = "Markup: italic";
        scope = [
          "markup.italic"
        ];
        settings = markup.italic;
      }

      {
        name = "Markup: underline";
        scope = [
          "markup.underline"
        ];
        settings = markup.underline;
      }

      {
        name = "Markup: strikethrough";
        scope = [
          "markup.strikethrough"
        ];
        settings = markup.strikethrough;
      }

      {
        name = "Markup: quote";
        scope = [
          "markup.quote"
        ];
        settings = markup.quote;
      }

      {
        name = "Markup: link";
        scope = [
          "markup.underline.link"
        ];
        settings = markup.link;
      }

      {
        name = "Markup: code";
        scope = [
          "markup.inline.raw"
          "markup.raw"

          # Markdown.
          (langs.markdown [
            "markup.fenced_code punctuation.definition.markdown"
            "markup.fenced_code fenced_code.block.language"
          ])
        ];
        settings = markup.code;
      }

      {
        name = "Markup: separator";
        scope = [
          # Markdown.
          (langs.markdown "text.html.markdown meta.separator")
        ];
        settings = markup.separator;
      }

      # Fixes.
      {
        name = "Separators"; # (e.g. :).
        scope = [
          "punctuation.separator.key-value"

          # HTML.
          (langs.html "meta.tag")

          # CSS.
          (langs.css [
            "punctuation.definition.entity.begin.bracket"
            "punctuation.definition.entity.end.bracket"
          ])

          # Rust.
          (langs.rust "keyword.operator.key-value")

          # JavaScript / TypeScript.
          (langs.javascript [
            "punctuation.separator.key-value"
            "keyword.operator.type.annotation"
          ])
        ];
        settings = reset;
      }
    ];
}
