# See: https://github.com/NixOS/nixpkgs/blob/master/pkgs/applications/editors/vim/plugins/nvim-treesitter/overrides.nix

{ lib, pkgs, stdenv, fetchFromGitHub, linkFarm, symlinkJoin, ... }:

with lib;

let
  generated = (import ./generated.nix { inherit fetchFromGitHub; }).nvim-treesitter;

  availableParsers = pkgs.callPackage ./parsers { };

  parserName = parser:
    pipe parser [
      getName
      (removeSuffix "-grammar")
      (removePrefix "tree-sitter-")
      (replaceStrings [ "-" ] [ "_" ])
    ];

  withParsers = parserFn:
    let
      parsers = parserFn availableParsers;
      parsersDir = linkFarm "nvim-treesitter-parsers"
        (map
          (parser: {
            name = "parser/${parserName parser}.so";
            path = "${parser}/parser";
          })
          parsers);

      selfWithParsers = symlinkJoin rec {
        name = "${getName self}-with-parsers-${getVersion self}";
        paths = [ self parsersDir ];
        passthru = {
          lazy = (removeAttrs self.lazy [ "dir" "override" ]) // {
            dir = selfWithParsers;
            override = attrs: passthru.lazy // attrs;
          };
        };
      };
    in
    selfWithParsers;

  self = stdenv.mkDerivation rec {
    inherit (generated) pname version src;

    installPhase = ''
      mkdir -p "$out"
      for d in after autoload colors doc ftplugin lua plugin queries syntax types; do
        if [ -d "$d" ]; then
          cp -r "$d" "$out/$d"
        fi
      done
    '';

    dontBuild = true;
    dontFixup = true; # Don't move the doc dir.

    passthru = {
      inherit withParsers;

      lazy = {
        inherit (generated) plugin branch commit;
        dir = self;
      };
      lazy.override = attrs: passthru.lazy // attrs;
    };
  };
in
self
