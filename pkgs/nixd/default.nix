{ pkgs, callPackage, fetchFromGitHub }:

let
  src = fetchFromGitHub {
    owner = "nix-community";
    repo = "nixd";
    rev = "1.2.3";
    sha256 = "sha256-i/z5VnsWPWloQfdk48i+a4XaGnTMPJ6QougChkT9IWw=";
  };
in

callPackage src (with pkgs; {
  nix = nixVersions.nix_2_18;
  llvmPackages = llvmPackages_16;
})

