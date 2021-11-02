{ fetchFromGitHub, rustPlatform }:

rustPlatform.buildRustPackage rec {
  pname = "difftastic";
  version = "0.11.0";

  src = fetchFromGitHub {
    owner = "Wilfred";
    repo = pname;
    rev = version;
    sha256 = "0ci3w0qlz8226kaylmhaynzc1w5crcdyifdccn3x2245jngkbf02";
  };

  cargoSha256 = "1l8mif5zqv9v22dbc36d6z8v71bdpp0jmqgqwliq9rg4gcr0v6pw";

  postInstall = ''
    mv $out/bin/difftastic $out/bin/difft
  '';
}
