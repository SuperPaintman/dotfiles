{ pkgs, lib, ... }:

with pkgs; rec {
  # Applications.
  firefox-private = callPackage ./applications/networking/browsers/firefox { };

  # Games.
  anki-desktop = callPackage ./games/anki-desktop { };

  # Misc.
  firefox-install-extensions = callPackage ./misc/firefox-install-extensions { };
  vscode-extensions = callPackage ./misc/vscode-extensions { };

  # OS Specific.
  zsa-udev-rules = callPackage ./os-specific/linux/zsa-udev-rules { };
}
