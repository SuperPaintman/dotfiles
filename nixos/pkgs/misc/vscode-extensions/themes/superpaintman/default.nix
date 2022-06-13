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

  flattenAttrs' = sep: prefix: set:
    let
      names = builtins.attrNames set;
    in
    lib.flatten (
      map
        (name:
          let
            value = set.${name};
          in
          if builtins.isAttrs value
          then flattenAttrs' sep "${prefix}${name}${sep}" value
          else [{ name = "${prefix}${name}"; value = value; }]
        )
        names
    );

  flattenAttrs = set: builtins.listToAttrs (flattenAttrs' "." "" set);

  theme' = builtins.removeAttrs (pkgs.callPackage ./theme.nix { }) [ "override" "overrideDerivation" ];

  theme = {
    inherit (theme') author name tokenColors;

    colors = flattenAttrs theme'.colors;
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

    cat <<EOF > extension/package.json
    ${builtins.toJSON package}
    EOF

    cp ${./icon.png} extension/icon.png

    cat <<EOF > extension/themes/theme.json
    ${builtins.toJSON theme}
    EOF
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p "$out/$installPrefix"
    find extension -mindepth 1 -maxdepth 1 | xargs -d'\n' mv -t "$out/$installPrefix/"

    runHook postInstall
  '';
}
