{ pkgs }:

let
  inherit (pkgs) callPackage;
in

{
  extras = callPackage ./extras { };
  wtk = callPackage ./wtk { };
}
