{ pkgs }:

with pkgs;
let tests = {
  lib = callPackage ../lib/default.test.nix { };
};

in
tests
