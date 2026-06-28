{ pkgs }:

let
  inherit (pkgs) callPackage;
in

rec {
  bubblewrap-copilot = callPackage ./bubblewrap-copilot { };
  extras = callPackage ./extras { };
  gdsdecomp = callPackage ./gdsdecomp { };
  gdtoolkit_4 = callPackage ./gdtoolkit/4 { };
  godot_3 = callPackage ./godot/3 { };
  godot_4 = callPackage ./godot/4 { };
  godot = godot_3;
  pico8 = callPackage ./pico8 { };
  spine = callPackage ./spine { };
  wtk = callPackage ./wtk { };
}
