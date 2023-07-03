# See: https://github.com/NixOS/nixpkgs/blob/master/pkgs/applications/editors/vim/plugins/nvim-treesitter/overrides.nix

{ lib, pkgs, stdenv, fetchFromGitHub, linkFarm, symlinkJoin, ... }:

with lib;

let
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
          };
          lazy.override = attrs: passthru.lazy // attrs;
        };
      };
    in
    selfWithParsers;

  self = stdenv.mkDerivation rec {
    pname = "nvim-treesitter";
    version = "c42a8f96d37be82cf32934c4351150d7736f93f5";

    src = fetchFromGitHub {
      owner = "nvim-treesitter";
      repo = pname;
      rev = version;
      sha256 = "sha256-GUSu8SIe6+avUY/4HrEFw1mo1fjAsoawbCqQxI3+Z34=";
    };

    installPhase = ''
      mkdir -p "$out"
      cp -r {autoload,doc,lua,plugin,queries} $out
    '';

    dontBuild = true;
    dontFixup = true; # Don't move the doc dir.

    passthru = {
      inherit withParsers;

      lazy = {
        plugin = "nvim-treesitter/${pname}";
        branch = "master";
        commit = "c42a8f96d37be82cf32934c4351150d7736f93f5";
        dir = self;
      };
      lazy.override = attrs: passthru.lazy // attrs;
    };
  };
in
self
