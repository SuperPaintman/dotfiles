{ fetchFromGitHub, ... }:

{
  nvim-treesitter = {
    pname = "nvim-treesitter";
    version = "0.0.0+rev=c42a8f9";
    src = fetchFromGitHub {
      owner = "nvim-treesitter";
      repo = "nvim-treesitter";
      rev = "c42a8f96d37be82cf32934c4351150d7736f93f5";
      sha256 = "sha256-GUSu8SIe6+avUY/4HrEFw1mo1fjAsoawbCqQxI3+Z34=";
    };
    branch = "master";
    commit = "c42a8f96d37be82cf32934c4351150d7736f93f5";
    plugin = "nvim-treesitter/nvim-treesitter";
  };
}
