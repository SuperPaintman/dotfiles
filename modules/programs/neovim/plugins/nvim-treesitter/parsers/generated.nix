{ fetchgit, ... }:

{
  tree-sitter-bash = {
    pname = "tree-sitter-bash";
    version = "0.0.0+rev=4936467";
    src = fetchgit {
      url = "https://github.com/tree-sitter/tree-sitter-bash";
      rev = "493646764e7ad61ce63ce3b8c59ebeb37f71b841";
      sha256 = "sha256-fI/IMG0O/r6EeFpGfL4OFptxkuwubSvV2rstWwuUIWk=";
    };
    language = "bash";
  };

  tree-sitter-c = {
    pname = "tree-sitter-c";
    version = "0.0.0+rev=84bdf40";
    src = fetchgit {
      url = "https://github.com/tree-sitter/tree-sitter-c";
      rev = "84bdf409067676dd5c003b2a7cb7760456e731bf";
      sha256 = "sha256-dm6Hn3KOCRLWRCUxg0tOOXKz2znOMIqlsHkFPFHlkh4=";
    };
    language = "c";
  };

  tree-sitter-comment = {
    pname = "tree-sitter-comment";
    version = "0.0.0+rev=c9a7e2d";
    src = fetchgit {
      url = "https://github.com/stsewd/tree-sitter-comment";
      rev = "c9a7e2df7cac2dfb730f766a4f343308f84ff346";
      sha256 = "sha256-7k2LkfzlY+UxQvB1dPP6KQM2UTwThaj5NoAIKDVYAhA=";
    };
    language = "comment";
  };

  tree-sitter-cpp = {
    pname = "tree-sitter-cpp";
    version = "0.0.0+rev=0e7b7a0";
    src = fetchgit {
      url = "https://github.com/tree-sitter/tree-sitter-cpp";
      rev = "0e7b7a02b6074859b51c1973eb6a8275b3315b1d";
      sha256 = "sha256-s5QRDs4W8TpB+kWtwXIvanP+Ii7hQgUI/yu0rvDUIg4=";
    };
    generate = true;
    language = "cpp";
  };

  tree-sitter-css = {
    pname = "tree-sitter-css";
    version = "0.0.0+rev=769203d";
    src = fetchgit {
      url = "https://github.com/tree-sitter/tree-sitter-css";
      rev = "769203d0f9abe1a9a691ac2b9fe4bb4397a73c51";
      sha256 = "sha256-5Qti/bFac2A1PJxqZEOuSLK3GGKYwPDKAp3OOassBxU=";
    };
    language = "css";
  };

  tree-sitter-diff = {
    pname = "tree-sitter-diff";
    version = "0.0.0+rev=f69bde8";
    src = fetchgit {
      url = "https://github.com/the-mikedavis/tree-sitter-diff";
      rev = "f69bde8e56f431863eba2fe4bab23e7d9692855f";
      sha256 = "sha256-MFVXhnNxmGtqu8Y8ciigu/AIi15maPQjnJduBm7iCQI=";
    };
    language = "diff";
  };

  tree-sitter-dockerfile = {
    pname = "tree-sitter-dockerfile";
    version = "0.0.0+rev=fd30df6";
    src = fetchgit {
      url = "https://github.com/camdencheek/tree-sitter-dockerfile";
      rev = "fd30df68c4178964ed012ef7f745055db76f8ebf";
      sha256 = "sha256-k5KQ0GfTveXadgQk0xay2QY7uCvFYneQ/0AKwZqAG48=";
    };
    language = "dockerfile";
  };

  tree-sitter-git_config = {
    pname = "tree-sitter-git_config";
    version = "0.0.0+rev=a01b498";
    src = fetchgit {
      url = "https://github.com/the-mikedavis/tree-sitter-git-config";
      rev = "a01b498b25003d97a5f93b0da0e6f28307454347";
      sha256 = "sha256-9gLmao4zmDYj7uxrngjMa4AG9yIkKyptgaCBcL4GZYA=";
    };
    language = "git_config";
  };

  tree-sitter-git_rebase = {
    pname = "tree-sitter-git_rebase";
    version = "0.0.0+rev=d8a4207";
    src = fetchgit {
      url = "https://github.com/the-mikedavis/tree-sitter-git-rebase";
      rev = "d8a4207ebbc47bd78bacdf48f883db58283f9fd8";
      sha256 = "sha256-mbRu2+wZVf5Nk3XlFvLSBOUg2QqmCR2tqO7gLpOJ45k=";
    };
    language = "git_rebase";
  };

  tree-sitter-gitattributes = {
    pname = "tree-sitter-gitattributes";
    version = "0.0.0+rev=577a075";
    src = fetchgit {
      url = "https://github.com/ObserverOfTime/tree-sitter-gitattributes";
      rev = "577a075d46ea109905c5cb6179809df88da61ce9";
      sha256 = "sha256-gBfLmNf7aaqMY3yMF7svFuqif43BAmmY1yYkvVcNUhI=";
    };
    language = "gitattributes";
  };

  tree-sitter-gitcommit = {
    pname = "tree-sitter-gitcommit";
    version = "0.0.0+rev=6856a5f";
    src = fetchgit {
      url = "https://github.com/gbprod/tree-sitter-gitcommit";
      rev = "6856a5fd0ffeff17d83325a8ce4e57811010eff1";
      sha256 = "sha256-OD+lGLsMRFRPHwnXoM78t95QvjO0OQN4ae3z3wy5DO4=";
    };
    language = "gitcommit";
  };

  tree-sitter-gitignore = {
    pname = "tree-sitter-gitignore";
    version = "0.0.0+rev=f4685bf";
    src = fetchgit {
      url = "https://github.com/shunsambongi/tree-sitter-gitignore";
      rev = "f4685bf11ac466dd278449bcfe5fd014e94aa504";
      sha256 = "sha256-QTydw6kLmpQ8bLjkEUzbRnkx0WxPTHiy9moQAk8dQt0=";
    };
    language = "gitignore";
  };

  tree-sitter-go = {
    pname = "tree-sitter-go";
    version = "0.0.0+rev=7a4edcb";
    src = fetchgit {
      url = "https://github.com/tree-sitter/tree-sitter-go";
      rev = "7a4edcbc376302efa8d6ba7e235070ab7ee3c4c8";
      sha256 = "sha256-VvMsFU/HSccB7JetiuNj3O+K/vm6bmDwGWhozyec4Vc=";
    };
    language = "go";
  };

  tree-sitter-gomod = {
    pname = "tree-sitter-gomod";
    version = "0.0.0+rev=4a65743";
    src = fetchgit {
      url = "https://github.com/camdencheek/tree-sitter-go-mod";
      rev = "4a65743dbc2bb3094114dd2b43da03c820aa5234";
      sha256 = "sha256-znvUD/xqwSUeHCDxwXIgPXiB94bY1wEOjRQSvURcdME=";
    };
    language = "gomod";
  };

  tree-sitter-gosum = {
    pname = "tree-sitter-gosum";
    version = "0.0.0+rev=e2ac513";
    src = fetchgit {
      url = "https://github.com/amaanq/tree-sitter-go-sum";
      rev = "e2ac513b2240c7ff1069ae33b2df29ce90777c11";
      sha256 = "sha256-2foA2sd5PQpmeX8OhXrW/dxoJaEyxDXzPWh+UD0dgzQ=";
    };
    language = "gosum";
  };

  tree-sitter-gowork = {
    pname = "tree-sitter-gowork";
    version = "0.0.0+rev=949a8a4";
    src = fetchgit {
      url = "https://github.com/omertuc/tree-sitter-go-work";
      rev = "949a8a470559543857a62102c84700d291fc984c";
      sha256 = "sha256-Tode7W05xaOKKD5QOp3rayFgLEOiMJUeGpVsIrizxto=";
    };
    language = "gowork";
  };

  tree-sitter-html = {
    pname = "tree-sitter-html";
    version = "0.0.0+rev=d2592b0";
    src = fetchgit {
      url = "https://github.com/tree-sitter/tree-sitter-html";
      rev = "d2592b006e5270a281c6bafdbcb3768cd97fa47a";
      sha256 = "sha256-COWv6rCcA2Km2N+D6kperFlmPr31AnWaPR6uMCWwFr4=";
    };
    language = "html";
  };

  tree-sitter-http = {
    pname = "tree-sitter-http";
    version = "0.0.0+rev=6824a24";
    src = fetchgit {
      url = "https://github.com/rest-nvim/tree-sitter-http";
      rev = "6824a247d1326079aab4fa9f9164e9319678081d";
      sha256 = "sha256-QYSdrngNBvDNYpPJ1da4pzXk8PtBidn+u0KPLmm7EW4=";
    };
    generate = true;
    language = "http";
  };

  tree-sitter-java = {
    pname = "tree-sitter-java";
    version = "0.0.0+rev=c194ee5";
    src = fetchgit {
      url = "https://github.com/tree-sitter/tree-sitter-java";
      rev = "c194ee5e6ede5f26cf4799feead4a8f165dcf14d";
      sha256 = "sha256-PNR1XajfELQuwYvCHm8778TzeUlxb9D+HrVF26lQk2E=";
    };
    language = "java";
  };

  tree-sitter-javascript = {
    pname = "tree-sitter-javascript";
    version = "0.0.0+rev=5720b24";
    src = fetchgit {
      url = "https://github.com/tree-sitter/tree-sitter-javascript";
      rev = "5720b249490b3c17245ba772f6be4a43edb4e3b7";
      sha256 = "sha256-rSkLSXdthOS9wzXsC8D1Z1P0vmOT+APzeesvlN7ta6U=";
    };
    language = "javascript";
  };

  tree-sitter-jq = {
    pname = "tree-sitter-jq";
    version = "0.0.0+rev=13990f5";
    src = fetchgit {
      url = "https://github.com/flurie/tree-sitter-jq";
      rev = "13990f530e8e6709b7978503da9bc8701d366791";
      sha256 = "sha256-pek2Vg1osMYAdx6DfVdZhuIDb26op3i2cfvMrf5v3xY=";
    };
    language = "jq";
  };

  tree-sitter-jsdoc = {
    pname = "tree-sitter-jsdoc";
    version = "0.0.0+rev=189a6a4";
    src = fetchgit {
      url = "https://github.com/tree-sitter/tree-sitter-jsdoc";
      rev = "189a6a4829beb9cdbe837260653b4a3dfb0cc3db";
      sha256 = "sha256-Zhl9mEpJE9Qy3MVScE2JK4i8OFZUXl5KMhKMS4bw+mI=";
    };
    language = "jsdoc";
  };

  tree-sitter-json = {
    pname = "tree-sitter-json";
    version = "0.0.0+rev=40a81c0";
    src = fetchgit {
      url = "https://github.com/tree-sitter/tree-sitter-json";
      rev = "40a81c01a40ac48744e0c8ccabbaba1920441199";
      sha256 = "sha256-fZNftzNavJQPQE4S1VLhRyGQRoJgbWA5xTPa8ZI5UX4=";
    };
    language = "json";
  };

  tree-sitter-json5 = {
    pname = "tree-sitter-json5";
    version = "0.0.0+rev=5dd5cdc";
    src = fetchgit {
      url = "https://github.com/Joakker/tree-sitter-json5";
      rev = "5dd5cdc418d9659682556b6adca2dd9ace0ac6d2";
      sha256 = "sha256-B3wZS/OtW4hKOHsoYdYK2zsJGID8fuIm8C+IuAteR9E=";
    };
    language = "json5";
  };

  tree-sitter-llvm = {
    pname = "tree-sitter-llvm";
    version = "0.0.0+rev=d47c95d";
    src = fetchgit {
      url = "https://github.com/benwilliamgraham/tree-sitter-llvm";
      rev = "d47c95d78ef0e7495a74d214dd6fcddf6e402dfc";
      sha256 = "sha256-CK7f0qSAsec2cuQElXLFRQ5uiQLGCyEpNIKTIDwbBrU=";
    };
    language = "llvm";
  };

  tree-sitter-lua = {
    pname = "tree-sitter-lua";
    version = "0.0.0+rev=7268c1c";
    src = fetchgit {
      url = "https://github.com/MunifTanjim/tree-sitter-lua";
      rev = "7268c1cea5df56ac0c779cd37d6631d4e6f41d4f";
      sha256 = "sha256-GrRHbNVKijYNeICeopVW6OtHquqKhKtDDa7dK5sEMNQ=";
    };
    language = "lua";
  };

  tree-sitter-luadoc = {
    pname = "tree-sitter-luadoc";
    version = "0.0.0+rev=8981072";
    src = fetchgit {
      url = "https://github.com/amaanq/tree-sitter-luadoc";
      rev = "8981072676ec8bd74def6134be4f883655f7c082";
      sha256 = "sha256-HRHZDX0/duvQza0SJwCI/uKO0d12VYtvpuYB+KCkfow=";
    };
    language = "luadoc";
  };

  tree-sitter-make = {
    pname = "tree-sitter-make";
    version = "0.0.0+rev=a4b9187";
    src = fetchgit {
      url = "https://github.com/alemuller/tree-sitter-make";
      rev = "a4b9187417d6be349ee5fd4b6e77b4172c6827dd";
      sha256 = "sha256-qQqapnKKH5X8rkxbZG5PjnyxvnpyZHpFVi/CLkIn/x0=";
    };
    language = "make";
  };

  tree-sitter-nix = {
    pname = "tree-sitter-nix";
    version = "0.0.0+rev=02878b4";
    src = fetchgit {
      url = "https://github.com/cstrahan/tree-sitter-nix";
      rev = "02878b40ac77d2889833519c6b6e9e63cfc690e6";
      sha256 = "sha256-9E4iQ7jr52ckmQJBrF9Vdwanrgm2I+Gi1lbC46I+4/g=";
    };
    language = "nix";
  };

  tree-sitter-org = {
    pname = "tree-sitter-org";
    version = "0.0.0+rev=64cfbc2";
    src = fetchgit {
      url = "https://github.com/milisims/tree-sitter-org";
      rev = "64cfbc213f5a83da17632c95382a5a0a2f3357c1";
      sha256 = "sha256-/03eZBbv23W5s/GbDgPgaJV5TyK+/lrWUVeINRS5wtA=";
    };
    language = "org";
  };

  tree-sitter-proto = {
    pname = "tree-sitter-proto";
    version = "0.0.0+rev=42d82fa";
    src = fetchgit {
      url = "https://github.com/mitchellh/tree-sitter-proto";
      rev = "42d82fa18f8afe59b5fc0b16c207ee4f84cb185f";
      sha256 = "sha256-cX+0YARIa9i8UymPPviyoj+Wh37AFYl9fsoNZMQXPgA=";
    };
    language = "proto";
  };

  tree-sitter-python = {
    pname = "tree-sitter-python";
    version = "0.0.0+rev=36f9e33";
    src = fetchgit {
      url = "https://github.com/tree-sitter/tree-sitter-python";
      rev = "36f9e33d52b7572536ac1a8af8d7e78363ad52c3";
      sha256 = "sha256-pUxVuG1xjjXxVWfh6UPZ2WZ5jo3GXmWKrCHSiMnCM+M=";
    };
    language = "python";
  };

  tree-sitter-query = {
    pname = "tree-sitter-query";
    version = "0.0.0+rev=3a9808b";
    src = fetchgit {
      url = "https://github.com/nvim-treesitter/tree-sitter-query";
      rev = "3a9808b22742d5bd906ef5d1a562f2f1ae57406d";
      sha256 = "sha256-5N7FT0HTK3xzzhAlk3wBOB9xlEpKSNIfakgFnsxEi18=";
    };
    language = "query";
  };

  tree-sitter-rasi = {
    pname = "tree-sitter-rasi";
    version = "0.0.0+rev=371dac6";
    src = fetchgit {
      url = "https://github.com/Fymyte/tree-sitter-rasi";
      rev = "371dac6bcce0df5566c1cfebde69d90ecbeefd2d";
      sha256 = "sha256-2nYZoLcrxxxiOJEySwHUm93lzMg8mU+V7LIP63ntFdA=";
    };
    language = "rasi";
  };

  tree-sitter-regex = {
    pname = "tree-sitter-regex";
    version = "0.0.0+rev=e1cfca3";
    src = fetchgit {
      url = "https://github.com/tree-sitter/tree-sitter-regex";
      rev = "e1cfca3c79896ff79842f057ea13e529b66af636";
      sha256 = "sha256-lDsr3sLrLf6wXu/juIA+bTtv1SBo+Jgwqw/6yBAE0kg=";
    };
    language = "regex";
  };

  tree-sitter-rust = {
    pname = "tree-sitter-rust";
    version = "0.0.0+rev=0a70e15";
    src = fetchgit {
      url = "https://github.com/tree-sitter/tree-sitter-rust";
      rev = "0a70e15da977489d954c219af9b50b8a722630ee";
      sha256 = "sha256-CrNY+4nsYQOzzVR7X+yuo4+5s6K3VHtVQyWfledKJ1U=";
    };
    language = "rust";
  };

  tree-sitter-sql = {
    pname = "tree-sitter-sql";
    version = "0.0.0+rev=5bf5e52";
    src = fetchgit {
      url = "https://github.com/derekstride/tree-sitter-sql";
      rev = "5bf5e5256949b5d0b1bfecd9ac7ee86630760aea";
      sha256 = "sha256-vj5nE7fi1Y/d0rRK25qFHShpWrIFKBEHs/tVEP/gK0I=";
    };
    language = "sql";
  };

  tree-sitter-starlark = {
    pname = "tree-sitter-starlark";
    version = "0.0.0+rev=504ddd7";
    src = fetchgit {
      url = "https://github.com/amaanq/tree-sitter-starlark";
      rev = "504ddd75ecc78fbbce22aa6facd70375d3f8854a";
      sha256 = "sha256-ourTH45q4X0CxDAVGhwK5XgeWNhS4SRtc4qyUF+H+RQ=";
    };
    language = "starlark";
  };

  tree-sitter-svelte = {
    pname = "tree-sitter-svelte";
    version = "0.0.0+rev=697bb51";
    src = fetchgit {
      url = "https://github.com/Himujjal/tree-sitter-svelte";
      rev = "697bb515471871e85ff799ea57a76298a71a9cca";
      sha256 = "sha256-TJVAQULTBTZxVwvpBpFmBPJM1jh2aN+KG8YfuT+/ylg=";
    };
    language = "svelte";
  };

  tree-sitter-terraform = {
    pname = "tree-sitter-terraform";
    version = "0.0.0+rev=becebeb";
    src = fetchgit {
      url = "https://github.com/MichaHoffmann/tree-sitter-hcl";
      rev = "becebebd3509c02e871c99be55556269be1def1b";
      sha256 = "sha256-GR2a+VuhZVMGmLW9Mg7bSALNsy0SyfG+YVaRz1qY6a0=";
    };
    language = "terraform";
    location = "dialects/terraform";
  };

  tree-sitter-thrift = {
    pname = "tree-sitter-thrift";
    version = "0.0.0+rev=d4deb1b";
    src = fetchgit {
      url = "https://github.com/duskmoon314/tree-sitter-thrift";
      rev = "d4deb1bd9e848f2dbe81103a151d99e8546de480";
      sha256 = "sha256-MCa7319E8bo3r2kDClBmjOvvs+yZDlE1E+52WqJqvMI=";
    };
    language = "thrift";
  };

  tree-sitter-toml = {
    pname = "tree-sitter-toml";
    version = "0.0.0+rev=8bd2056";
    src = fetchgit {
      url = "https://github.com/ikatyang/tree-sitter-toml";
      rev = "8bd2056818b21860e3d756b5a58c4f6e05fb744e";
      sha256 = "sha256-fMjpFBN4m46HC1crLkiQJumRKEGdHJaVMxFtpqAHKTg=";
    };
    generate = true;
    language = "toml";
  };

  tree-sitter-tsx = {
    pname = "tree-sitter-tsx";
    version = "0.0.0+rev=3429d8c";
    src = fetchgit {
      url = "https://github.com/tree-sitter/tree-sitter-typescript";
      rev = "3429d8c77d7a83e80032667f0642e6cb19d0c772";
      sha256 = "sha256-qMzxxCx7u8fp+LhlSg6rvK0vMa0SXnJqSc4hgLcpZ7U=";
    };
    generate = true;
    language = "tsx";
    location = "tsx";
  };

  tree-sitter-typescript = {
    pname = "tree-sitter-typescript";
    version = "0.0.0+rev=3429d8c";
    src = fetchgit {
      url = "https://github.com/tree-sitter/tree-sitter-typescript";
      rev = "3429d8c77d7a83e80032667f0642e6cb19d0c772";
      sha256 = "sha256-qMzxxCx7u8fp+LhlSg6rvK0vMa0SXnJqSc4hgLcpZ7U=";
    };
    generate = true;
    language = "typescript";
    location = "typescript";
  };

  tree-sitter-vim = {
    pname = "tree-sitter-vim";
    version = "0.0.0+rev=26b1aea";
    src = fetchgit {
      url = "https://github.com/neovim/tree-sitter-vim";
      rev = "26b1aea3b3a5dae31f784a1204205fd57f2b82b5";
      sha256 = "sha256-NS6Ao2eK+7/NW7QufXiX2oBBLgGDLZX3PuPKezC+Quc=";
    };
    language = "vim";
  };

  tree-sitter-vimdoc = {
    pname = "tree-sitter-vimdoc";
    version = "0.0.0+rev=c0f8580";
    src = fetchgit {
      url = "https://github.com/neovim/tree-sitter-vimdoc";
      rev = "c0f85802485afe4d15e65bbf995ae864bb8ed7c4";
      sha256 = "sha256-pBdfFeJbZJy6pjr2a0SgFyjEZKvajKOfrqoRAMB66V8=";
    };
    language = "vimdoc";
  };

  tree-sitter-yaml = {
    pname = "tree-sitter-yaml";
    version = "0.0.0+rev=0e36bed";
    src = fetchgit {
      url = "https://github.com/ikatyang/tree-sitter-yaml";
      rev = "0e36bed171768908f331ff7dff9d956bae016efb";
      sha256 = "sha256-16HfHpyba8cemHhJfySO7V97eBdoqVoVOM6Z7Qm4fYw=";
    };
    language = "yaml";
  };
}
