{ pkgs, lib, ... }:

with pkgs;

let
  colors = import ./colors.nix;

  pkg = import ./package/composition.nix { inherit pkgs; };
in

stdenv.mkDerivation rec {
  name = "vscode-localhost-theme";
  owner = "SuperPaintman";

  src = fetchFromGitHub {
    owner = owner;
    repo = "vscode-monokai-extended";
    rev = "af883a8e1094fe6363148648d8f3ed9db32b9bcc";
    sha256 = "0gq7whqar4mlwbp13avnbhp3f81886r6vlffr4qccszd3vjh8vkj";
  };

  phases = [ "buildPhase" "installPhase" ];

  installPrefix = "share/vscode/extensions/${owner}.${name}";

  buildInputs = with nodePackages; [
    jq
    nodejs
    js-yaml
  ];

  buildPhase = with nodePackages; ''
    # Copy dependencies.
    cp -r ${pkg.package}/lib/node_modules/monokai-extended/node_modules node_modules
    cp -r "$src/package.json" "$src/scripts" ./

    mkdir src themes

    # Patch theme.
    SRC_JQ="$(cat <<EOF
      .name = ${builtins.toJSON name} |
      .".variables".BACKGROUND = ${builtins.toJSON colors.primary.background} |
      .".variables".FOREGROUND = ${builtins.toJSON colors.primary.foreground} |

      .".variables".YELLOW = ${builtins.toJSON colors.normal.yellow} |
      .".variables".BLUE = ${builtins.toJSON colors.normal.blue} |
      .".variables".PURPLE = ${builtins.toJSON colors.normal.magenta} |
      .".variables".RED = ${builtins.toJSON colors.normal.red} |
      .".variables".GREEN = ${builtins.toJSON colors.normal.green}
    EOF
    )"
    ${js-yaml}/bin/js-yaml "$src/src/Monokai-Extended.yml" |
      jq "$SRC_JQ" |
      ${js-yaml}/bin/js-yaml > src/Monokai-Extended.yml

    # Build theme and package.json.
    mkdir -p dist dist/themes

    ${nodejs}/bin/npm run build
    cp themes/Monokai-Extended.json dist/themes/${name}.json

    PACKAGE="$(cat <<EOF
      {
        "name": ${builtins.toJSON name},
        "publisher": ${builtins.toJSON owner},
        "version": "0.0.1",
        "engines": {
          "vscode": "^1.13.0"
        },
        "contributes": {
          "themes": [
            {
              "label": "${name}",
              "uiTheme": "vs-dark",
              "path": "./themes/${name}.json"
            }
          ]
        }
      }
    EOF
    )"
    echo "$PACKAGE" | ${jq}/bin/jq '.' > dist/package.json
  '';

  installPhase = ''
    mkdir -p "$out/$installPrefix"

    cp -r dist/* "$out/$installPrefix"
  '';
}
