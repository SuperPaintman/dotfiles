{ fetchgit }:

let
  fetchNixpkgs = branchName: rev: extra: fetchgit ({
    url = "https://github.com/NixOS/nixpkgs";
    inherit rev branchName;
    hash = "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=";
  } // extra);
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
  lua-language-server = fetchNixpkgs "nixos-26.05" "8b95275958abd62abce43ea225e31dc6509e7f53" {
    hash = "sha256-+5hI0S5SRhxC3i1cQSGMMygek146bH5ZKhBfjCsCbsU";
    sparseCheckout = [
      "pkgs/by-name/lu/lua-language-server"
    ];
  };

  # See: https://github.com/NixOS/nixpkgs/tree/nixos-26.05/pkgs/development/compilers/go
  # Version: 1.26.4
  go = fetchNixpkgs "nixos-26.05" "9552f12458a53de5dee31412bb501be68f08dfdc" {
    hash = "sha256-+7ZMS+G5O2GULxgWCVs7GU4pZ3LFilv+Z9VBHgkxn9o=";
    sparseCheckout = [
      "pkgs/development/compilers/go"
      "pkgs/build-support/go"
    ];
  };

  # See: https://github.com/NixOS/nixpkgs/blob/nixos-26.05/pkgs/by-name/go/gopls/package.nix
  # Version: 0.22.0
  gopls = fetchNixpkgs "nixos-26.05" "14250b148040522fc0e7683fe9c1518c3624a375" {
    hash = "sha256-XSr5wiRpmLmE4Fi4F5OnYL7ZMrV9VD0JEUPDTOu2Nsw=";
    sparseCheckout = [
      "pkgs/by-name/go/gopls"
    ];
  };

  # See: https://github.com/NixOS/nixpkgs/blob/nixos-26.05/pkgs/development/compilers/zig/default.nix
  # Version: 0.16.0
  zig = fetchNixpkgs "nixos-26.05" "1373ce18abcd332baa4fb43930a5cb35a95543bb" {
    hash = "sha256-hIh40ZXZLic92xfdPXddoh2m31Hv5M6yfmqzdgd3Jf4=";
    sparseCheckout = [
      "pkgs/development/compilers/zig"
    ];
  };

  # See: https://github.com/NixOS/nixpkgs/blob/nixos-26.05/pkgs/development/tools/zls/default.nix
  # Version: 0.16.0
  zls = fetchNixpkgs "nixos-26.05" "278d50f1344ff9b279e6a395927fc3d6cb5005bc" {
    hash = "sha256-Rn1MnIfIqG2m1STFe0RX2FnzhQuYDVQ2ciQyW1UsX/M=";
    sparseCheckout = [
      "pkgs/development/tools/zls"
    ];
  };
}
