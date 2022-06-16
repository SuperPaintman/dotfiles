{ pkgs, newScope, lib, colors ? null }:
let
  scope = {
    inherit callPackage applications themes;
    colors = chosenColors;
  };

  callPackage = newScope scope;

  defaultColors = callPackage ./colors { };

  chosenColors =
    if colors != null
    then colors
    else defaultColors;

  applications = callPackage ./applications { };

  themes = builtins.removeAttrs scope [ "themes" ];
in
themes
