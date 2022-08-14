{ pkgs ? import <nixpkgs> { }, ... }:


with builtins;
with pkgs.lib;
let
  inherit (pkgs) lib stdenv;

  fennel = stdenv.mkDerivation rec {
    name = "fennel";
    version = "1.1.0";

    src = fetchTarball {
      url = "https://fennel-lang.org/downloads/${name}-${version}.tar.gz";
      sha256 = "1m4sv8lq26dyx8vvq9l6rv7j9wd20ychyqddrb0skfi14ccb3bhx";
    };

    buildInputs = [
      pkgs.luajit
    ];

    phases = "installPhase";
    installPhase = ''
      mkdir -p $out $out/bin
      cp $src/fennel $out/bin/fennel
      cp $src/fennel.lua $out/fennel.lua
      chmod +x $out/bin/fennel
      sed -i 's%^#!/usr/bin/env lua$%#!${pkgs.luajit}/bin/luajit%' $out/bin/fennel
    '';

    meta = {
      homepage = "https://github.com/bakpakin/Fennel";
      description = "Lua Lisp Language";
      license = lib.licenses.mit;
      platforms = [ "x86_64-linux" ];
      maintainers = [ ];
    };
  };

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
        "${fennel}/?.lua"
        "${fennel}/?/init.lua"
      ];
    in
    mkFennelFile "nvim-init-fnl" ''
      ${appendPackagePath paths}

      (local fennel (require :fennel))
      (table.insert (or package.loaders package.searchers) fennel.searcher)
      (set debug.traceback fennel.traceback)

      (let [cfgd (vim.fn.expand "~/.config/nvim")]
        (set fennel.path (.. fennel.path
                             ";" cfgd "/fnl/?.fnl"
                             ";" cfgd "/fnl/?/init.fnl")))

      (require :init)
    '';
  ".config/nvim/fnl/init.fnl".source = ./init.fnl;
}
