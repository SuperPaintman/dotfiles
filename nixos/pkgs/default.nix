{ pkgs, lib, ... }:

with pkgs; rec {
  # Applications.
  _1password = callPackage ./applications/misc/1password/default.nix { };

  rofi-blocks = callPackage ./applications/misc/rofi-blocks { };

  firefox-private = callPackage ./applications/networking/browsers/firefox { };

  gh = callPackage ./applications/version-management/git-and-tools/gh/default.nix { };

  # Development.
  go_1_18beta1 = callPackage ./development/compilers/go/1.18beta1.nix ({
    inherit (darwin.apple_sdk.frameworks) Security Foundation;
  } // lib.optionalAttrs (stdenv.cc.isGNU && stdenv.isAarch64) {
    stdenv = gcc8Stdenv;
    buildPackages = buildPackages // { stdenv = buildPackages.gcc8Stdenv; };
  });

  buildGo118beta1Module = callPackage ./development/go-modules/generic {
    go = go_1_18beta1;
  };

  gopls = callPackage ./development/tools/gopls {
    buildGoModule =  buildGo118beta1Module;
  };

  rustup-openssl = callPackage ./development/tools/rust/rustup-openssl { };

  # Games.
  anki-desktop = callPackage ./games/anki-desktop { };

  # Misc.
  firefox-install-extensions = callPackage ./misc/firefox-install-extensions { };

  # OS Specific.
  zsa-udev-rules = callPackage ./os-specific/linux/zsa-udev-rules { };

  # Tools.
  difftastic = callPackage ./tools/text/difftastic { };
}
