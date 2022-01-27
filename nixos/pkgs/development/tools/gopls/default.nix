{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "gopls";
  # version = "0.7.5";
  version = "845bb90a1df4ce4789c794479a29a4ea07e12414";

  src = fetchFromGitHub {
    owner = "golang";
    repo = "tools";
    # rev = "gopls/v${version}";
    rev = version;
    sha256 = "1nyrr8xynbl621aqpgfa11hql7l81sih9q14svw3d91jpz3q0knr";
  };

  modRoot = "gopls";
  # vendorSha256 = "sha256-nKjJjtVHk/RLIHI/5v8tO3RcaLLZhr0A6llYGsB0ifQ=";
  vendorSha256 = "1yjc8qr5y5hik2c5qfax4pbd8c1nmsnmlamzbdawcfambanasdn3";

  doCheck = false;

  # Only build gopls, and not the integration tests or documentation generator.
  subPackages = [ "." ];

  meta = with lib; {
    description = "Official language server for the Go language";
    homepage = "https://github.com/golang/tools/tree/master/gopls";
    license = licenses.bsd3;
    maintainers = with maintainers; [ mic92 SuperSandro2000 zimbatm ];
  };
}
