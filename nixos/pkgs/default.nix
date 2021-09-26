{ pkgs, lib, ... }:

with pkgs; rec {
  # Applications.
  _1password = callPackage ./applications/misc/1password/default.nix { };

  rofi-blocks = callPackage ./applications/misc/rofi-blocks { };

  firefox-private = callPackage ./applications/networking/browsers/firefox { };

  gh = callPackage ./applications/version-management/git-and-tools/gh/default.nix { };

  # Development.
  rustup-openssl = callPackage ./development/tools/rust/rustup-openssl { };

  # Games.
  anki-desktop = callPackage ./games/anki-desktop { };

  # Misc.
  firefox-install-extensions = callPackage ./misc/firefox-install-extensions { };

  # OS Specific.
  zsa-udev-rules = callPackage ./os-specific/linux/zsa-udev-rules { };
}
