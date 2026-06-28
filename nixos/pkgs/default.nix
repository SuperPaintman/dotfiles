{ pkgs, lib, ... }:

with pkgs; rec {
  # Applications.
  _1password = callPackage ./applications/misc/1password/default.nix { };

  prusa-slicer = callPackage ./applications/misc/prusa-slicer/default.nix { };

  rofi-blocks = callPackage ./applications/misc/rofi-blocks { };

  firefox-private = callPackage ./applications/networking/browsers/firefox { };

  gh = callPackage ./applications/version-management/git-and-tools/gh/default.nix { };

  # Development.
  fennel = callPackage ./development/interpreters/fennel {
    lua = luajit;
  };

  fnlfmt = callPackage ./development/tools/fnlfmt {
    inherit fennel;
    lua = luajit;
  };

  rustup-openssl = callPackage ./development/tools/rust/rustup-openssl { };

  # Games.
  anki-desktop = callPackage ./games/anki-desktop { };

  # Misc.
  firefox-install-extensions = callPackage ./misc/firefox-install-extensions { };
  vscode-extensions = callPackage ./misc/vscode-extensions { };

  # OS Specific.
  zsa-udev-rules = callPackage ./os-specific/linux/zsa-udev-rules { };

  # Tools.
  difftastic = callPackage ./tools/text/difftastic { };
}
