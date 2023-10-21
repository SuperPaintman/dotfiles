{ pkgs }:

let
  inherit (pkgs) callPackage;
in

rec {
  extras = callPackage ./extras { };
  gdsdecomp = callPackage ./gdsdecomp { };
  gdtoolkit_4 = callPackage ./gdtoolkit/4 { };
  godot = godot_3;
  godot_3 = callPackage ./godot/3 { };
  godot_4 = callPackage ./godot/4 { };
  wtk = callPackage ./wtk { };
}
