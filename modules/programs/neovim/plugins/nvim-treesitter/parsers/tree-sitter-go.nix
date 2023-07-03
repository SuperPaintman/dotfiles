{ buildTreesitterParser, fetchFromGitHub }:

buildTreesitterParser rec {
  language = "go";
  version = "7cccc30535a40da07092626031120ae6b36202d7";

  src = fetchFromGitHub {
    owner = "tree-sitter";
    repo = "tree-sitter-go";
    rev = version;
    sha256 = "sha256-b9735WP4EyU7gGNuKwwt6orIqXWMy4iQDthMKU52pQE=";
  };
}
