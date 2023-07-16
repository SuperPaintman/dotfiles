# See: https://codeberg.org/jeyj0/dotfiles/src/branch/main/packages/lychee-slicer/default.nix

{ fetchurl
, appimageTools
, gsettings-desktop-schemas
, gtk3
, ...
}:

let
  generated = import ./generated.nix { inherit fetchurl; };
in

appimageTools.wrapType2 rec {
  inherit (generated.lychee-slicer) pname version src;

  profile = ''
    export LC_ALL=C.UTF-8
    export XDG_DATA_DIRS="${gsettings-desktop-schemas}/share/gsettings-schemas/${gsettings-desktop-schemas.name}:${gtk3}/share/gsettings-schemas/${gtk3.name}:$XDG_DATA_DIRS"
  '';

  extraPkgs = pkgs: (appimageTools.defaultFhsEnvArgs.multiPkgs pkgs) ++ (with pkgs; [
    # fixes "unexpected error"
    gsettings-desktop-schemas
    glib
    gtk3

    # needed for icons
    gnome.adwaita-icon-theme
  ]);

  extraInstallCommands = ''
    ln -s "$out/bin/${pname}-${version}" "$out/bin/${pname}"
  '';
}
