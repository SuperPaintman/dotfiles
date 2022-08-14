{ pkgs ? import <nixpkgs> {}, ... }:

with builtins;
with pkgs.lib;
let
  inherit (pkgs) lib stdenv;

  fennel = (pkgs.callPackage ../nixos/pkgs {}).fennel;

  mkFennelFile = name: source: pkgs.runCommand name
    {
      inherit source;
      passAsFile = [ "source" ];
    } ''
    ${fennel}/bin/fennel --compile "$sourcePath" > "$out"
  '';

  appendPackagePath = paths: if length paths == 0 then "" else ''
    (set package.path (.. package.path ";" ${concatStringsSep '' ";" '' (map toJSON paths)}))
  '';
in
{
  # ".config/nvim/init.vim".source = ./init.vim;
  # ".config/nvim/lua/init.lua".source = ./init.lua;
  ".config/nvim/init.lua".source =
    let
      paths = [
        "${fennel}/share/lua/5.1/?.lua"
        "${fennel}/share/lua/5.1/?/init.lua"
      ];
    in
      mkFennelFile "nvim-init-fnl" ''
        ${appendPackagePath paths}

        (local fennel (require :fennel))
        (table.insert (or package.loaders package.searchers) fennel.searcher)
        (set debug.traceback fennel.traceback)

        ;; fnlfmt: skip
        (let [cfgd (vim.fn.expand "~/.config/nvim")]
          (set fennel.path (.. fennel.path
                               ";" cfgd :/fnl/?.fnl
                               ";" cfgd :/fnl/?/init.fnl)))

        (require :init)
      '';
  ".config/nvim/fnl/init.fnl".source = ./init.fnl;
}
