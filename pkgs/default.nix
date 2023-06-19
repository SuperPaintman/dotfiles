{ pkgs }:

let
  inherit (pkgs) callPackage;
in

{
  wtk = callPackage ./wtk { };
}
