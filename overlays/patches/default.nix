{ final, prev }:

let
  pkgs = final;
  inherit (pkgs) callPackage;
in

rec {
  rustup = callPackage ./rustup { inherit (prev) rustup; };
}
