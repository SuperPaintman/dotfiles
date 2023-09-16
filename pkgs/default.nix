{ pkgs }:

let
  inherit (pkgs) callPackage;
in

{
  extras = callPackage ./extras { };
  godot_4 = callPackage ./godot/4 { };
  wtk = callPackage ./wtk { };
}
