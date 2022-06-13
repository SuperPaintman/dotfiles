# See: https://github.com/akamud/vscode-theme-onedark.
# See: VS Code > F1 > Developer: Inspect Editor Tokens and Scopes.

{}:
let
  colors = {
    black = "#282C34";
    white = "#ABB2BF";
    comment_grey = "#5C6370";
    yellow = "#E5C07B";
    purple = "#C678DD";
    blue = "#61AFEF";
    dark-yellow = "#D19A66";
    cyan = "#56B6C2";
    red = "#E06C75";
    dark-red = "#BE5046";
    green = "#98C379";
  };
in
{
  author = "SuperPaintman";
  name = "SuperPaintman";
  colors = {
    activityBar = {
      background = "#333842" /* TODO */;
      foreground = "#D7DAE0" /* TODO */;
    };
    activityBarBadge = {
      background = "#528BFF" /* TODO */;
      foreground = "#D7DAE0" /* TODO */;
    };
    button = {
      background = "#4D78CC" /* TODO */;
      foreground = "#FFFFFF" /* TODO */;
      hoverBackground = "#6087CF" /* TODO */;
    };
    diffEditor = {
      insertedTextBackground = "#00809B33" /* TODO */;
    };
    dropdown = {
      background = "#353b45" /* TODO */;
      border = "#181A1F" /* TODO */;
    };
    editorIndentGuide = {
      activeBackground = "#626772" /* TODO */;
      background = "#ABB2BF26" /* TODO */;
    };
    editor = {
      background = colors.black;
      foreground = colors.white;
      lineHighlightBackground = "#99BBFF0A" /* TODO */;
      selectionBackground = "#3E4451" /* TODO */;
      findMatchHighlightBackground = "#528BFF3D" /* TODO */;
    };
    editorCursor = {
      foreground = "#528BFF" /* TODO */;
    };
    editorGroup = {
      background = "#21252B" /* TODO */;
      border = "#181A1F" /* TODO */;
    };
    editorGroupHeader = {
      tabsBackground = "#21252B" /* TODO */;
    };
    editorLineNumber = {
      foreground = "#636D83" /* TODO */;
      activeForeground = colors.white;
    };
    editorWhitespace = {
      foreground = "#ABB2BF26" /* TODO */;
    };
    editorRuler = {
      foreground = "#ABB2BF26" /* TODO */;
    };
    editorHoverWidget = {
      background = "#21252B" /* TODO */;
      border = "#181A1F" /* TODO */;
    };
    editorSuggestWidget = {
      background = "#21252B" /* TODO */;
      border = "#181A1F" /* TODO */;
      selectedBackground = "#2C313A" /* TODO */;
    };
    editorWidget = {
      background = "#21252B" /* TODO */;
      border = "#3A3F4B" /* TODO */;
    };
    input = {
      background = "#1B1D23" /* TODO */;
      border = "#181A1F" /* TODO */;
    };
    focusBorder = "#528BFF" /* TODO */;
    list = {
      activeSelectionBackground = "#2C313A" /* TODO */;
      activeSelectionForeground = "#D7DAE0" /* TODO */;
      focusBackground = "#2C313A" /* TODO */;
      hoverBackground = "#2C313A66" /* TODO */;
      highlightForeground = "#D7DAE0" /* TODO */;
      inactiveSelectionBackground = "#2C313A" /* TODO */;
      inactiveSelectionForeground = "#D7DAE0" /* TODO */;
    };
    notification = {
      background = "#21252B" /* TODO */;
    };
    pickerGroup = {
      border = "#528BFF" /* TODO */;
    };
    scrollbarSlider = {
      background = "#4E566680" /* TODO */;
      activeBackground = "#747D9180" /* TODO */;
      hoverBackground = "#5A637580" /* TODO */;
    };
    sideBar = {
      background = "#21252B" /* TODO */;
    };
    sideBarSectionHeader = {
      background = "#333842" /* TODO */;
    };
    statusBar = {
      background = "#21252B" /* TODO */;
      foreground = "#9DA5B4" /* TODO */;
      noFolderBackground = "#21252B" /* TODO */;
      debuggingForeground = "#FFFFFF" /* TODO */;
    };
    statusBarItem = {
      hoverBackground = "#2C313A" /* TODO */;
    };
    tab = {
      activeBackground = colors.black;
      activeForeground = "#D7DAE0" /* TODO */;
      border = "#181A1F" /* TODO */;
      inactiveBackground = "#21252B" /* TODO */;
    };
    titleBar = {
      activeBackground = "#21252B" /* TODO */;
      activeForeground = "#9DA5B4" /* TODO */;
      inactiveBackground = "#21252B" /* TODO */;
      inactiveForeground = "#9DA5B4" /* TODO */;
    };
    extensionButton = {
      prominentBackground = "#2BA143" /* TODO */;
      prominentHoverBackground = "#37AF4E" /* TODO */;
    };
    badge = {
      background = "#528BFF" /* TODO */;
      foreground = "#D7DAE0" /* TODO */;
    };
    peekView = {
      border = "#528BFF" /* TODO */;
    };
    peekViewResult = {
      background = "#21252B" /* TODO */;
      selectionBackground = "#2C313A" /* TODO */;
    };
    peekViewTitle = {
      background = "#1B1D23" /* TODO */;
    };
    peekViewEditor = {
      background = "#1B1D23" /* TODO */;
    };
  };
  tokenColors = [
    {
      name = "Comment";
      scope = [
        "comment"
      ];
      settings = {
        foreground = colors.comment_grey;
        fontStyle = "italic";
      };
    }
    {
      name = "Comment Markup Link";
      scope = [
        "comment markup.link"
      ];
      settings = {
        foreground = colors.comment_grey;
      };
    }
    {
      name = "Entity Name Type";
      scope = [
        "entity.name.type"
      ];
      settings = {
        foreground = colors.yellow;
      };
    }
    {
      name = "Entity Other Inherited Class";
      scope = [
        "entity.other.inherited-class"
      ];
      settings = {
        foreground = colors.yellow;
      };
    }
    {
      name = "Keyword";
      scope = [
        "keyword"
      ];
      settings = {
        foreground = colors.purple;
      };
    }
    {
      name = "Keyword Control";
      scope = [
        "keyword.control"
      ];
      settings = {
        foreground = colors.purple;
      };
    }
    {
      name = "Keyword Operator";
      scope = [
        "keyword.operator"
      ];
      settings = {
        foreground = colors.purple;
      };
    }
    {
      name = "Keyword Other Special Method";
      scope = [
        "keyword.other.special-method"
      ];
      settings = {
        foreground = colors.blue;
      };
    }
    {
      name = "Keyword Other Unit";
      scope = [
        "keyword.other.unit"
      ];
      settings = {
        foreground = colors.dark-yellow;
      };
    }
    {
      name = "Storage";
      scope = [
        "storage"
      ];
      settings = {
        foreground = colors.purple;
      };
    }
    {
      name = "Storage Type Annotation,storage Type Primitive";
      scope = [
        "storage.type.annotation"
        "storage.type.primitive"
      ];
      settings = {
        foreground = colors.purple;
      };
    }
    {
      name = "Storage Modifier Package,storage Modifier Import";
      scope = [
        "storage.modifier.package"
        "storage.modifier.import"
      ];
      settings = {
        foreground = colors.white;
      };
    }
    {
      name = "Constant";
      scope = [
        "constant"
      ];
      settings = {
        foreground = colors.dark-yellow;
      };
    }
    {
      name = "Constant Variable";
      scope = [
        "constant.variable"
      ];
      settings = {
        foreground = colors.dark-yellow;
      };
    }
    {
      name = "Constant Character Escape";
      scope = [
        "constant.character.escape"
      ];
      settings = {
        foreground = colors.cyan;
      };
    }
    {
      name = "Constant Numeric";
      scope = [
        "constant.numeric"
      ];
      settings = {
        foreground = colors.dark-yellow;
      };
    }
    {
      name = "Constant Other Color";
      scope = [
        "constant.other.color"
      ];
      settings = {
        foreground = colors.cyan;
      };
    }
    {
      name = "Constant Other Symbol";
      scope = [
        "constant.other.symbol"
      ];
      settings = {
        foreground = colors.cyan;
      };
    }
    {
      name = "Variable";
      scope = [
        "variable"
      ];
      settings = {
        foreground = colors.red;
      };
    }
    {
      name = "Variable Interpolation";
      scope = [
        "variable.interpolation"
      ];
      settings = {
        foreground = colors.dark-red;
      };
    }
    {
      name = "Variable Parameter";
      scope = [
        "variable.parameter"
      ];
      settings = {
        foreground = colors.white;
      };
    }
    {
      name = "String";
      scope = [
        "string"
      ];
      settings = {
        foreground = colors.green;
      };
    }
    {
      name = "String > Source,string Embedded";
      scope = [
        "string > source"
        "string embedded"
      ];
      settings = {
        foreground = colors.white;
      };
    }
    {
      name = "String Regexp";
      scope = [
        "string.regexp"
      ];
      settings = {
        foreground = colors.cyan;
      };
    }
    {
      name = "String Regexp Source Ruby Embedded";
      scope = [
        "string.regexp source.ruby.embedded"
      ];
      settings = {
        foreground = colors.yellow;
      };
    }
    {
      name = "String Other Link";
      scope = [
        "string.other.link"
      ];
      settings = {
        foreground = colors.red;
      };
    }
    {
      name = "Punctuation Definition Comment";
      scope = [
        "punctuation.definition.comment"
      ];
      settings = {
        foreground = colors.comment_grey;
      };
    }
    {
      name = "Punctuation Definition Method Parameters,punctuation Definition Function Parameters,punctuation Definition Parameters,punctuation Definition Separator,punctuation Definition Seperator,punctuation Definition Array";
      scope = [
        "punctuation.definition.method-parameters"
        "punctuation.definition.function-parameters"
        "punctuation.definition.parameters"
        "punctuation.definition.separator"
        "punctuation.definition.seperator"
        "punctuation.definition.array"
      ];
      settings = {
        foreground = colors.white;
      };
    }
    {
      name = "Punctuation Definition Heading,punctuation Definition Identity";
      scope = [
        "punctuation.definition.heading"
        "punctuation.definition.identity"
      ];
      settings = {
        foreground = colors.blue;
      };
    }
    {
      name = "Punctuation Definition Bold";
      scope = [
        "punctuation.definition.bold"
      ];
      settings = {
        foreground = colors.yellow;
        fontStyle = "bold";
      };
    }
    {
      name = "Punctuation Definition Italic";
      scope = [
        "punctuation.definition.italic"
      ];
      settings = {
        foreground = colors.purple;
        fontStyle = "italic";
      };
    }
    {
      name = "Punctuation Section Embedded";
      scope = [
        "punctuation.section.embedded"
      ];
      settings = {
        foreground = colors.dark-red;
      };
    }
    {
      name = "Punctuation Section Method,punctuation Section Class,punctuation Section Inner Class";
      scope = [
        "punctuation.section.method"
        "punctuation.section.class"
        "punctuation.section.inner-class"
      ];
      settings = {
        foreground = colors.white;
      };
    }
    {
      name = "Support Class";
      scope = [
        "support.class"
      ];
      settings = {
        foreground = colors.yellow;
      };
    }
    {
      name = "Support Type";
      scope = [
        "support.type"
      ];
      settings = {
        foreground = colors.cyan;
      };
    }
    {
      name = "Support Function";
      scope = [
        "support.function"
      ];
      settings = {
        foreground = colors.cyan;
      };
    }
    {
      name = "Support Function Any Method";
      scope = [
        "support.function.any-method"
      ];
      settings = {
        foreground = colors.blue;
      };
    }
    {
      name = "Entity Name Function";
      scope = [
        "entity.name.function"
      ];
      settings = {
        foreground = colors.blue;
      };
    }
    {
      name = "Entity Name Class,entity Name Type Class";
      scope = [
        "entity.name.class"
        "entity.name.type.class"
      ];
      settings = {
        foreground = colors.yellow;
      };
    }
    {
      name = "Entity Name Section";
      scope = [
        "entity.name.section"
      ];
      settings = {
        foreground = colors.blue;
      };
    }
    {
      name = "Entity Name Tag";
      scope = [
        "entity.name.tag"
      ];
      settings = {
        foreground = colors.red;
      };
    }
    # {
    #   name = "Entity Other Attribute Name";
    #   scope = [
    #     "entity.other.attribute-name"
    #   ];
    #   settings = {
    #     foreground = colors.dark-yellow;
    #   };
    # }
    {
      name = "Entity Other Attribute Name Id";
      scope = [
        "entity.other.attribute-name.id"
      ];
      settings = {
        foreground = colors.blue;
      };
    }
    {
      name = "Meta Class";
      scope = [
        "meta.class"
      ];
      settings = {
        foreground = colors.yellow;
      };
    }
    {
      name = "Meta Class Body";
      scope = [
        "meta.class.body"
      ];
      settings = {
        foreground = colors.white;
      };
    }
    {
      name = "Meta Method Call,meta Method";
      scope = [
        "meta.method-call"
        "meta.method"
      ];
      settings = {
        foreground = colors.white;
      };
    }
    {
      name = "Meta Definition Variable";
      scope = [
        "meta.definition.variable"
      ];
      settings = {
        foreground = colors.red;
      };
    }
    {
      name = "Meta Link";
      scope = [
        "meta.link"
      ];
      settings = {
        foreground = colors.dark-yellow;
      };
    }
    {
      name = "Meta Require";
      scope = [
        "meta.require"
      ];
      settings = {
        foreground = colors.blue;
      };
    }
    {
      name = "Meta Selector";
      scope = [
        "meta.selector"
      ];
      settings = {
        foreground = colors.purple;
      };
    }
    {
      name = "Meta Separator";
      scope = [
        "meta.separator"
      ];
      settings = {
        foreground = colors.white;
      };
    }
    {
      name = "Meta Tag";
      scope = [
        "meta.tag"
      ];
      settings = {
        foreground = colors.white;
      };
    }
    {
      name = "Underline";
      scope = [
        "underline"
      ];
      settings = {
        text-decoration = "underline";
      };
    }
    {
      name = "None";
      scope = [
        "none"
      ];
      settings = {
        foreground = colors.white;
      };
    }
    {
      name = "Invalid Deprecated";
      scope = [
        "invalid.deprecated"
      ];
      settings = {
        foreground = "#523D14" /* TODO */;
        background = "#E0C285" /* TODO */;
      };
    }
    {
      name = "Invalid Illegal";
      scope = [
        "invalid.illegal"
      ];
      settings = {
        foreground = "white";
        background = "#E05252" /* TODO */;
      };
    }
    {
      name = "Markup Bold";
      scope = [
        "markup.bold"
      ];
      settings = {
        foreground = colors.dark-yellow;
        fontStyle = "bold";
      };
    }
    {
      name = "Markup Changed";
      scope = [
        "markup.changed"
      ];
      settings = {
        foreground = colors.purple;
      };
    }
    {
      name = "Markup Deleted";
      scope = [
        "markup.deleted"
      ];
      settings = {
        foreground = colors.red;
      };
    }
    {
      name = "Markup Italic";
      scope = [
        "markup.italic"
      ];
      settings = {
        foreground = colors.purple;
        fontStyle = "italic";
      };
    }
    {
      name = "Markup Heading";
      scope = [
        "markup.heading"
      ];
      settings = {
        foreground = colors.red;
      };
    }
    {
      name = "Markup Heading Punctuation Definition Heading";
      scope = [
        "markup.heading punctuation.definition.heading"
      ];
      settings = {
        foreground = colors.blue;
      };
    }
    {
      name = "Markup Link";
      scope = [
        "markup.link"
      ];
      settings = {
        foreground = colors.cyan;
      };
    }
    {
      name = "Markup Inserted";
      scope = [
        "markup.inserted"
      ];
      settings = {
        foreground = colors.green;
      };
    }
    {
      name = "Markup Quote";
      scope = [
        "markup.quote"
      ];
      settings = {
        foreground = colors.dark-yellow;
      };
    }
    {
      name = "Markup Raw";
      scope = [
        "markup.raw"
      ];
      settings = {
        foreground = colors.green;
      };
    }
    {
      name = "Source C Keyword Operator";
      scope = [
        "source.c keyword.operator"
      ];
      settings = {
        foreground = colors.purple;
      };
    }
    {
      name = "Source Cpp Keyword Operator";
      scope = [
        "source.cpp keyword.operator"
      ];
      settings = {
        foreground = colors.purple;
      };
    }
    {
      name = "Source Cs Keyword Operator";
      scope = [
        "source.cs keyword.operator"
      ];
      settings = {
        foreground = colors.purple;
      };
    }
    {
      name = "Source Css Property Name,source Css Property Value";
      scope = [
        "source.css property-name"
        "source.css property-value"
      ];
      settings = {
        foreground = "#828997" /* TODO */;
      };
    }
    {
      name = "Source Css Property Name Support,source Css Property Value Support";
      scope = [
        "source.css property-name.support"
        "source.css property-value.support"
      ];
      settings = {
        foreground = colors.white;
      };
    }
    {
      name = "Source Elixir Source Embedded Source";
      scope = [
        "source.elixir source.embedded.source"
      ];
      settings = {
        foreground = colors.white;
      };
    }
    {
      name = "Source Elixir Constant Language,source Elixir Constant Numeric,source Elixir Constant Definition";
      scope = [
        "source.elixir constant.language"
        "source.elixir constant.numeric"
        "source.elixir constant.definition"
      ];
      settings = {
        foreground = colors.blue;
      };
    }
    {
      name = "Source Elixir Variable Definition,source Elixir Variable Anonymous";
      scope = [
        "source.elixir variable.definition"
        "source.elixir variable.anonymous"
      ];
      settings = {
        foreground = colors.purple;
      };
    }
    {
      name = "Source Elixir Parameter Variable Function";
      scope = [
        "source.elixir parameter.variable.function"
      ];
      settings = {
        foreground = colors.dark-yellow;
        fontStyle = "italic";
      };
    }
    {
      name = "Source Elixir Quoted";
      scope = [
        "source.elixir quoted"
      ];
      settings = {
        foreground = colors.green;
      };
    }
    {
      name = "Source Elixir Keyword Special Method,source Elixir Embedded Section,source Elixir Embedded Source Empty";
      scope = [
        "source.elixir keyword.special-method"
        "source.elixir embedded.section"
        "source.elixir embedded.source.empty"
      ];
      settings = {
        foreground = colors.red;
      };
    }
    {
      name = "Source Elixir Readwrite Module Punctuation";
      scope = [
        "source.elixir readwrite.module punctuation"
      ];
      settings = {
        foreground = colors.red;
      };
    }
    {
      name = "Source Elixir Regexp Section,source Elixir Regexp String";
      scope = [
        "source.elixir regexp.section"
        "source.elixir regexp.string"
      ];
      settings = {
        foreground = colors.dark-red;
      };
    }
    {
      name = "Source Elixir Separator,source Elixir Keyword Operator";
      scope = [
        "source.elixir separator"
        "source.elixir keyword.operator"
      ];
      settings = {
        foreground = colors.dark-yellow;
      };
    }
    {
      name = "Source Elixir Variable Constant";
      scope = [
        "source.elixir variable.constant"
      ];
      settings = {
        foreground = colors.yellow;
      };
    }
    {
      name = "Source Elixir Array,source Elixir Scope,source Elixir Section";
      scope = [
        "source.elixir array"
        "source.elixir scope"
        "source.elixir section"
      ];
      settings = {
        foreground = "#828997" /* TODO */;
      };
    }
    {
      name = "Source Gfm Markup";
      scope = [
        "source.gfm markup"
      ];
      settings = {
        "-webkit-font-smoothing" = "auto";
      };
    }
    {
      name = "Source Gfm Link Entity";
      scope = [
        "source.gfm link entity"
      ];
      settings = {
        foreground = colors.blue;
      };
    }
    {
      name = "Source Go Storage Type String";
      scope = [
        "source.go storage.type.string"
      ];
      settings = {
        foreground = colors.purple;
      };
    }
    {
      name = "Source Ini Keyword Other Definition Ini";
      scope = [
        "source.ini keyword.other.definition.ini"
      ];
      settings = {
        foreground = colors.red;
      };
    }
    {
      name = "Source Java Storage Modifier Import";
      scope = [
        "source.java storage.modifier.import"
      ];
      settings = {
        foreground = colors.yellow;
      };
    }
    {
      name = "Source Java Storage Type";
      scope = [
        "source.java storage.type"
      ];
      settings = {
        foreground = colors.yellow;
      };
    }
    {
      name = "Source Java Keyword Operator Instanceof";
      scope = [
        "source.java keyword.operator.instanceof"
      ];
      settings = {
        foreground = colors.purple;
      };
    }
    {
      name = "Source Java Properties Meta Key Pair";
      scope = [
        "source.java-properties meta.key-pair"
      ];
      settings = {
        foreground = colors.red;
      };
    }
    {
      name = "Source Java Properties Meta Key Pair > Punctuation";
      scope = [
        "source.java-properties meta.key-pair > punctuation"
      ];
      settings = {
        foreground = colors.white;
      };
    }
    {
      name = "Source Js Keyword Operator";
      scope = [
        "source.js keyword.operator"
      ];
      settings = {
        foreground = colors.cyan;
      };
    }
    {
      name = "Source Js Keyword Operator Delete,source Js Keyword Operator In,source Js Keyword Operator Of,source Js Keyword Operator Instanceof,source Js Keyword Operator New,source Js Keyword Operator Typeof,source Js Keyword Operator Void";
      scope = [
        "source.js keyword.operator.delete"
        "source.js keyword.operator.in"
        "source.js keyword.operator.of"
        "source.js keyword.operator.instanceof"
        "source.js keyword.operator.new"
        "source.js keyword.operator.typeof"
        "source.js keyword.operator.void"
      ];
      settings = {
        foreground = colors.purple;
      };
    }
    {
      name = "Source Ts Keyword Operator";
      scope = [
        "source.ts keyword.operator"
      ];
      settings = {
        foreground = colors.cyan;
      };
    }
    {
      name = "Source Flow Keyword Operator";
      scope = [
        "source.flow keyword.operator"
      ];
      settings = {
        foreground = colors.cyan;
      };
    }
    {
      name = "Source Json Meta Structure Dictionary Json > String Quoted Json";
      scope = [
        "source.json meta.structure.dictionary.json > string.quoted.json"
      ];
      settings = {
        foreground = colors.red;
      };
    }
    {
      name = "Source Json Meta Structure Dictionary Json > String Quoted Json > Punctuation String";
      scope = [
        "source.json meta.structure.dictionary.json > string.quoted.json > punctuation.string"
      ];
      settings = {
        foreground = colors.red;
      };
    }
    {
      name = "Source Json Meta Structure Dictionary Json > Value Json > String Quoted Json,source Json Meta Structure Array Json > Value Json > String Quoted Json,source Json Meta Structure Dictionary Json > Value Json > String Quoted Json > Punctuation,source Json Meta Structure Array Json > Value Json > String Quoted Json > Punctuation";
      scope = [
        "source.json meta.structure.dictionary.json > value.json > string.quoted.json"
        "source.json meta.structure.array.json > value.json > string.quoted.json"
        "source.json meta.structure.dictionary.json > value.json > string.quoted.json > punctuation"
        "source.json meta.structure.array.json > value.json > string.quoted.json > punctuation"
      ];
      settings = {
        foreground = colors.green;
      };
    }
    {
      name = "Source Json Meta Structure Dictionary Json > Constant Language Json,source Json Meta Structure Array Json > Constant Language Json";
      scope = [
        "source.json meta.structure.dictionary.json > constant.language.json"
        "source.json meta.structure.array.json > constant.language.json"
      ];
      settings = {
        foreground = colors.cyan;
      };
    }
    {
      name = "Ng Interpolation";
      scope = [
        "ng.interpolation"
      ];
      settings = {
        foreground = colors.red;
      };
    }
    {
      name = "Ng Interpolation Begin,ng Interpolation End";
      scope = [
        "ng.interpolation.begin"
        "ng.interpolation.end"
      ];
      settings = {
        foreground = colors.blue;
      };
    }
    {
      name = "Ng Interpolation Function";
      scope = [
        "ng.interpolation function"
      ];
      settings = {
        foreground = colors.red;
      };
    }
    {
      name = "Ng Interpolation Function Begin,ng Interpolation Function End";
      scope = [
        "ng.interpolation function.begin"
        "ng.interpolation function.end"
      ];
      settings = {
        foreground = colors.blue;
      };
    }
    {
      name = "Ng Interpolation Bool";
      scope = [
        "ng.interpolation bool"
      ];
      settings = {
        foreground = colors.dark-yellow;
      };
    }
    {
      name = "Ng Interpolation Bracket";
      scope = [
        "ng.interpolation bracket"
      ];
      settings = {
        foreground = colors.white;
      };
    }
    {
      name = "Ng Pipe,ng Operator";
      scope = [
        "ng.pipe"
        "ng.operator"
      ];
      settings = {
        foreground = colors.white;
      };
    }
    {
      name = "Ng Tag";
      scope = [
        "ng.tag"
      ];
      settings = {
        foreground = colors.cyan;
      };
    }
    {
      name = "Ng Attribute With Value Attribute Name";
      scope = [
        "ng.attribute-with-value attribute-name"
      ];
      settings = {
        foreground = colors.yellow;
      };
    }
    {
      name = "Ng Attribute With Value String";
      scope = [
        "ng.attribute-with-value string"
      ];
      settings = {
        foreground = colors.purple;
      };
    }
    {
      name = "Ng Attribute With Value String Begin,ng Attribute With Value String End";
      scope = [
        "ng.attribute-with-value string.begin"
        "ng.attribute-with-value string.end"
      ];
      settings = {
        foreground = colors.white;
      };
    }
    {
      name = "Source Ruby Constant Other Symbol > Punctuation";
      scope = [
        "source.ruby constant.other.symbol > punctuation"
      ];
      settings = {
        foreground = "inherit";
      };
    }
    {
      name = "Source Php Class Bracket";
      scope = [
        "source.php class.bracket"
      ];
      settings = {
        foreground = colors.white;
      };
    }
    {
      name = "Source Python Keyword Operator Logical Python";
      scope = [
        "source.python keyword.operator.logical.python"
      ];
      settings = {
        foreground = colors.purple;
      };
    }
    {
      name = "Source Python Variable Parameter";
      scope = [
        "source.python variable.parameter"
      ];
      settings = {
        foreground = colors.dark-yellow;
      };
    }
    {
      name = "customrule";
      scope = "customrule";
      settings = {
        foreground = colors.white;
      };
    }
    {
      name = "[VSCODE-CUSTOM] Support Type Property Name";
      scope = "support.type.property-name";
      settings = {
        foreground = colors.white;
      };
    }
    {
      name = "[VSCODE-CUSTOM] Punctuation for Quoted String";
      scope = "string.quoted.double punctuation";
      settings = {
        foreground = colors.green;
      };
    }
    {
      name = "[VSCODE-CUSTOM] Support Constant";
      scope = "support.constant";
      settings = {
        foreground = colors.dark-yellow;
      };
    }
    {
      name = "[VSCODE-CUSTOM] JSON Property Name";
      scope = "support.type.property-name.json";
      settings = {
        foreground = colors.red;
      };
    }
    {
      name = "[VSCODE-CUSTOM] JSON Punctuation for Property Name";
      scope = "support.type.property-name.json punctuation";
      settings = {
        foreground = colors.red;
      };
    }
    {
      name = "[VSCODE-CUSTOM] JS/TS Punctuation for key-value";
      scope = [
        "punctuation.separator.key-value.ts"
        "punctuation.separator.key-value.js"
        "punctuation.separator.key-value.tsx"
      ];
      settings = {
        foreground = colors.cyan;
      };
    }
    {
      name = "[VSCODE-CUSTOM] JS/TS Embedded Operator";
      scope = [
        "source.js.embedded.html keyword.operator"
        "source.ts.embedded.html keyword.operator"
      ];
      settings = {
        foreground = colors.cyan;
      };
    }
    {
      name = "[VSCODE-CUSTOM] JS/TS Variable Other Readwrite";
      scope = [
        "variable.other.readwrite.js"
        "variable.other.readwrite.ts"
        "variable.other.readwrite.tsx"
      ];
      settings = {
        foreground = colors.white;
      };
    }
    {
      name = "[VSCODE-CUSTOM] JS/TS Support Variable Dom";
      scope = [
        "support.variable.dom.js"
        "support.variable.dom.ts"
      ];
      settings = {
        foreground = colors.red;
      };
    }
    {
      name = "[VSCODE-CUSTOM] JS/TS Support Variable Property Dom";
      scope = [
        "support.variable.property.dom.js"
        "support.variable.property.dom.ts"
      ];
      settings = {
        foreground = colors.red;
      };
    }
    {
      name = "[VSCODE-CUSTOM] JS/TS Interpolation String Punctuation";
      scope = [
        "meta.template.expression.js punctuation.definition"
        "meta.template.expression.ts punctuation.definition"
      ];
      settings = {
        foreground = colors.dark-red;
      };
    }
    {
      name = "[VSCODE-CUSTOM] JS/TS Punctuation Type Parameters";
      scope = [
        "source.ts punctuation.definition.typeparameters"
        "source.js punctuation.definition.typeparameters"
        "source.tsx punctuation.definition.typeparameters"
      ];
      settings = {
        foreground = colors.white;
      };
    }
    {
      name = "[VSCODE-CUSTOM] JS/TS Definition Block";
      scope = [
        "source.ts punctuation.definition.block"
        "source.js punctuation.definition.block"
        "source.tsx punctuation.definition.block"
      ];
      settings = {
        foreground = colors.white;
      };
    }
    {
      name = "[VSCODE-CUSTOM] JS/TS Punctuation Separator Comma";
      scope = [
        "source.ts punctuation.separator.comma"
        "source.js punctuation.separator.comma"
        "source.tsx punctuation.separator.comma"
      ];
      settings = {
        foreground = colors.white;
      };
    }
    {
      name = "[VSCODE-CUSTOM] JS/TS Variable Property";
      scope = [
        "support.variable.property.js"
        "support.variable.property.ts"
        "support.variable.property.tsx"
      ];
      settings = {
        foreground = colors.red;
      };
    }
    {
      name = "[VSCODE-CUSTOM] JS/TS Default Keyword";
      scope = [
        "keyword.control.default.js"
        "keyword.control.default.ts"
        "keyword.control.default.tsx"
      ];
      settings = {
        foreground = colors.red;
      };
    }
    {
      name = "[VSCODE-CUSTOM] JS/TS Instanceof Keyword";
      scope = [
        "keyword.operator.expression.instanceof.js"
        "keyword.operator.expression.instanceof.ts"
        "keyword.operator.expression.instanceof.tsx"
      ];
      settings = {
        foreground = colors.purple;
      };
    }
    {
      name = "[VSCODE-CUSTOM] JS/TS Of Keyword";
      scope = [
        "keyword.operator.expression.of.js"
        "keyword.operator.expression.of.ts"
        "keyword.operator.expression.of.tsx"
      ];
      settings = {
        foreground = colors.purple;
      };
    }
    {
      name = "[VSCODE-CUSTOM] JS/TS Braces/Brackets";
      scope = [
        "meta.brace.round.js"
        "meta.array-binding-pattern-variable.js"
        "meta.brace.square.js"
        "meta.brace.round.ts"
        "meta.array-binding-pattern-variable.ts"
        "meta.brace.square.ts"
        "meta.brace.round.tsx"
        "meta.array-binding-pattern-variable.tsx"
        "meta.brace.square.tsx"
      ];
      settings = {
        foreground = colors.white;
      };
    }
    {
      name = "[VSCODE-CUSTOM] JS/TS Punctuation Accessor";
      scope = [
        "source.js punctuation.accessor"
        "source.ts punctuation.accessor"
        "source.tsx punctuation.accessor"
      ];
      settings = {
        foreground = colors.white;
      };
    }
    {
      name = "[VSCODE-CUSTOM] JS/TS Punctuation Terminator Statement";
      scope = [
        "punctuation.terminator.statement.js"
        "punctuation.terminator.statement.ts"
        "punctuation.terminator.statement.tsx"
      ];
      settings = {
        foreground = colors.white;
      };
    }
    {
      name = "[VSCODE-CUSTOM] JS/TS Array variables";
      scope = [
        "meta.array-binding-pattern-variable.js variable.other.readwrite.js"
        "meta.array-binding-pattern-variable.ts variable.other.readwrite.ts"
        "meta.array-binding-pattern-variable.tsx variable.other.readwrite.tsx"
      ];
      settings = {
        foreground = colors.dark-yellow;
      };
    }
    {
      name = "[VSCODE-CUSTOM] JS/TS Support Variables";
      scope = [
        "source.js support.variable"
        "source.ts support.variable"
        "source.tsx support.variable"
      ];
      settings = {
        foreground = colors.red;
      };
    }
    {
      name = "[VSCODE-CUSTOM] JS/TS Support Variables";
      scope = [
        "variable.other.constant.property.js"
        "variable.other.constant.property.ts"
        "variable.other.constant.property.tsx"
      ];
      settings = {
        foreground = colors.dark-yellow;
      };
    }
    {
      name = "[VSCODE-CUSTOM] JS/TS Keyword New";
      scope = [
        "keyword.operator.new.ts"
        "keyword.operator.new.j"
        "keyword.operator.new.tsx"
      ];
      settings = {
        foreground = colors.purple;
      };
    }
    {
      name = "[VSCODE-CUSTOM] TS Keyword Operator";
      scope = [
        "source.ts keyword.operator"
        "source.tsx keyword.operator"
      ];
      settings = {
        foreground = colors.cyan;
      };
    }
    {
      name = "[VSCODE-CUSTOM] JS/TS Punctuation Parameter Separator";
      scope = [
        "punctuation.separator.parameter.js"
        "punctuation.separator.parameter.ts"
        "punctuation.separator.parameter.tsx "
      ];
      settings = {
        foreground = colors.white;
      };
    }
    {
      name = "[VSCODE-CUSTOM] JS/TS Import";
      scope = [
        "constant.language.import-export-all.js"
        "constant.language.import-export-all.ts"
      ];
      settings = {
        foreground = colors.red;
      };
    }
    {
      name = "[VSCODE-CUSTOM] JSX/TSX Import";
      scope = [
        "constant.language.import-export-all.jsx"
        "constant.language.import-export-all.tsx"
      ];
      settings = {
        foreground = colors.cyan;
      };
    }
    # {
    #   name = "[VSCODE-CUSTOM] JS/TS Keyword Control As";
    #   scope = [
    #     "keyword.control.as.js"
    #     "keyword.control.as.ts"
    #     "keyword.control.as.jsx"
    #     "keyword.control.as.tsx"
    #   ];
    #   settings = {
    #     foreground = colors.white;
    #   };
    # }
    {
      name = "[VSCODE-CUSTOM] JS/TS Variable Alias";
      scope = [
        "variable.other.readwrite.alias.js"
        "variable.other.readwrite.alias.ts"
        "variable.other.readwrite.alias.jsx"
        "variable.other.readwrite.alias.tsx"
      ];
      settings = {
        foreground = colors.red;
      };
    }
    {
      name = "[VSCODE-CUSTOM] JS/TS Constants";
      scope = [
        "variable.other.constant.js"
        "variable.other.constant.ts"
        "variable.other.constant.jsx"
        "variable.other.constant.tsx"
      ];
      settings = {
        foreground = colors.dark-yellow;
      };
    }
    {
      name = "[VSCODE-CUSTOM] JS/TS Export Variable";
      scope = [
        "meta.export.default.js variable.other.readwrite.js"
        "meta.export.default.ts variable.other.readwrite.ts"
      ];
      settings = {
        foreground = colors.red;
      };
    }
    {
      name = "[VSCODE-CUSTOM] JS/TS Template Strings Punctuation Accessor";
      scope = [
        "source.js meta.template.expression.js punctuation.accessor"
        "source.ts meta.template.expression.ts punctuation.accessor"
        "source.tsx meta.template.expression.tsx punctuation.accessor"
      ];
      settings = {
        foreground = colors.green;
      };
    }
    {
      name = "[VSCODE-CUSTOM] JS/TS Import equals";
      scope = [
        "source.js meta.import-equals.external.js keyword.operator"
        "source.jsx meta.import-equals.external.jsx keyword.operator"
        "source.ts meta.import-equals.external.ts keyword.operator"
        "source.tsx meta.import-equals.external.tsx keyword.operator"
      ];
      settings = {
        foreground = colors.white;
      };
    }
    {
      name = "[VSCODE-CUSTOM] JS/TS Type Module";
      scope = "entity.name.type.module.js,entity.name.type.module.ts,entity.name.type.module.jsx,entity.name.type.module.tsx";
      settings = {
        foreground = colors.green;
      };
    }
    {
      name = "[VSCODE-CUSTOM] JS/TS Meta Class";
      scope = "meta.class.js,meta.class.ts,meta.class.jsx,meta.class.tsx";
      settings = {
        foreground = colors.white;
      };
    }
    {
      name = "[VSCODE-CUSTOM] JS/TS Property Definition Variable";
      scope = [
        "meta.definition.property.js variable"
        "meta.definition.property.ts variable"
        "meta.definition.property.jsx variable"
        "meta.definition.property.tsx variable"
      ];
      settings = {
        foreground = colors.white;
      };
    }
    {
      name = "[VSCODE-CUSTOM] JS/TS Meta Type Parameters Type";
      scope = [
        "meta.type.parameters.js support.type"
        "meta.type.parameters.jsx support.type"
        "meta.type.parameters.ts support.type"
        "meta.type.parameters.tsx support.type"
      ];
      settings = {
        foreground = colors.white;
      };
    }
    {
      name = "[VSCODE-CUSTOM] JS/TS Meta Tag Keyword Operator";
      scope = [
        "source.js meta.tag.js keyword.operator"
        "source.jsx meta.tag.jsx keyword.operator"
        "source.ts meta.tag.ts keyword.operator"
        "source.tsx meta.tag.tsx keyword.operator"
      ];
      settings = {
        foreground = colors.white;
      };
    }
    {
      name = "[VSCODE-CUSTOM] JS/TS Meta Tag Punctuation";
      scope = [
        "meta.tag.js punctuation.section.embedded"
        "meta.tag.jsx punctuation.section.embedded"
        "meta.tag.ts punctuation.section.embedded"
        "meta.tag.tsx punctuation.section.embedded"
      ];
      settings = {
        foreground = colors.white;
      };
    }
    {
      name = "[VSCODE-CUSTOM] JS/TS Meta Array Literal Variable";
      scope = [
        "meta.array.literal.js variable"
        "meta.array.literal.jsx variable"
        "meta.array.literal.ts variable"
        "meta.array.literal.tsx variable"
      ];
      settings = {
        foreground = colors.yellow;
      };
    }
    {
      name = "[VSCODE-CUSTOM] JS/TS Module Exports";
      scope = [
        "support.type.object.module.js"
        "support.type.object.module.jsx"
        "support.type.object.module.ts"
        "support.type.object.module.tsx"
      ];
      settings = {
        foreground = colors.red;
      };
    }
    {
      name = "[VSCODE-CUSTOM] JSON Constants";
      scope = [
        "constant.language.json"
      ];
      settings = {
        foreground = colors.cyan;
      };
    }
    {
      name = "[VSCODE-CUSTOM] JS/TS Object Constants";
      scope = [
        "variable.other.constant.object.js"
        "variable.other.constant.object.jsx"
        "variable.other.constant.object.ts"
        "variable.other.constant.object.tsx"
      ];
      settings = {
        foreground = colors.dark-yellow;
      };
    }
    {
      name = "[VSCODE-CUSTOM] JS/TS Properties Keyword";
      scope = [
        "storage.type.property.js"
        "storage.type.property.jsx"
        "storage.type.property.ts"
        "storage.type.property.tsx"
      ];
      settings = {
        foreground = colors.cyan;
      };
    }
    {
      name = "[VSCODE-CUSTOM] JS/TS Single Quote Inside Templated String";
      scope = [
        "meta.template.expression.js string.quoted punctuation.definition"
        "meta.template.expression.jsx string.quoted punctuation.definition"
        "meta.template.expression.ts string.quoted punctuation.definition"
        "meta.template.expression.tsx string.quoted punctuation.definition"
      ];
      settings = {
        foreground = colors.green;
      };
    }
    {
      name = "[VSCODE-CUSTOM] JS/TS Backtick inside Templated String";
      scope = [
        "meta.template.expression.js string.template punctuation.definition.string.template"
        "meta.template.expression.jsx string.template punctuation.definition.string.template"
        "meta.template.expression.ts string.template punctuation.definition.string.template"
        "meta.template.expression.tsx string.template punctuation.definition.string.template"
      ];
      settings = {
        foreground = colors.green;
      };
    }
    {
      name = "[VSCODE-CUSTOM] JS/TS In Keyword for Loops";
      scope = [
        "keyword.operator.expression.in.js"
        "keyword.operator.expression.in.jsx"
        "keyword.operator.expression.in.ts"
        "keyword.operator.expression.in.tsx"
      ];
      settings = {
        foreground = colors.purple;
      };
    }
    {
      name = "[VSCODE-CUSTOM] JS/TS Variable Other Object";
      scope = [
        "variable.other.object.js"
        "variable.other.object.ts"
      ];
      settings = {
        foreground = colors.white;
      };
    }
    {
      name = "[VSCODE-CUSTOM] JS/TS Meta Object Literal Key";
      scope = [
        "meta.object-literal.key.js"
        "meta.object-literal.key.ts"
      ];
      settings = {
        foreground = colors.red;
      };
    }
    {
      name = "[VSCODE-CUSTOM] Python Constants Other";
      scope = "source.python constant.other";
      settings = {
        foreground = colors.white;
      };
    }
    {
      name = "[VSCODE-CUSTOM] Python Constants";
      scope = "source.python constant";
      settings = {
        foreground = colors.dark-yellow;
      };
    }
    {
      name = "[VSCODE-CUSTOM] Python Placeholder Character";
      scope = "constant.character.format.placeholder.other.python storage";
      settings = {
        foreground = colors.dark-yellow;
      };
    }
    {
      name = "[VSCODE-CUSTOM] Python Magic";
      scope = "support.variable.magic.python";
      settings = {
        foreground = colors.red;
      };
    }
    {
      name = "[VSCODE-CUSTOM] Python Meta Function Parameters";
      scope = "meta.function.parameters.python";
      settings = {
        foreground = colors.dark-yellow;
      };
    }
    {
      name = "[VSCODE-CUSTOM] Python Function Separator Annotation";
      scope = "punctuation.separator.annotation.python";
      settings = {
        foreground = colors.white;
      };
    }
    {
      name = "[VSCODE-CUSTOM] Python Function Separator Punctuation";
      scope = "punctuation.separator.parameters.python";
      settings = {
        foreground = colors.white;
      };
    }
    {
      name = "[VSCODE-CUSTOM] CSharp Fields";
      scope = "entity.name.variable.field.cs";
      settings = {
        foreground = colors.red;
      };
    }
    {
      name = "[VSCODE-CUSTOM] CSharp Keyword Operators";
      scope = "source.cs keyword.operator";
      settings = {
        foreground = colors.white;
      };
    }
    {
      name = "[VSCODE-CUSTOM] CSharp Variables";
      scope = "variable.other.readwrite.cs";
      settings = {
        foreground = colors.white;
      };
    }
    {
      name = "[VSCODE-CUSTOM] CSharp Variables Other";
      scope = "variable.other.object.cs";
      settings = {
        foreground = colors.white;
      };
    }
    {
      name = "[VSCODE-CUSTOM] CSharp Property Other";
      scope = "variable.other.object.property.cs";
      settings = {
        foreground = colors.white;
      };
    }
    {
      name = "[VSCODE-CUSTOM] CSharp Property";
      scope = "entity.name.variable.property.cs";
      settings = {
        foreground = colors.blue;
      };
    }
    {
      name = "[VSCODE-CUSTOM] CSharp Storage Type";
      scope = "storage.type.cs";
      settings = {
        foreground = colors.yellow;
      };
    }
    {
      name = "[VSCODE-CUSTOM] Rust Unsafe Keyword";
      scope = "keyword.other.unsafe.rust";
      settings = {
        foreground = colors.purple;
      };
    }
    {
      name = "[VSCODE-CUSTOM] Rust Entity Name Type";
      scope = "entity.name.type.rust";
      settings = {
        foreground = colors.cyan;
      };
    }
    {
      name = "[VSCODE-CUSTOM] Rust Storage Modifier Lifetime";
      scope = "storage.modifier.lifetime.rust";
      settings = {
        foreground = colors.white;
      };
    }
    {
      name = "[VSCODE-CUSTOM] Rust Entity Name Lifetime";
      scope = "entity.name.lifetime.rust";
      settings = {
        foreground = colors.dark-yellow;
      };
    }
    {
      name = "[VSCODE-CUSTOM] Rust Storage Type Core";
      scope = "storage.type.core.rust";
      settings = {
        foreground = colors.cyan;
      };
    }
    {
      name = "[VSCODE-CUSTOM] Rust Meta Attribute";
      scope = "meta.attribute.rust";
      settings = {
        foreground = colors.dark-yellow;
      };
    }
    {
      name = "[VSCODE-CUSTOM] Rust Storage Class Std";
      scope = "storage.class.std.rust";
      settings = {
        foreground = colors.cyan;
      };
    }
    {
      name = "[VSCODE-CUSTOM] Markdown Raw Block";
      scope = "markup.raw.block.markdown";
      settings = {
        foreground = colors.white;
      };
    }
    {
      name = "[VSCODE-CUSTOM] Shell Variables Punctuation Definition";
      scope = "punctuation.definition.variable.shell";
      settings = {
        foreground = colors.red;
      };
    }
    {
      name = "[VSCODE-CUSTOM] Css Support Constant Value";
      scope = "support.constant.property-value.css";
      settings = {
        foreground = colors.white;
      };
    }
    {
      name = "[VSCODE-CUSTOM] Css Punctuation Definition Constant";
      scope = "punctuation.definition.constant.css";
      settings = {
        foreground = colors.dark-yellow;
      };
    }
    {
      name = "[VSCODE-CUSTOM] Sass Punctuation for key-value";
      scope = "punctuation.separator.key-value.scss";
      settings = {
        foreground = colors.red;
      };
    }
    {
      name = "[VSCODE-CUSTOM] Sass Punctuation for constants";
      scope = "punctuation.definition.constant.scss";
      settings = {
        foreground = colors.dark-yellow;
      };
    }
    {
      name = "[VSCODE-CUSTOM] Sass Punctuation for key-value";
      scope = "meta.property-list.scss punctuation.separator.key-value.scss";
      settings = {
        foreground = colors.white;
      };
    }
    {
      name = "[VSCODE-CUSTOM] Java Storage Type Primitive Array";
      scope = "storage.type.primitive.array.java";
      settings = {
        foreground = colors.yellow;
      };
    }
    {
      name = "[VSCODE-CUSTOM] Markdown headings";
      scope = "entity.name.section.markdown";
      settings = {
        foreground = colors.red;
      };
    }
    {
      name = "[VSCODE-CUSTOM] Markdown heading Punctuation Definition";
      scope = "punctuation.definition.heading.markdown";
      settings = {
        foreground = colors.red;
      };
    }
    {
      name = "[VSCODE-CUSTOM] Markdown heading setext";
      scope = "markup.heading.setext";
      settings = {
        foreground = colors.white;
      };
    }
    {
      name = "[VSCODE-CUSTOM] Markdown Punctuation Definition Bold";
      scope = "punctuation.definition.bold.markdown";
      settings = {
        foreground = colors.dark-yellow;
      };
    }
    {
      name = "[VSCODE-CUSTOM] Markdown Inline Raw";
      scope = "markup.inline.raw.markdown";
      settings = {
        foreground = colors.green;
      };
    }
    {
      name = "[VSCODE-CUSTOM] Markdown List Punctuation Definition";
      scope = "beginning.punctuation.definition.list.markdown";
      settings = {
        foreground = colors.red;
      };
    }
    {
      name = "[VSCODE-CUSTOM] Markdown Quote";
      scope = "markup.quote.markdown";
      settings = {
        foreground = colors.comment_grey;
        fontStyle = "italic";
      };
    }
    {
      name = "[VSCODE-CUSTOM] Markdown Punctuation Definition String";
      scope = [
        "punctuation.definition.string.begin.markdown"
        "punctuation.definition.string.end.markdown"
        "punctuation.definition.metadata.markdown"
      ];
      settings = {
        foreground = colors.white;
      };
    }
    # {
    #   name = "[VSCODE-CUSTOM] Markdown Punctuation Definition Link";
    #   scope = "punctuation.definition.metadata.markdown";
    #   settings = {
    #     foreground = colors.purple;
    #   };
    # }
    {
      name = "[VSCODE-CUSTOM] Markdown Underline Link/Image";
      scope = [
        "markup.underline.link.markdown"
        "markup.underline.link.image.markdown"
      ];
      settings = {
        foreground = colors.purple;
      };
    }
    {
      name = "[VSCODE-CUSTOM] Markdown Link Title/Description";
      scope = [
        "string.other.link.title.markdown"
        "string.other.link.description.markdown"
      ];
      settings = {
        foreground = colors.blue;
      };
    }
    {
      name = "[VSCODE-CUSTOM] Ruby Punctuation Separator Variable";
      scope = "punctuation.separator.variable.ruby";
      settings = {
        foreground = colors.red;
      };
    }
    {
      name = "[VSCODE-CUSTOM] Ruby Other Constant Variable";
      scope = "variable.other.constant.ruby";
      settings = {
        foreground = colors.dark-yellow;
      };
    }
    {
      name = "[VSCODE-CUSTOM] Ruby Keyword Operator Other";
      scope = "keyword.operator.other.ruby";
      settings = {
        foreground = colors.green;
      };
    }
    {
      name = "[VSCODE-CUSTOM] PHP Punctuation Variable Definition";
      scope = "punctuation.definition.variable.php";
      settings = {
        foreground = colors.red;
      };
    }
    {
      name = "[VSCODE-CUSTOM] PHP Meta Class";
      scope = "meta.class.php";
      settings = {
        foreground = colors.white;
      };
    }

    # Custom colors.
    {
      name = "[SUPERPAINTMAN-CUSTOM] Entity Other Attribute Name";
      scope = [
        "entity.other.attribute-name"
      ];
      settings = {
        foreground = colors.red;
      };
    }

    ## JavaScript/TypeScript.
    {
      name = "[SUPERPAINTMAN-CUSTOM] JS/TS Keyword Control As";
      scope = [
        "keyword.control.as.js"
        "keyword.control.as.ts"
        "keyword.control.as.jsx"
        "keyword.control.as.tsx"
      ];
      settings = {
        foreground = colors.purple;
      };
    }

    ## Markdown.
    {
      name = "[SUPERPAINTMAN-CUSTOM] Markdown Inline Raw String";
      scope = [
        "markup.inline.raw.string.markdown"
      ];
      settings = {
        foreground = colors.red;
      };
    }
    {
      name = "[SUPERPAINTMAN-CUSTOM] Markdown Punctuation Definition";
      scope = [
        "punctuation.definition.markdown"
      ];
      settings = {
        foreground = colors.dark-yellow;
      };
    }
    {
      name = "[SUPERPAINTMAN-CUSTOM] Markdown Fenced Code Block Language";
      scope = [
        "fenced_code.block.language.markdown"
      ];
      settings = {
        foreground = colors.dark-yellow;
      };
    }
    {
      name = "[SUPERPAINTMAN-CUSTOM] Markdown Meta Separator";
      scope = [
        "meta.separator.markdown"
      ];
      settings = {
        foreground = colors.comment_grey;
      };
    }
    {
      name = "[SUPERPAINTMAN-CUSTOM] Markdown Punctuation Definition Link";
      scope = [
        "punctuation.definition.link.description.begin.markdown"
        "punctuation.definition.link.description.end.markdown"
      ];
      settings = {
        foreground = colors.dark-yellow;
      };
    }
    {
      name = "[SUPERPAINTMAN-CUSTOM] Markdown Punctuation Definition Link";
      scope = [
        "punctuation.definition.metadata.markdown"
      ];
      settings = {
        foreground = colors.dark-yellow;
      };
    }
  ];
}
