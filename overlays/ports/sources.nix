# sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=

{ fetchgit }:

let
in

{
  # See: https://github.com/NixOS/nixpkgs/blob/nixos-YY.MM/...
  # Version: X.Y.Z
  # my-package = fetchgit {
  #   url = "https://github.com/NixOS/nixpkgs";
  #   rev = "8b95275958abd62abce43ea225e31dc6509e7f53";
  #   branchName = "nixos-26.05";
  #   hash = "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=";
  #   sparseCheckout = [
  #     # "pkgs/by-name/lu/lua-language-server"
  #   ];
  # };

  # See: https://github.com/NixOS/nixpkgs/blob/nixos-26.05/pkgs/by-name/lu/lua-language-server/package.nix
  # Version: 3.18.1
  lua-language-server = fetchgit {
    url = "https://github.com/NixOS/nixpkgs";
    rev = "8b95275958abd62abce43ea225e31dc6509e7f53";
    branchName = "nixos-26.05";
    hash = "sha256-+5hI0S5SRhxC3i1cQSGMMygek146bH5ZKhBfjCsCbsU";
    sparseCheckout = [
      "pkgs/by-name/lu/lua-language-server"
    ];
  };

  # See: https://github.com/NixOS/nixpkgs/tree/nixos-26.05/pkgs/development/compilers/go
  # Version: 1.26.4
  go = fetchgit {
    url = "https://github.com/NixOS/nixpkgs";
    rev = "9552f12458a53de5dee31412bb501be68f08dfdc";
    branchName = "nixos-26.05";
    hash = "sha256-+7ZMS+G5O2GULxgWCVs7GU4pZ3LFilv+Z9VBHgkxn9o=";
    sparseCheckout = [
      "pkgs/development/compilers/go"
      "pkgs/build-support/go"
    ];
  };

  # See: https://github.com/NixOS/nixpkgs/blob/nixos-26.05/pkgs/by-name/go/gopls/package.nix
  # Version: 0.22.0
  gopls = fetchgit {
    url = "https://github.com/NixOS/nixpkgs";
    rev = "14250b148040522fc0e7683fe9c1518c3624a375";
    branchName = "nixos-26.05";
    hash = "sha256-XSr5wiRpmLmE4Fi4F5OnYL7ZMrV9VD0JEUPDTOu2Nsw=";
    sparseCheckout = [
      "pkgs/by-name/go/gopls"
    ];
  };
}
