{ pkgs, lib, neovim, ... }:

with lib;

let
  inherit (pkgs) callPackage;

  buildNeovimPlugin = callPackage ./build.nix { inherit neovim; };

  generated = import ./generated.nix { inherit (pkgs) fetchFromGitHub; };
  generatedPlugins = mapAttrs
    (name: makeOverridable buildNeovimPlugin)
    generated;

  installDirs = concatMapStringsSep "\n" (dir: ''
    if [ -d ${escapeShellArg dir} ]; then
      cp -r ${escapeShellArg dir} "$out/"
    fi
  '');
in

generatedPlugins // {
  lazy-nvim = callPackage ./lazy-nvim { inherit neovim; };

  nvim-treesitter = callPackage ./nvim-treesitter { inherit neovim; };

  copilot-lua = generatedPlugins.copilot-lua.override {
    installPhase = installDirs [
      "copilot" # JS and WASM files.
    ];

    patches = [
      ./copilot-lua/0001-copilot-custom-distributions.patch
    ];
  };
}
