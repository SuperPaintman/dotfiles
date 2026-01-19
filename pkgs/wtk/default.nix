{ buildGoModule }:

buildGoModule rec {
  name = "wtk";

  src = ./.;

  subPackages = [ "cmd/wtk" ];

  vendorHash = "sha256-gIP8xjK4+R0hKMFExevdnpS3LUNBwctBUJQlAA1AaIE=";
}
