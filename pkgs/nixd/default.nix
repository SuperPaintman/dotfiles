{ pkgs, callPackage, fetchFromGitHub }:

let
  src = fetchFromGitHub {
    owner = "nix-community";
    repo = "nixd";
    rev = "1.2.2";
    sha256 = "sha256-W44orkPZQ9gDUTogb8YVIaw4WHzUA+ExOXhTnZlJ6yY=";
  };
in

callPackage src (with pkgs; {
  nix = nixVersions.nix_2_16;
  llvmPackages = llvmPackages_16;
})

