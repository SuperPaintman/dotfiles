{ pkgs, lib }:
let
  fromJSON = builtins.fromJSON;

  toJSON = builtins.toJSON;

  executeCommand' = name: command: pkgs.stdenv.mkDerivation {
    inherit name;

    phases = [ "buildPhase" ];

    src = pkgs.writeText "${name}-command" command;

    buildPhase = ''
      mkdir -p $out

      code=0
      ${pkgs.runtimeShell} $src 1>$out/stdout 2>$out/stderr || { code="$?"; }

      echo $code > $out/code
    '';
  };

  executeCommand = name: command:
    let
      res = executeCommand' name command;
    in
    {
      stdout = builtins.readFile "${res}/stdout";
      stderr = builtins.readFile "${res}/stderr";
      code = lib.toInt (builtins.readFile "${res}/code");
    };

  execute = name: command:
    let
      res = executeCommand name command;
    in
    assert lib.assertMsg (res.code == 0) res.stderr;
    res.stdout;

  executeJS = name: script:
    let
      scriptFile = pkgs.writeText "${name}.js" script;
    in
    execute name ''
      ${pkgs.nodejs}/bin/node ${scriptFile}
    '';

  jsYAML = pkgs.fetchgit {
    url = "https://github.com/nodeca/js-yaml.git";
    rev = "4.1.0";
    sha256 = "0h7f8p2xqfgy65x8lwjsy1riba1wvq7292wds1l8izk8kwivmdmf";
  };

  tinycolorJS = pkgs.fetchgit {
    url = "https://github.com/bgrins/TinyColor.git";
    rev = "1.4.2";
    sha256 = "17hnqw922dlfmn5dl7b6dki9hhjlg9z7272g93dayb9yg7i48s43";
  };

  tinycolor = script: fromJSON (executeJS "tinycolor" ''
    const tinycolor = require(${toJSON "${tinycolorJS}/dist/tinycolor-min.js"});

    const script = (
      ${script}
    );

    const res = script(tinycolor)

    process.stdout.write(JSON.stringify(res));
  '');

  # charToHexMap = {
  #   "0" = 0;
  #   "1" = 1;
  #   "2" = 2;
  #   "3" = 3;
  #   "4" = 4;
  #   "5" = 5;
  #   "6" = 6;
  #   "7" = 7;
  #   "8" = 8;
  #   "9" = 9;
  #   "a" = 10;
  #   "A" = 10;
  #   "b" = 11;
  #   "B" = 11;
  #   "c" = 12;
  #   "C" = 12;
  #   "d" = 13;
  #   "D" = 13;
  #   "e" = 14;
  #   "E" = 14;
  #   "f" = 15;
  #   "F" = 15;
  # };

  # hexToCharMap = {
  #   "0" = "0";
  #   "1" = "1";
  #   "2" = "2";
  #   "3" = "3";
  #   "4" = "4";
  #   "5" = "5";
  #   "6" = "6";
  #   "7" = "7";
  #   "8" = "8";
  #   "9" = "9";
  #   "10" = "A";
  #   "11" = "B";
  #   "12" = "C";
  #   "13" = "D";
  #   "14" = "E";
  #   "15" = "F";
  # };

  # parseHexademicalChar = c:
  #   if builtins.hasAttr c charToHexMap
  #   then charToHexMap."${c}"
  #   else null;

  # parseHexadecimal = value:
  #   let
  #     len = builtins.stringLength value;
  #   in
  #   if len == 0
  #   then 0
  #   else
  #     let
  #       v = parseHexademicalChar (builtins.substring (len - 1) 1 value);
  #     in
  #     assert v != null;
  #     v + (parseHexadecimal (builtins.substring 0 (len - 1) value)) * 16;

  # hexadecimalToString = value:
  #   let
  #     head = lib.mod value 16;
  #     tail = builtins.div value 16;
  #     h = v:
  #       assert builtins.hasAttr (builtins.toString v) hexToCharMap;
  #       hexToCharMap."${builtins.toString v}";
  #   in
  #   if tail == 0
  #   then (h head)
  #   else (hexadecimalToString tail) + (h head);

  # assertRGBA = { r, g, b, a ? 255 }:
  #   assert r >= 0 && r <= 255;
  #   assert b >= 0 && b <= 255;
  #   assert g >= 0 && g <= 255;
  #   assert a == null || a >= 0 && a <= 255;
  #   true;

  x = self: rec {
    inherit executeCommand execute executeJS;

    callIfFunction = f: args: if builtins.isFunction f then (f args) else f;

    fromYAML = content: fromJSON (executeJS "from-yaml" ''
      const fs = require("fs");
      const YAML = require(${toJSON "${jsYAML}/dist/js-yaml.min.js"});

      const content = fs.readFileSync(
        ${toJSON (pkgs.writeText "from-yaml-content" content)},
        "utf-8"
      );

      process.stdout.write(JSON.stringify(YAML.load(content)));
    '');

    toYAML = v: executeJS "from-yaml" ''
      const YAML = require(${toJSON "${jsYAML}/dist/js-yaml.min.js"});

      process.stdout.write(YAML.dump(${toJSON v}));
    '';

    colors = rec {
      # toRGBA' = parseAlpha: color:
      #   if builtins.isAttrs color
      #   then
      #     assert assertRGBA color;
      #     color
      #   else
      #     let
      #       len = builtins.stringLength color;
      #     in
      #     assert (builtins.substring 0 1 color) == "#";
      #     assert len == 7 || len == 9;
      #     let
      #       c = n: parseHexadecimal (builtins.substring (1 + 2 * n) 2 color);
      #       r = c 0;
      #       g = c 1;
      #       b = c 2;
      #       a =
      #         if parseAlpha && len == 9
      #         then c 3
      #         else 255;
      #     in
      #     assert assertRGBA { inherit r g b a; };
      #     {
      #       inherit r g b;
      #     } // (if parseAlpha then { inherit a; } else { });

      # toRGB = toRGBA' false;

      # toRGBA = toRGBA' true;

      # toHEX = { r, g, b, a ? null }:
      #   assert assertRGBA { inherit r g b a; };
      #   let
      #     h = hexadecimalToString;
      #   in
      #   "#${h r}${h g}${h b}${if a == null then "" else h a}";

      toRGB = color: tinycolor ''
        (v) => {
          const res = v(${toJSON color}).toRgb();
          delete res.a;
          return res;
        }
      '';

      toRGBA = color: tinycolor "(v) => v(${toJSON color}).toRgb()";

      modify = name: amount: color: tinycolor ''
        (v) => v(${toJSON color}).${name}(${toJSON amount})
          .toHex8String()
          .replace(/ff$/i, "")
          .toUpperCase()
      '';

      lighten = modify "lighten";

      brighten = modify "brighten";

      darken = modify "darken";
    };
  };
in
lib.makeExtensible x
