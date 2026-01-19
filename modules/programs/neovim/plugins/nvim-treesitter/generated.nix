{ fetchFromGitHub, ... }:

{
  nvim-treesitter = {
    pname = "nvim-treesitter";
    version = "0.0.0+rev=42fc28b";
    src = fetchFromGitHub {
      owner = "nvim-treesitter";
      repo = "nvim-treesitter";
      rev = "42fc28ba918343ebfd5565147a42a26580579482";
      sha256 = "sha256-CVs9FTdg3oKtRjz2YqwkMr0W5qYLGfVyxyhE3qnGYbI=";
    };
    branch = "master";
    commit = "42fc28ba918343ebfd5565147a42a26580579482";
    plugin = "nvim-treesitter/nvim-treesitter";
  };
}
