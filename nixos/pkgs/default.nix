{ pkgs, lib, ... }:

with pkgs; rec {
  # Games.
  anki-desktop = callPackage ./games/anki-desktop { };

  # Misc.
  vscode-extensions = callPackage ./misc/vscode-extensions { };

  # OS Specific.
  zsa-udev-rules = callPackage ./os-specific/linux/zsa-udev-rules { };
}
