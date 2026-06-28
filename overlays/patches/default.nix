{ final, prev }:

let
  pkgs = final;
  inherit (pkgs) callPackage;
in

rec {
  firefox = callPackage ./firefox { inherit (prev) firefox; };

  rustup = callPackage ./rustup { inherit (prev) rustup; };
}
