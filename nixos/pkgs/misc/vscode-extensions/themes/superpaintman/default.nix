# See: https://github.com/NixOS/nixpkgs/blob/master/pkgs/applications/editors/vscode/extensions/vscode-utils.nix.

{ stdenv, pkgs, lib }:
let
  package = rec {
    name = "themes-superpaintman";
    publisher = "SuperPaintman";
    displayName = "SuperPaintman's theme";
    description = "A custom SuperPaintman's theme";
    version = "0.1.0";
    private = true;
    engines.vscode = "^1.12.0";
    categories = [ "Themes" ];
    icon = "icon.png";
    contributes.themes = [{
      label = "SuperPaintman";
      uiTheme = "vs-dark";
      path = "./themes/theme.json";
    }];



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
          if value ? gui
          then [{ name = "${prefix}${name}"; value = value.gui; }]
          else normalizeColors' "${prefix}${name}." value
        )
        names
    );

  normalizeColors = set: builtins.listToAttrs (normalizeColors' "" set);

  theme' = builtins.removeAttrs (pkgs.callPackage ./theme2.nix { }) [ "override" "overrideDerivation" ];

  theme = {
    inherit (theme') author name tokenColors;

    colors = normalizeColors theme'.colors;
  };
in
stdenv.mkDerivation rec {
  name = "vscode-extension-${package.publisher}-${package.name}-${package.version}";

  vscodeExtUniqueId = "${package.publisher}.${package.name}";

  installPrefix = "share/vscode/extensions/${vscodeExtUniqueId}";

  dontUnpack = true;
  dontPatchELF = true;
  dontStrip = true;

  buildPhase = ''
    mkdir -p extension/{themes,}

    cat <<EOF | ${pkgs.jq}/bin/jq . > extension/package.json
    ${builtins.toJSON package}
    EOF

    cp ${./icon.png} extension/icon.png

    cat <<EOF | ${pkgs.jq}/bin/jq . > extension/themes/theme.json
    ${builtins.toJSON theme}
    EOF

    ${pkgs.remarshal}/bin/json2yaml extension/themes/theme.json extension/themes/theme.yml
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p "$out/$installPrefix"
    find extension -mindepth 1 -maxdepth 1 | xargs -d'\n' mv -t "$out/$installPrefix/"

    runHook postInstall
  '';
}
