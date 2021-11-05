[
  rec {
    name = "editorconfig-vim";
    version = "3078cd10b28904e57d878c0d0dab42aa0a9fdc89";

    src = builtins.fetchGit {
      url = "https://github.com/editorconfig/editorconfig-vim";
      rev = version;
    };
  }
]
