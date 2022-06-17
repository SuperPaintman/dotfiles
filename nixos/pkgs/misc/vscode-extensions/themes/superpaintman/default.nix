# See: https://github.com/NixOS/nixpkgs/blob/master/pkgs/applications/editors/vscode/extensions/vscode-utils.nix.

{ callPackage }:
let
  themes = callPackage ../../../../../../themes { };
in
themes.applications.vscode.buildVscodeTheme {
  name = "SuperPaintman";
  publisher = "SuperPaintman";
  displayName = "SuperPaintman's theme";
  description = "A custom SuperPaintman's theme";
  icon = ./icon.png;
}
