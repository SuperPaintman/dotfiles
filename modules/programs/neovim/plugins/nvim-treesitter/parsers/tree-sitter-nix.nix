{ buildTreesitterParser, fetchFromGitHub }:

buildTreesitterParser rec {
  language = "nix";
  version = "1b69cf1fa92366eefbe6863c184e5d2ece5f187d";

  src = fetchFromGitHub {
    owner = "nix-community";
    repo = "tree-sitter-nix";
    rev = version;
    sha256 = "sha256-JaJRikijCXnKAuKA445IIDaRvPzGhLFM29KudaFsSVM=";
  };
}
