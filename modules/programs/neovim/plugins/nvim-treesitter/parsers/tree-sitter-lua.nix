{ buildTreesitterParser, fetchFromGitHub }:

buildTreesitterParser rec {
  language = "lua";
  version = "7268c1cea5df56ac0c779cd37d6631d4e6f41d4f";

  src = fetchFromGitHub {
    owner = "MunifTanjim";
    repo = "tree-sitter-lua";
    rev = version;
    sha256 = "sha256-GrRHbNVKijYNeICeopVW6OtHquqKhKtDDa7dK5sEMNQ=";
  };
}
