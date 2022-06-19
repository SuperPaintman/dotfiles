# See: https://macromates.com/manual/en/language_grammars
# See: https://code.visualstudio.com/api/language-extensions/syntax-highlight-guide#semantic-theming
# See: https://www.sublimetext.com/docs/scope_naming.html

{ stdenv, lib, callPackage, runCommand, applications, colors }:
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
          lib.flatten (
            map
              (suffix: map (variant: "${variant}${suffix}") variants)
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

  escapeXML = value: value; # TODO(SuperPaintman): implement it.

  toTMTheme' = indent: value:
    with builtins;
    if isAttrs value
    then
      ''
              ${indent}<dict>
              ${lib.concatStringsSep "\n" (lib.mapAttrsToList
        (key: value:
              ''
              ${indent}  <key>${escapeXML key}</key>
              ${toTMTheme' "${indent}  " value}''
              )
        value)}
              ${indent}</dict>''
    else if isList value
    then
      ''
              ${indent}<array>
              ${lib.concatStringsSep "\n" (map
        (value:
              ''
              ${toTMTheme' "${indent}  " value}''
              )
        value)}
              ${indent}</array>''
    else if isString value
    then
      ''
        ${indent}<string>${escapeXML value}</string>''
    else throw "cannot convert a ${typeOf value} to TextMate Theme XML";

  toTMTheme = value:
    ''
      <?xml version="1.0" encoding="UTF-8"?>
      <!DOCTYPE plist PUBLIC "-//Apple Computer//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">

      <plist version="1.2">
      ${toTMTheme' "" value}
      </plist>
    '';

  normalizeRule = rule:
    let
      inherit (rule) settings;

      styles = {
        bold = false;
        italic = false;
        underline = false;
        strikethrough = false;
      } // settings;
    in
    {
      inherit (rule) name;

      scope = lib.concatStringsSep ", " (lib.flatten rule.scope);

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

  normalizeRules = map normalizeRule;

  writeTextmateThemeFile =
    { name, author, uuid, semanticClass, comment ? null }:
    let
      themeTMTheme = {
        inherit author name uuid semanticClass;

        colorSpaceName = "sRGB";

        settings = [
          {
            settings = lib.mapAttrs (k: v: v.gui) applications.textmate.globals;
          }
        ]
        ++ (normalizeRules applications.textmate.rules);
      }
      // (lib.optionalAttrs (comment != null) { inherit comment; });
    in
    runCommand "${name}.tmTheme"
      {
        preferLocalBuild = true;
        allowSubstitutes = false;

        theme = toTMTheme themeTMTheme;

        passAsFile = [ "theme" ];

        passthru = {
          theme = themeTMTheme;
        };
      } ''
      cp "$themePath" "$out"
    '';
in
{
  inherit writeTextmateThemeFile;

  globals = with colors; {
    inherit background foreground;
  };

  rules = with colors; with syntax;
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
