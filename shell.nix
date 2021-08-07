{ pkgs ? import <nixpkgs> { } }:

pkgs.mkShell {
  name = "dotfiles";
}
