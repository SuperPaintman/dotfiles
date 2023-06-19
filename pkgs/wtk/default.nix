{ buildGoModule }:

buildGoModule rec {
  name = "wtk";

  src = ./.;

  subPackages = [ "cmd/wtk" ];

  vendorSha256 = "sha256-gIP8xjK4+R0hKMFExevdnpS3LUNBwctBUJQlAA1AaIE=";
}
