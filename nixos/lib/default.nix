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
