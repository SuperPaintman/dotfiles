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

        (local cfgd (vim.fn.expand "~/.config/nvim"))

        ;; fnlfmt: skip
        (set fennel.path (.. fennel.path
                             ";" cfgd :/fnl/?.fnl
                             ";" cfgd :/fnl/?/init.fnl))

        (fn vim-macro-searcher [module-name]
          (let [filename (.. cfgd :/fnl/ (string.gsub module-name "%." "/") :.fnl)]
            (when (= (vim.fn.filereadable filename) 1)
              (let [lines (vim.fn.readfile filename)
                    code (table.concat lines "\n")]
                (values (partial fennel.eval code {:env :_COMPILER}) filename)))))

        (table.insert fennel.macro-searchers vim-macro-searcher)

        (require :init)
      '';
  ".config/nvim/fnl".source = ./fnl;
}
