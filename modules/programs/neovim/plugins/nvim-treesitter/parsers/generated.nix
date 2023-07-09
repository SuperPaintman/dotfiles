{ fetchgit, ... }:

{
  tree-sitter-ada = {
    pname = "tree-sitter-ada";
    version = "0.0.0+rev=ba7951a";
    src = fetchgit {
      url = "https://github.com/briot/tree-sitter-ada";
      rev = "ba7951a8f3fb08f9ea923625153e7670c89f30b4";
      sha256 = "sha256-Rs+7wSsoV9ol0zV8occOeuvJaIofAe7qDXLmOxrjVw0=";
    };
    language = "ada";
  };

  tree-sitter-agda = {
    pname = "tree-sitter-agda";
    version = "0.0.0+rev=80ea622";
    src = fetchgit {
      url = "https://github.com/AusCyberman/tree-sitter-agda";
      rev = "80ea622cf952a0059e168e5c92a798b2f1925652";
      sha256 = "sha256-D63jvITL2RA8yg/TBSi6GsOxwLKzSHibbm3hwIKzesU=";
    };
    language = "agda";
  };

  tree-sitter-arduino = {
    pname = "tree-sitter-arduino";
    version = "0.0.0+rev=bf0db73";
    src = fetchgit {
      url = "https://github.com/ObserverOfTime/tree-sitter-arduino";
      rev = "bf0db73db96ec02f872cb7b5058dcc8bfd8fe714";
      sha256 = "sha256-7naUhZ1xhJfirA4gYYVc36YuvY66PLGRLCqRLQie11o=";
    };
    language = "arduino";
  };

  tree-sitter-astro = {
    pname = "tree-sitter-astro";
    version = "0.0.0+rev=a4535d1";
    src = fetchgit {
      url = "https://github.com/virchau13/tree-sitter-astro";
      rev = "a4535d1530558866a543c1660c90c57fbf2fd709";
      sha256 = "sha256-ZWpxKAyja6bW2kNxalHOL2E+WFbEKc40dMGrB1Ihs6I=";
    };
    language = "astro";
  };

  tree-sitter-awk = {
    pname = "tree-sitter-awk";
    version = "0.0.0+rev=16e6fd8";
    src = fetchgit {
      url = "https://github.com/Beaglefoot/tree-sitter-awk";
      rev = "16e6fd822a5efa654d0a1ad7122aa1cc5e489cff";
      sha256 = "sha256-TbDVyXBcg/0jzs3cFMZCRw7v2iqTfPXmRVBZM4kp0m8=";
    };
    language = "awk";
  };

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

  tree-sitter-bass = {
    pname = "tree-sitter-bass";
    version = "0.0.0+rev=27f110d";
    src = fetchgit {
      url = "https://github.com/amaanq/tree-sitter-bass";
      rev = "27f110dfe79620993f5493ffa0d0f2fe12d250ed";
      sha256 = "sha256-OmYtp2TAsAjw2fgdSezHUrP46b/QXgCbDeJa4ANrtvY=";
    };
    language = "bass";
  };

  tree-sitter-beancount = {
    pname = "tree-sitter-beancount";
    version = "0.0.0+rev=358e5ec";
    src = fetchgit {
      url = "https://github.com/polarmutex/tree-sitter-beancount";
      rev = "358e5ecbb87109eef7fd596ea518a4ff74cb9b31";
      sha256 = "sha256-vz8FU+asnMqF6J4UZer4iecw8uFFiYVpz4Fs/ds4Rt0=";
    };
    language = "beancount";
  };

  tree-sitter-bibtex = {
    pname = "tree-sitter-bibtex";
    version = "0.0.0+rev=ccfd77d";
    src = fetchgit {
      url = "https://github.com/latex-lsp/tree-sitter-bibtex";
      rev = "ccfd77db0ed799b6c22c214fe9d2937f47bc8b34";
      sha256 = "sha256-wgduSxlpbJy/ITenBLfj5lhziUM1BApX6MjXhWcb7lQ=";
    };
    language = "bibtex";
  };

  tree-sitter-bicep = {
    pname = "tree-sitter-bicep";
    version = "0.0.0+rev=3604d8c";
    src = fetchgit {
      url = "https://github.com/amaanq/tree-sitter-bicep";
      rev = "3604d8c961ab129d2bfc6dfca56419c236ccdb83";
      sha256 = "sha256-s0BtyYtC/D8+nudkHxpd4rSPQWrA0FngH9HIX85H/Uw=";
    };
    language = "bicep";
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

  tree-sitter-c_sharp = {
    pname = "tree-sitter-c_sharp";
    version = "0.0.0+rev=1648e21";
    src = fetchgit {
      url = "https://github.com/tree-sitter/tree-sitter-c-sharp";
      rev = "1648e21b4f087963abf0101ee5221bb413107b07";
      sha256 = "sha256-WvkHtw8t14UNqiJvmS9dbGYQSVVzHS9mcWzxq+KLMnU=";
    };
    language = "c_sharp";
  };

  tree-sitter-capnp = {
    pname = "tree-sitter-capnp";
    version = "0.0.0+rev=7d5fa4e";
    src = fetchgit {
      url = "https://github.com/amaanq/tree-sitter-capnp";
      rev = "7d5fa4e94d3643ec15750106113be0d40f9fc1bb";
      sha256 = "sha256-K83xouIGsv9EDLp4MSH9i6JE/GlAT72i3eJa58vR2gs=";
    };
    language = "capnp";
  };

  tree-sitter-chatito = {
    pname = "tree-sitter-chatito";
    version = "0.0.0+rev=3baf22e";
    src = fetchgit {
      url = "https://github.com/ObserverOfTime/tree-sitter-chatito";
      rev = "3baf22e7e507cedf15d1dbc03df8afa50a625586";
      sha256 = "sha256-NsdkvMkrHfVakeYxPJfr4HOg5BlLB6OPFQeMseQQL/k=";
    };
    language = "chatito";
  };

  tree-sitter-clojure = {
    pname = "tree-sitter-clojure";
    version = "0.0.0+rev=6e41628";
    src = fetchgit {
      url = "https://github.com/sogaiu/tree-sitter-clojure";
      rev = "6e41628e9d18b19caea1cb1d72aae4ccff5bdfe9";
      sha256 = "sha256-ssJIftjadMmoESm882mQ3fUjIoTDWtBrOolgYLcmlEE=";
    };
    language = "clojure";
  };

  tree-sitter-cmake = {
    pname = "tree-sitter-cmake";
    version = "0.0.0+rev=3dfc596";
    src = fetchgit {
      url = "https://github.com/uyha/tree-sitter-cmake";
      rev = "3dfc596025431b21e839d392c171f6f97c2a4258";
      sha256 = "sha256-SrNsKtZ/BYa6wWkuseHuwwvcC37IKFuGtS5oNefWG0U=";
    };
    language = "cmake";
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

  tree-sitter-commonlisp = {
    pname = "tree-sitter-commonlisp";
    version = "0.0.0+rev=338db38";
    src = fetchgit {
      url = "https://github.com/theHamsta/tree-sitter-commonlisp";
      rev = "338db38330f0d25cba8e2c6428240ebc5e020264";
      sha256 = "sha256-tdppAZ2B6cl+qHtxx5l97AA6QvqzgX3YyXmUHTqO/TI=";
    };
    generate = true;
    language = "commonlisp";
  };

  tree-sitter-cooklang = {
    pname = "tree-sitter-cooklang";
    version = "0.0.0+rev=5e11341";
    src = fetchgit {
      url = "https://github.com/addcninblue/tree-sitter-cooklang";
      rev = "5e113412aadb78955c27010daa4dbe1d202013cf";
      sha256 = "sha256-Ny55gdN+3o7bFJEnXvctstl6gjqkwrp1uE33OobyH7U=";
    };
    language = "cooklang";
  };

  tree-sitter-corn = {
    pname = "tree-sitter-corn";
    version = "0.0.0+rev=604d73c";
    src = fetchgit {
      url = "https://github.com/jakestanger/tree-sitter-corn";
      rev = "604d73c38d4c28ca68e9e441ffd405d68cb63051";
      sha256 = "sha256-ewpLp+se6XTY8aRoz247YlouS1p/kaS7CqVFu412C+Q=";
    };
    language = "corn";
  };

  tree-sitter-cpon = {
    pname = "tree-sitter-cpon";
    version = "0.0.0+rev=f4b3cbc";
    src = fetchgit {
      url = "https://github.com/amaanq/tree-sitter-cpon";
      rev = "f4b3cbc8b0bd4e13035d39940fef09f1392e8739";
      sha256 = "sha256-Enxc0sdQS9vSZVvIQkkHxk/1bzT2denRk0+AZdDNnJ8=";
    };
    language = "cpon";
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

  tree-sitter-cuda = {
    pname = "tree-sitter-cuda";
    version = "0.0.0+rev=90446ed";
    src = fetchgit {
      url = "https://github.com/theHamsta/tree-sitter-cuda";
      rev = "90446edd3e2e1eed0cb77755a083d9ed91ddea63";
      sha256 = "sha256-dG0lKcsKJWBieunA8il9msqiK+FCtq7YiJMX3M1LcJc=";
    };
    generate = true;
    language = "cuda";
  };

  tree-sitter-cue = {
    pname = "tree-sitter-cue";
    version = "0.0.0+rev=0deecf4";
    src = fetchgit {
      url = "https://github.com/eonpatapon/tree-sitter-cue";
      rev = "0deecf48944aa54bb73e5383ba8acfbf9f2c44b4";
      sha256 = "sha256-myHuYl3JfJ/JvVKM9toprsZ+RJ7L2G0LpzcNTmPTfHE=";
    };
    language = "cue";
  };

  tree-sitter-devicetree = {
    pname = "tree-sitter-devicetree";
    version = "0.0.0+rev=d2cc332";
    src = fetchgit {
      url = "https://github.com/joelspadin/tree-sitter-devicetree";
      rev = "d2cc332aeb814ea40e1e34ed6b9446324b32612a";
      sha256 = "sha256-iDiG6pNfALxy7nKyjuHfI9HW5/KElW/6zYguPaiMrzY=";
    };
    language = "devicetree";
  };

  tree-sitter-dhall = {
    pname = "tree-sitter-dhall";
    version = "0.0.0+rev=affb6ee";
    src = fetchgit {
      url = "https://github.com/jbellerb/tree-sitter-dhall";
      rev = "affb6ee38d629c9296749767ab832d69bb0d9ea8";
      sha256 = "sha256-q9OkKmp0Nor+YkFc8pBVAOoXoWzwjjzg9lBUKAUnjmQ=";
    };
    language = "dhall";
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

  tree-sitter-dot = {
    pname = "tree-sitter-dot";
    version = "0.0.0+rev=9ab8555";
    src = fetchgit {
      url = "https://github.com/rydesun/tree-sitter-dot";
      rev = "9ab85550c896d8b294d9b9ca1e30698736f08cea";
      sha256 = "sha256-w4DInIT7mkTvQ6Hmi8yaAww6ktyNgRz0tPfBLGnOawQ=";
    };
    language = "dot";
  };

  tree-sitter-eex = {
    pname = "tree-sitter-eex";
    version = "0.0.0+rev=f742f2f";
    src = fetchgit {
      url = "https://github.com/connorlay/tree-sitter-eex";
      rev = "f742f2fe327463335e8671a87c0b9b396905d1d1";
      sha256 = "sha256-UPq62MkfGFh9m/UskoB9uBDIYOcotITCJXDyrbg/wKY=";
    };
    language = "eex";
  };

  tree-sitter-elixir = {
    pname = "tree-sitter-elixir";
    version = "0.0.0+rev=7be3905";
    src = fetchgit {
      url = "https://github.com/elixir-lang/tree-sitter-elixir";
      rev = "7be390548a870ca9cb1bd7f59ac92457bbec7bf5";
      sha256 = "sha256-Id+c414ugW3PXOWx75ZMoN13qQdiyWs0cab9mNdT8/A=";
    };
    language = "elixir";
  };

  tree-sitter-elm = {
    pname = "tree-sitter-elm";
    version = "0.0.0+rev=73edfcd";
    src = fetchgit {
      url = "https://github.com/elm-tooling/tree-sitter-elm";
      rev = "73edfcdc3bb2ddfc731cd5d63e6cb287a18da90d";
      sha256 = "sha256-0fC3NYHtZQbi9Ca5UAAD9FEXQUJ9z8caf0XQsPpU5Rs=";
    };
    language = "elm";
  };

  tree-sitter-elsa = {
    pname = "tree-sitter-elsa";
    version = "0.0.0+rev=0a66b2b";
    src = fetchgit {
      url = "https://github.com/glapa-grossklag/tree-sitter-elsa";
      rev = "0a66b2b3f3c1915e67ad2ef9f7dbd2a84820d9d7";
      sha256 = "sha256-zahi5hOXzad6R1+mqmYBFfn2X+SejQUIQzbabgCIJ8w=";
    };
    language = "elsa";
  };

  tree-sitter-elvish = {
    pname = "tree-sitter-elvish";
    version = "0.0.0+rev=f32711e";
    src = fetchgit {
      url = "https://github.com/ckafi/tree-sitter-elvish";
      rev = "f32711e31e987fd5c2c002f3daba02f25c68672f";
      sha256 = "sha256-/3npcIfTH8w5ekLTb//ZCTxuSGhOXkUBaCq3WWcK2J4=";
    };
    language = "elvish";
  };

  tree-sitter-embedded_template = {
    pname = "tree-sitter-embedded_template";
    version = "0.0.0+rev=203f7bd";
    src = fetchgit {
      url = "https://github.com/tree-sitter/tree-sitter-embedded-template";
      rev = "203f7bd3c1bbfbd98fc19add4b8fcb213c059205";
      sha256 = "sha256-SaZkyy2wKYoK0+pdHLVpQrdXjEeX/uR5XxgahcAdwz0=";
    };
    language = "embedded_template";
  };

  tree-sitter-erlang = {
    pname = "tree-sitter-erlang";
    version = "0.0.0+rev=5dba13d";
    src = fetchgit {
      url = "https://github.com/WhatsApp/tree-sitter-erlang";
      rev = "5dba13dcd531c19bf99829e2e0bb31f2e08e16fe";
      sha256 = "sha256-FH8DNE03k95ZsRwaiXHkaU9/cdWrWALCEdChN5ZPdog=";
    };
    language = "erlang";
  };

  tree-sitter-fennel = {
    pname = "tree-sitter-fennel";
    version = "0.0.0+rev=5171959";
    src = fetchgit {
      url = "https://github.com/travonted/tree-sitter-fennel";
      rev = "517195970428aacca60891b050aa53eabf4ba78d";
      sha256 = "sha256-7bmrLJunNAus8XbBcBiTS5enhSzZ1mecAAyqlZUtSgo=";
    };
    language = "fennel";
  };

  tree-sitter-firrtl = {
    pname = "tree-sitter-firrtl";
    version = "0.0.0+rev=2b5adae";
    src = fetchgit {
      url = "https://github.com/amaanq/tree-sitter-firrtl";
      rev = "2b5adae629c8cba528c7b1e4aa67a8ae28934ea5";
      sha256 = "sha256-If34GymYMJpSNtzSGpcq4dMxj8djKZ3B5uMHGx9uCnM=";
    };
    language = "firrtl";
  };

  tree-sitter-fish = {
    pname = "tree-sitter-fish";
    version = "0.0.0+rev=f917690";
    src = fetchgit {
      url = "https://github.com/ram02z/tree-sitter-fish";
      rev = "f9176908c9eb2e11eb684d79e1d00f3b29bd65c9";
      sha256 = "sha256-FHlIiOFgO17R0RDvS5JnX+YfTSs4bSldMr2pXWOhUIE=";
    };
    language = "fish";
  };

  tree-sitter-fortran = {
    pname = "tree-sitter-fortran";
    version = "0.0.0+rev=31552ac";
    src = fetchgit {
      url = "https://github.com/stadelmanma/tree-sitter-fortran";
      rev = "31552ac43ecaffa443a12ebea68cc526d334892f";
      sha256 = "sha256-6ywdhlQGjivA2RV5345A0BiybAJOn9cIM03GMHjVoiM=";
    };
    language = "fortran";
  };

  tree-sitter-fsh = {
    pname = "tree-sitter-fsh";
    version = "0.0.0+rev=fa33477";
    src = fetchgit {
      url = "https://github.com/mgramigna/tree-sitter-fsh";
      rev = "fa3347712f7a59ed02ccf508284554689c6cde28";
      sha256 = "sha256-6TLG2edQeo+jRVAnO6mq3pC8RYNFi2UVVT3mQGZqk5U=";
    };
    language = "fsh";
  };

  tree-sitter-func = {
    pname = "tree-sitter-func";
    version = "0.0.0+rev=0834e35";
    src = fetchgit {
      url = "https://github.com/amaanq/tree-sitter-func";
      rev = "0834e35ecf8b23fbf9ad15b088af6a897e19d4a8";
      sha256 = "sha256-2+YOp7MnwZR2qg95h/ywjJwDSLUnodtkwwpv9zuy8p8=";
    };
    language = "func";
  };

  tree-sitter-fusion = {
    pname = "tree-sitter-fusion";
    version = "0.0.0+rev=19db2f4";
    src = fetchgit {
      url = "https://gitlab.com/jirgn/tree-sitter-fusion.git";
      rev = "19db2f47ba4c3a0f6238d4ae0e2abfca16e61dd6";
      sha256 = "sha256-195q39pZYipT0G08kQlwnDE28ODjAz2/Sq1tzpEGFmU=";
    };
    language = "fusion";
  };

  tree-sitter-gdscript = {
    pname = "tree-sitter-gdscript";
    version = "0.0.0+rev=03f20b9";
    src = fetchgit {
      url = "https://github.com/PrestonKnopp/tree-sitter-gdscript";
      rev = "03f20b94707a21bed90bb95101684bc4036139ce";
      sha256 = "sha256-im87Rws9PPcBWNN0M8PNqnthJZlWKzn3iPLMGR+jtGo=";
    };
    language = "gdscript";
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

  tree-sitter-gleam = {
    pname = "tree-sitter-gleam";
    version = "0.0.0+rev=2d5d6b0";
    src = fetchgit {
      url = "https://github.com/gleam-lang/tree-sitter-gleam";
      rev = "2d5d6b001ba12bf1c7ac94679d69ac2bed3151dc";
      sha256 = "sha256-9NHjBGvWLxenbD4dDBdWOOT7fVDIvyigilyd/SDtQtE=";
    };
    language = "gleam";
  };

  tree-sitter-glimmer = {
    pname = "tree-sitter-glimmer";
    version = "0.0.0+rev=d3031a8";
    src = fetchgit {
      url = "https://github.com/alexlafroscia/tree-sitter-glimmer";
      rev = "d3031a8294bf331600d5046b1d14e690a0d8ba0c";
      sha256 = "sha256-YvftQHEwYxRyRIYHrnAjIqgx6O0FlFrnF9TwUE+RiqI=";
    };
    language = "glimmer";
  };

  tree-sitter-glsl = {
    pname = "tree-sitter-glsl";
    version = "0.0.0+rev=53ca269";
    src = fetchgit {
      url = "https://github.com/theHamsta/tree-sitter-glsl";
      rev = "53ca269cae2a47b1b75791e2bfe843baeb02e903";
      sha256 = "sha256-0L8G44MjgKVQgDr0czjOZZWEtoOBxjkgAShZC2LLKbs=";
    };
    generate = true;
    language = "glsl";
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

  tree-sitter-godot_resource = {
    pname = "tree-sitter-godot_resource";
    version = "0.0.0+rev=b6ef076";
    src = fetchgit {
      url = "https://github.com/PrestonKnopp/tree-sitter-godot-resource";
      rev = "b6ef0768711086a86b3297056f9ffb5cc1d77b4a";
      sha256 = "sha256-ws/8nL+HOoPb6Hcdh4pihjPoRw90R1fy7MB0V9Lb9ik=";
    };
    language = "godot_resource";
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

  tree-sitter-graphql = {
    pname = "tree-sitter-graphql";
    version = "0.0.0+rev=5e66e96";
    src = fetchgit {
      url = "https://github.com/bkegley/tree-sitter-graphql";
      rev = "5e66e961eee421786bdda8495ed1db045e06b5fe";
      sha256 = "sha256-NvE9Rpdp4sALqKSRWJpqxwl6obmqnIIdvrL1nK5peXc=";
    };
    language = "graphql";
  };

  tree-sitter-groovy = {
    pname = "tree-sitter-groovy";
    version = "0.0.0+rev=7ebfaf3";
    src = fetchgit {
      url = "https://github.com/Decodetalkers/tree-sitter-groovy";
      rev = "7ebfaf33a0f68f9283be17903ebecfdac05a1f3b";
      sha256 = "sha256-9Jngzug6N8agdiWHs0DMK8LyhSg0s8hWpP6kInwDPY0=";
    };
    language = "groovy";
  };

  tree-sitter-hack = {
    pname = "tree-sitter-hack";
    version = "0.0.0+rev=95e63e7";
    src = fetchgit {
      url = "https://github.com/slackhq/tree-sitter-hack";
      rev = "95e63e79e0d9f91000bd11d458997fabed1bb1e2";
      sha256 = "sha256-++WvcNWPEs2Ax4KSWaA7sQ1ga2dJVoUnleLkjuQ6tFA=";
    };
    language = "hack";
  };

  tree-sitter-hare = {
    pname = "tree-sitter-hare";
    version = "0.0.0+rev=3d4af17";
    src = fetchgit {
      url = "https://github.com/amaanq/tree-sitter-hare";
      rev = "3d4af179414525a35dd069ba0208c9b71093d8b3";
      sha256 = "sha256-RRi2uAE9rf0bjQrk8Asf6z+6ZDZYhEoKaX0m8hZnI9o=";
    };
    language = "hare";
  };

  tree-sitter-haskell = {
    pname = "tree-sitter-haskell";
    version = "0.0.0+rev=ba0bfb0";
    src = fetchgit {
      url = "https://github.com/tree-sitter/tree-sitter-haskell";
      rev = "ba0bfb0e5d8e9e31c160d287878c6f26add3ec08";
      sha256 = "sha256-ZSOF0CLOn82GwU3xgvFefmh/AD2j5zz8I0t5YPwfan0=";
    };
    language = "haskell";
  };

  tree-sitter-haskell_persistent = {
    pname = "tree-sitter-haskell_persistent";
    version = "0.0.0+rev=58a6ccf";
    src = fetchgit {
      url = "https://github.com/MercuryTechnologies/tree-sitter-haskell-persistent";
      rev = "58a6ccfd56d9f1de8fb9f77e6c42151f8f0d0f3d";
      sha256 = "sha256-p4Anm/xeG/d7nYBPDABcdDih/a+0rMjwtVUJru7m9QY=";
    };
    language = "haskell_persistent";
  };

  tree-sitter-hcl = {
    pname = "tree-sitter-hcl";
    version = "0.0.0+rev=becebeb";
    src = fetchgit {
      url = "https://github.com/MichaHoffmann/tree-sitter-hcl";
      rev = "becebebd3509c02e871c99be55556269be1def1b";
      sha256 = "sha256-GR2a+VuhZVMGmLW9Mg7bSALNsy0SyfG+YVaRz1qY6a0=";
    };
    language = "hcl";
  };

  tree-sitter-heex = {
    pname = "tree-sitter-heex";
    version = "0.0.0+rev=2e1348c";
    src = fetchgit {
      url = "https://github.com/connorlay/tree-sitter-heex";
      rev = "2e1348c3cf2c9323e87c2744796cf3f3868aa82a";
      sha256 = "sha256-6LREyZhdTDt3YHVRPDyqCaDXqcsPlHOoMFDb2B3+3xM=";
    };
    language = "heex";
  };

  tree-sitter-hjson = {
    pname = "tree-sitter-hjson";
    version = "0.0.0+rev=02fa3b7";
    src = fetchgit {
      url = "https://github.com/winston0410/tree-sitter-hjson";
      rev = "02fa3b79b3ff9a296066da6277adfc3f26cbc9e0";
      sha256 = "sha256-NsTf3DR3gHVMYZDmTNvThB5bJcDwTcJ1+3eJhvsiDn8=";
    };
    generate = true;
    language = "hjson";
  };

  tree-sitter-hocon = {
    pname = "tree-sitter-hocon";
    version = "0.0.0+rev=c390f10";
    src = fetchgit {
      url = "https://github.com/antosha417/tree-sitter-hocon";
      rev = "c390f10519ae69fdb03b3e5764f5592fb6924bcc";
      sha256 = "sha256-9Zo3YYoo9mJ4Buyj7ofSrlZURrwstBo0vgzeTq1jMGw=";
    };
    generate = true;
    language = "hocon";
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

  tree-sitter-ispc = {
    pname = "tree-sitter-ispc";
    version = "0.0.0+rev=848e588";
    src = fetchgit {
      url = "https://github.com/fab4100/tree-sitter-ispc";
      rev = "848e58874ffa2f7e540a6ec01ab9652b26995f37";
      sha256 = "sha256-xHX7N3pJbU8c4apoDXEm2VXOn9NH9atG8YfwSMyhHZ4=";
    };
    generate = true;
    language = "ispc";
  };

  tree-sitter-janet_simple = {
    pname = "tree-sitter-janet_simple";
    version = "0.0.0+rev=bd9cbaf";
    src = fetchgit {
      url = "https://github.com/sogaiu/tree-sitter-janet-simple";
      rev = "bd9cbaf1ea8b942dfd58e68df10c9a378ab3d2b6";
      sha256 = "sha256-2FucTi1wATBcomyNx2oCqMJVmAqLWHJiPQ2+L0VtwUM=";
    };
    language = "janet_simple";
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

  tree-sitter-jsonc = {
    pname = "tree-sitter-jsonc";
    version = "0.0.0+rev=02b0165";
    src = fetchgit {
      url = "https://gitlab.com/WhyNotHugo/tree-sitter-jsonc.git";
      rev = "02b01653c8a1c198ae7287d566efa86a135b30d5";
      sha256 = "sha256-iWc2ePRiQnZ0FEdMAaAwa3iYt/SY0bEjQrZyqE9EhlU=";
    };
    generate = true;
    language = "jsonc";
  };

  tree-sitter-jsonnet = {
    pname = "tree-sitter-jsonnet";
    version = "0.0.0+rev=fdc7757";
    src = fetchgit {
      url = "https://github.com/sourcegraph/tree-sitter-jsonnet";
      rev = "fdc775714afa27fdef823adbaba6ab98f5ae66f2";
      sha256 = "sha256-KVpSB3LiC1qpF05Y1ScIglaXWIrAL+m7G4Q4/EVn0U8=";
    };
    language = "jsonnet";
  };

  tree-sitter-julia = {
    pname = "tree-sitter-julia";
    version = "0.0.0+rev=4d4dc7d";
    src = fetchgit {
      url = "https://github.com/tree-sitter/tree-sitter-julia";
      rev = "4d4dc7d8a4ad3856200a9ef151f9056fc14cec8b";
      sha256 = "sha256-v61uykCKr7QAeqex3JIbnv1EOTEGdOssfNcMrwlkLwI=";
    };
    language = "julia";
  };

  tree-sitter-kdl = {
    pname = "tree-sitter-kdl";
    version = "0.0.0+rev=e180e05";
    src = fetchgit {
      url = "https://github.com/amaanq/tree-sitter-kdl";
      rev = "e180e05132c4cb229a8ba679b298790ef1eca77c";
      sha256 = "sha256-XJ2thChaJQjn0N/tqotjc/eR3W4+6GrNv/FxjvScswc=";
    };
    language = "kdl";
  };

  tree-sitter-kotlin = {
    pname = "tree-sitter-kotlin";
    version = "0.0.0+rev=8d43d90";
    src = fetchgit {
      url = "https://github.com/fwcd/tree-sitter-kotlin";
      rev = "8d43d90d568a97afee0891949d7cead3294ca94d";
      sha256 = "sha256-nY+tGg8aD7ayAhE5HTBsrVMyYBl1lfjXmcTTYuYTSbY=";
    };
    language = "kotlin";
  };

  tree-sitter-lalrpop = {
    pname = "tree-sitter-lalrpop";
    version = "0.0.0+rev=b7431e4";
    src = fetchgit {
      url = "https://github.com/traxys/tree-sitter-lalrpop";
      rev = "b7431e4b64183a5d0d094895a4cd5daf51ed3103";
      sha256 = "sha256-P7A/MFmnCHq5rn+QSogbRD3joT7OxC+F9v2oMQ+DZBE=";
    };
    language = "lalrpop";
  };

  tree-sitter-latex = {
    pname = "tree-sitter-latex";
    version = "0.0.0+rev=2ae2021";
    src = fetchgit {
      url = "https://github.com/latex-lsp/tree-sitter-latex";
      rev = "2ae2021d7b224fb6aa57b760e0d146059f943bb8";
      sha256 = "sha256-790DbJ/nOQvH8WH6MDZZcAKANQTg1fQPGXS4BI2UbmE=";
    };
    language = "latex";
  };

  tree-sitter-ledger = {
    pname = "tree-sitter-ledger";
    version = "0.0.0+rev=8a841fb";
    src = fetchgit {
      url = "https://github.com/cbarrete/tree-sitter-ledger";
      rev = "8a841fb20ce683bfbb3469e6ba67f2851cfdf94a";
      sha256 = "sha256-BDMmRRqJXZTgK3yHX+yqgWHGpsMLqzTcQxFYaAWxroo=";
    };
    language = "ledger";
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

  tree-sitter-luap = {
    pname = "tree-sitter-luap";
    version = "0.0.0+rev=43916b0";
    src = fetchgit {
      url = "https://github.com/amaanq/tree-sitter-luap";
      rev = "43916b0f31c48a05e03783eb0bab4eec54a4ac75";
      sha256 = "sha256-wu2f9iCByf85/iE6j5slNruYH8GUVD19u/ygJ/yx76U=";
    };
    language = "luap";
  };

  tree-sitter-luau = {
    pname = "tree-sitter-luau";
    version = "0.0.0+rev=6953cd4";
    src = fetchgit {
      url = "https://github.com/amaanq/tree-sitter-luau";
      rev = "6953cd4fa5967c9aa3c769b4e4c7e69c904b9fa9";
      sha256 = "sha256-QGJgbwDSgkiiE7yt6HHkGH2t3ZNoY1+0VieX7Ccn/Z4=";
    };
    language = "luau";
  };

  tree-sitter-m68k = {
    pname = "tree-sitter-m68k";
    version = "0.0.0+rev=d097b12";
    src = fetchgit {
      url = "https://github.com/grahambates/tree-sitter-m68k";
      rev = "d097b123f19c6eaba2bf181c05420d88b9fc489d";
      sha256 = "sha256-y1nioJ2R0YgGLH7dkJsTxIkejfMnh1CU+A++yTaQdb0=";
    };
    language = "m68k";
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

  tree-sitter-matlab = {
    pname = "tree-sitter-matlab";
    version = "0.0.0+rev=835cdab";
    src = fetchgit {
      url = "https://github.com/acristoffers/tree-sitter-matlab";
      rev = "835cdab0e105ccc670cf08193a958d1661f3e52b";
      sha256 = "sha256-VhSBGkevPJSOjaEYLMR4+QfPwdO+ophtkYzLpSjgJ4k=";
    };
    language = "matlab";
  };

  tree-sitter-menhir = {
    pname = "tree-sitter-menhir";
    version = "0.0.0+rev=db7953a";
    src = fetchgit {
      url = "https://github.com/Kerl13/tree-sitter-menhir";
      rev = "db7953acb0d5551f207373c81fa07a57d7b085cb";
      sha256 = "sha256-w/ibFZ4bMPPRTgTJFLQrAzMecykJFcrjJjekKMXwqSI=";
    };
    language = "menhir";
  };

  tree-sitter-meson = {
    pname = "tree-sitter-meson";
    version = "0.0.0+rev=3d6dfbd";
    src = fetchgit {
      url = "https://github.com/Decodetalkers/tree-sitter-meson";
      rev = "3d6dfbdb2432603bc84ca7dc009bb39ed9a8a7b1";
      sha256 = "sha256-NRiecSr5UjISlFtmtvy3SYaWSmXMf0bKCKQVA83Jx+Y=";
    };
    language = "meson";
  };

  tree-sitter-nickel = {
    pname = "tree-sitter-nickel";
    version = "0.0.0+rev=e1d9337";
    src = fetchgit {
      url = "https://github.com/nickel-lang/tree-sitter-nickel";
      rev = "e1d9337864d209898a08c26b8cd4c2dd14c15148";
      sha256 = "sha256-RcVBptlJ4lYwdDo64pwzxx5z90yqS96Dhyuj4VZWOiM=";
    };
    language = "nickel";
  };

  tree-sitter-ninja = {
    pname = "tree-sitter-ninja";
    version = "0.0.0+rev=0a95cfd";
    src = fetchgit {
      url = "https://github.com/alemuller/tree-sitter-ninja";
      rev = "0a95cfdc0745b6ae82f60d3a339b37f19b7b9267";
      sha256 = "sha256-e/LpQUL3UHHko4QvMeT40LCvPZRT7xTGZ9z1Zaboru4=";
    };
    language = "ninja";
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

  tree-sitter-norg = {
    pname = "tree-sitter-norg";
    version = "0.0.0+rev=1a30509";
    src = fetchgit {
      url = "https://github.com/nvim-neorg/tree-sitter-norg";
      rev = "1a305093569632de50f9a316ff843dcda25b4ef5";
      sha256 = "sha256-dfdykz5DnbuJvRdY3rYehzphIJgDl1efrsEgG2+BhvI=";
    };
    language = "norg";
  };

  tree-sitter-objc = {
    pname = "tree-sitter-objc";
    version = "0.0.0+rev=0612ff9";
    src = fetchgit {
      url = "https://github.com/amaanq/tree-sitter-objc";
      rev = "0612ff9874bf376db4ae92b9f46ddcd4bdec1342";
      sha256 = "sha256-t6+voOjZe2//bH80AIzzDi+giA8cT68PxvR9/SdshFI=";
    };
    language = "objc";
  };

  tree-sitter-ocaml = {
    pname = "tree-sitter-ocaml";
    version = "0.0.0+rev=82e103c";
    src = fetchgit {
      url = "https://github.com/tree-sitter/tree-sitter-ocaml";
      rev = "82e103cee0ffb61ee59f9b654b8e1d4b8e9cab74";
      sha256 = "sha256-ukfW16Se3HH5n0NRPhp0oaCHULDpUqvOlvgeTMQUVwE=";
    };
    language = "ocaml";
    location = "ocaml";
  };

  tree-sitter-ocaml_interface = {
    pname = "tree-sitter-ocaml_interface";
    version = "0.0.0+rev=82e103c";
    src = fetchgit {
      url = "https://github.com/tree-sitter/tree-sitter-ocaml";
      rev = "82e103cee0ffb61ee59f9b654b8e1d4b8e9cab74";
      sha256 = "sha256-ukfW16Se3HH5n0NRPhp0oaCHULDpUqvOlvgeTMQUVwE=";
    };
    language = "ocaml_interface";
    location = "interface";
  };

  tree-sitter-ocamllex = {
    pname = "tree-sitter-ocamllex";
    version = "0.0.0+rev=6211855";
    src = fetchgit {
      url = "https://github.com/atom-ocaml/tree-sitter-ocamllex";
      rev = "62118551bd9501b8253598b835cb4bef04b31e3d";
      sha256 = "sha256-oHniBpZj325U93vt4lgHPLqLxZj9YyKMwBdVQV59tZ8=";
    };
    language = "ocamllex";
  };

  tree-sitter-odin = {
    pname = "tree-sitter-odin";
    version = "0.0.0+rev=d165dbe";
    src = fetchgit {
      url = "https://github.com/amaanq/tree-sitter-odin";
      rev = "d165dbee27617dab2653e38737d96ede1030d14f";
      sha256 = "sha256-NxF3aSDtXGMcE7v0BrYQbnUM/hophanKgsYX1ad8AFY=";
    };
    language = "odin";
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

  tree-sitter-pascal = {
    pname = "tree-sitter-pascal";
    version = "0.0.0+rev=9e99540";
    src = fetchgit {
      url = "https://github.com/Isopod/tree-sitter-pascal.git";
      rev = "9e995404ddff8319631d72d4b46552e737206912";
      sha256 = "sha256-y8xPnVZ15+eAnjrLSGjS5wIbLgSKbz9bipgL0o8acmA=";
    };
    language = "pascal";
  };

  tree-sitter-passwd = {
    pname = "tree-sitter-passwd";
    version = "0.0.0+rev=2023939";
    src = fetchgit {
      url = "https://github.com/ath3/tree-sitter-passwd";
      rev = "20239395eacdc2e0923a7e5683ad3605aee7b716";
      sha256 = "sha256-3UfuyJeblQBKjqZvLYyO3GoCvYJp+DvBwQGkR3pFQQ4=";
    };
    language = "passwd";
  };

  tree-sitter-pem = {
    pname = "tree-sitter-pem";
    version = "0.0.0+rev=3662443";
    src = fetchgit {
      url = "https://github.com/ObserverOfTime/tree-sitter-pem";
      rev = "3662443335bc95bac0168a338b0f29f87162c244";
      sha256 = "sha256-J6ktfMcH7umeDaK+r2YRljb+5dwKiXJ7dJazuDoBgno=";
    };
    language = "pem";
  };

  tree-sitter-perl = {
    pname = "tree-sitter-perl";
    version = "0.0.0+rev=60aa138";
    src = fetchgit {
      url = "https://github.com/ganezdragon/tree-sitter-perl";
      rev = "60aa138f9e1db15becad53070f4d5898b0e8a98c";
      sha256 = "sha256-GpgUSm/kFFXgJOSBVBxPQiMfykZUgxLdmQfDfJE3Jq8=";
    };
    language = "perl";
  };

  tree-sitter-php = {
    pname = "tree-sitter-php";
    version = "0.0.0+rev=d38adb2";
    src = fetchgit {
      url = "https://github.com/tree-sitter/tree-sitter-php";
      rev = "d38adb26304d9b9d38e9a3b4aae0ec4b29bf9462";
      sha256 = "sha256-s+NoJefmr1gyyLZNX9jUxiJR61VXXa2MNuECn+t2JBA=";
    };
    language = "php";
  };

  tree-sitter-pioasm = {
    pname = "tree-sitter-pioasm";
    version = "0.0.0+rev=924aada";
    src = fetchgit {
      url = "https://github.com/leo60228/tree-sitter-pioasm";
      rev = "924aadaf5dea2a6074d72027b064f939acf32e20";
      sha256 = "sha256-og5DjoyTtKUTp0V4/PpcGb8xwzLeidsb2lq0+QF7u9M=";
    };
    language = "pioasm";
  };

  tree-sitter-po = {
    pname = "tree-sitter-po";
    version = "0.0.0+rev=d6aed22";
    src = fetchgit {
      url = "https://github.com/erasin/tree-sitter-po";
      rev = "d6aed225290bc71a15ab6f06305cb11419360c56";
      sha256 = "sha256-fz4DGPA+KtOvLBmVMXqwnEMeXhupFecQC1xfhMbWCJg=";
    };
    language = "po";
  };

  tree-sitter-pony = {
    pname = "tree-sitter-pony";
    version = "0.0.0+rev=16f930b";
    src = fetchgit {
      url = "https://github.com/amaanq/tree-sitter-pony";
      rev = "16f930b250433cfcd4fb4144df92bb98ad344c20";
      sha256 = "sha256-UamgLmI1aI5e/JlGVZzFCPgDol8MnFomncrFKhQYLsk=";
    };
    language = "pony";
  };

  tree-sitter-prisma = {
    pname = "tree-sitter-prisma";
    version = "0.0.0+rev=eca2596";
    src = fetchgit {
      url = "https://github.com/victorhqc/tree-sitter-prisma";
      rev = "eca2596a355b1a9952b4f80f8f9caed300a272b5";
      sha256 = "sha256-MOqkM7DCQl1L8Jn9nyw89EoAr0ez4+d39HeKy2cb66c=";
    };
    language = "prisma";
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

  tree-sitter-prql = {
    pname = "tree-sitter-prql";
    version = "0.0.0+rev=02b1e96";
    src = fetchgit {
      url = "https://github.com/PRQL/tree-sitter-prql";
      rev = "02b1e967ede00aaa5d7c9fcd4a604b83825a6261";
      sha256 = "sha256-3pdfcCfHdusphn7vQX/d1gS5kKyNTE9qf0YBvsa/BjM=";
    };
    language = "prql";
  };

  tree-sitter-puppet = {
    pname = "tree-sitter-puppet";
    version = "0.0.0+rev=843868b";
    src = fetchgit {
      url = "https://github.com/amaanq/tree-sitter-puppet";
      rev = "843868bfb909b734bfb63778a5685fae4bf2a33f";
      sha256 = "sha256-6fJNADrLVsIoho9G8qCsMKNDB5a32gUntug7Nh8pKEg=";
    };
    language = "puppet";
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

  tree-sitter-ql = {
    pname = "tree-sitter-ql";
    version = "0.0.0+rev=bd08702";
    src = fetchgit {
      url = "https://github.com/tree-sitter/tree-sitter-ql";
      rev = "bd087020f0d8c183080ca615d38de0ec827aeeaf";
      sha256 = "sha256-2QOtNguYAIhIhGuVqyx/33gFu3OqcxAPBZOk85Q226M=";
    };
    language = "ql";
  };

  tree-sitter-qmldir = {
    pname = "tree-sitter-qmldir";
    version = "0.0.0+rev=6b2b5e4";
    src = fetchgit {
      url = "https://github.com/Decodetalkers/tree-sitter-qmldir";
      rev = "6b2b5e41734bd6f07ea4c36ac20fb6f14061c841";
      sha256 = "sha256-7ic9Xd+1G0JM25bY0f8N5r6YZx5NV5HrJXXHp6pXvo4=";
    };
    language = "qmldir";
  };

  tree-sitter-qmljs = {
    pname = "tree-sitter-qmljs";
    version = "0.0.0+rev=35ead5b";
    src = fetchgit {
      url = "https://github.com/yuja/tree-sitter-qmljs";
      rev = "35ead5b9955cdb29bcf709d622fa960ff33992b6";
      sha256 = "sha256-jT47lEGuk6YUjcHB0ZMyL3i5PqyUaCQmt0j78cUpy8Q=";
    };
    language = "qmljs";
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

  tree-sitter-r = {
    pname = "tree-sitter-r";
    version = "0.0.0+rev=80efda5";
    src = fetchgit {
      url = "https://github.com/r-lib/tree-sitter-r";
      rev = "80efda55672d1293aa738f956c7ae384ecdc31b4";
      sha256 = "sha256-qUfyITSZRnSm4zZHfkM/Dm5AeFEFLcCtRrInx0Xs/tg=";
    };
    language = "r";
  };

  tree-sitter-racket = {
    pname = "tree-sitter-racket";
    version = "0.0.0+rev=bbdb0bf";
    src = fetchgit {
      url = "https://github.com/6cdh/tree-sitter-racket";
      rev = "bbdb0bfbaf0dd5f6650b97a393a06a19cef50562";
      sha256 = "sha256-in/VhL0PkhOXaeiMje8oqTxYJ9/VirLTfzF9QZg/Fuk=";
    };
    language = "racket";
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

  tree-sitter-rego = {
    pname = "tree-sitter-rego";
    version = "0.0.0+rev=b2667c9";
    src = fetchgit {
      url = "https://github.com/FallenAngel97/tree-sitter-rego";
      rev = "b2667c975f07b33be3ceb83bea5cfbad88095866";
      sha256 = "sha256-y3w+gfjXb9N8Vf6ZrafP1j50Ap2KPaNfwo5h06EqHKM=";
    };
    language = "rego";
  };

  tree-sitter-rnoweb = {
    pname = "tree-sitter-rnoweb";
    version = "0.0.0+rev=502c112";
    src = fetchgit {
      url = "https://github.com/bamonroe/tree-sitter-rnoweb";
      rev = "502c1126dc6777f09af5bef16e72a42f75bd081e";
      sha256 = "sha256-aGEhy4uMhKFbL0+JO5rrn3GIe//8PZpDHEMDGHDlBCY=";
    };
    language = "rnoweb";
  };

  tree-sitter-ron = {
    pname = "tree-sitter-ron";
    version = "0.0.0+rev=ce6086b";
    src = fetchgit {
      url = "https://github.com/amaanq/tree-sitter-ron";
      rev = "ce6086b2c9e8e71065b8129d6c2289c5f66d1879";
      sha256 = "sha256-4ZKhJ3qvKWwINQIWJLqgPwfnDvQBWzeZb2dZY7imYfc=";
    };
    language = "ron";
  };

  tree-sitter-rst = {
    pname = "tree-sitter-rst";
    version = "0.0.0+rev=a41a933";
    src = fetchgit {
      url = "https://github.com/stsewd/tree-sitter-rst";
      rev = "a41a933524a54de1ba3ac4f5336b6eeb46deac15";
      sha256 = "sha256-sORX9vzxF6nhmbG5yPgOPvLuhJiKkT5LoA2HgBlKrt0=";
    };
    language = "rst";
  };

  tree-sitter-ruby = {
    pname = "tree-sitter-ruby";
    version = "0.0.0+rev=f257f3f";
    src = fetchgit {
      url = "https://github.com/tree-sitter/tree-sitter-ruby";
      rev = "f257f3f57833d584050336921773738a3fd8ca22";
      sha256 = "sha256-0EaU9O67faGwtO1GIxjK4Uv1etd0p1vtfrVB3d6TDF8=";
    };
    language = "ruby";
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

  tree-sitter-scala = {
    pname = "tree-sitter-scala";
    version = "0.0.0+rev=8062487";
    src = fetchgit {
      url = "https://github.com/tree-sitter/tree-sitter-scala";
      rev = "8062487fb3b7f3ce1bb7ce1fd1c84bed60c75203";
      sha256 = "sha256-nCmQjLqunccXVgmNUMbMbm6SYuwCRtf1v2CFXrgKXqo=";
    };
    language = "scala";
  };

  tree-sitter-scheme = {
    pname = "tree-sitter-scheme";
    version = "0.0.0+rev=0c763bd";
    src = fetchgit {
      url = "https://github.com/6cdh/tree-sitter-scheme";
      rev = "0c763bd5f85b18e354bc338d17cf1daa23b478b1";
      sha256 = "sha256-MHQdWH7nNBAJGLb6DN0NmpwQIIyO0+JznVPkTvryupU=";
    };
    language = "scheme";
  };

  tree-sitter-scss = {
    pname = "tree-sitter-scss";
    version = "0.0.0+rev=c478c68";
    src = fetchgit {
      url = "https://github.com/serenadeai/tree-sitter-scss";
      rev = "c478c6868648eff49eb04a4df90d703dc45b312a";
      sha256 = "sha256-BFtMT6eccBWUyq6b8UXRAbB1R1XD3CrrFf1DM3aUI5c=";
    };
    language = "scss";
  };

  tree-sitter-smali = {
    pname = "tree-sitter-smali";
    version = "0.0.0+rev=72e334b";
    src = fetchgit {
      url = "https://git.sr.ht/~yotam/tree-sitter-smali";
      rev = "72e334b2630f5852825ba5ff9dfd872447175eb5";
      sha256 = "sha256-vV+4Q2IyWyw/GN8bmgHJmSEHhpjUWHkL2yschPI9fiU=";
    };
    language = "smali";
  };

  tree-sitter-smithy = {
    pname = "tree-sitter-smithy";
    version = "0.0.0+rev=cf8c7eb";
    src = fetchgit {
      url = "https://github.com/indoorvivants/tree-sitter-smithy";
      rev = "cf8c7eb9faf7c7049839585eac19c94af231e6a0";
      sha256 = "sha256-3cqT6+e0uqAtd92M55qSbza1eph8gklGlEGyO9R170w=";
    };
    language = "smithy";
  };

  tree-sitter-solidity = {
    pname = "tree-sitter-solidity";
    version = "0.0.0+rev=1680203";
    src = fetchgit {
      url = "https://github.com/JoranHonig/tree-sitter-solidity";
      rev = "168020304759ad5d8b4a88a541a699134e3730c5";
      sha256 = "sha256-GCSBXB9nNIYpcXlA6v7P1ejn1ojmfXdPzr1sWejB560=";
    };
    language = "solidity";
  };

  tree-sitter-sparql = {
    pname = "tree-sitter-sparql";
    version = "0.0.0+rev=05f949d";
    src = fetchgit {
      url = "https://github.com/BonaBeavis/tree-sitter-sparql";
      rev = "05f949d3c1c15e3261473a244d3ce87777374dec";
      sha256 = "sha256-KBalxmAukeSbjyelEy+ZqMcBlRd0V0/pntCwTeINTAQ=";
    };
    language = "sparql";
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

  tree-sitter-squirrel = {
    pname = "tree-sitter-squirrel";
    version = "0.0.0+rev=e8b5835";
    src = fetchgit {
      url = "https://github.com/amaanq/tree-sitter-squirrel";
      rev = "e8b5835296f931bcaa1477d3c5a68a0c5c2ba034";
      sha256 = "sha256-wKefWCqcQcg7zLT6abaDC9lWoJiJp7EbbsBOWRRsWFQ=";
    };
    language = "squirrel";
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

  tree-sitter-supercollider = {
    pname = "tree-sitter-supercollider";
    version = "0.0.0+rev=3b35bd0";
    src = fetchgit {
      url = "https://github.com/madskjeldgaard/tree-sitter-supercollider";
      rev = "3b35bd0fded4423c8fb30e9585c7bacbcd0e8095";
      sha256 = "sha256-mWTOZ3u9VGjEhjDeYJGd8aVxjVG9kJgKX/wHMZSsaEU=";
    };
    language = "supercollider";
  };

  tree-sitter-surface = {
    pname = "tree-sitter-surface";
    version = "0.0.0+rev=f4586b3";
    src = fetchgit {
      url = "https://github.com/connorlay/tree-sitter-surface";
      rev = "f4586b35ac8548667a9aaa4eae44456c1f43d032";
      sha256 = "sha256-Fn/pF8yvU+Ll7WmoMHnEcNxb3dsfNhuKhXA1UgXeviA=";
    };
    language = "surface";
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

  tree-sitter-swift = {
    pname = "tree-sitter-swift";
    version = "0.0.0+rev=56ecc99";
    src = fetchgit {
      url = "https://github.com/alex-pinkus/tree-sitter-swift";
      rev = "56ecc996e5765054fc25cdae5fbddfd75a64287b";
      sha256 = "sha256-GH0HpxAprOlOLv8zqsP1O0/RbIn93FfdgAHp56Pyw9g=";
    };
    language = "swift";
  };

  tree-sitter-sxhkdrc = {
    pname = "tree-sitter-sxhkdrc";
    version = "0.0.0+rev=440d5f9";
    src = fetchgit {
      url = "https://github.com/RaafatTurki/tree-sitter-sxhkdrc";
      rev = "440d5f913d9465c9c776a1bd92334d32febcf065";
      sha256 = "sha256-AGhGYomrMe6Wj+EHLQT4v0BiU4jxhxXpVQkU2xU/1ZI=";
    };
    language = "sxhkdrc";
  };

  tree-sitter-t32 = {
    pname = "tree-sitter-t32";
    version = "0.0.0+rev=4e581fc";
    src = fetchgit {
      url = "https://codeberg.org/xasc/tree-sitter-t32";
      rev = "4e581fcd17d76651aa92759a68f9a8186b9fe8dc";
      sha256 = "sha256-SUft3MpM8fSLyojgRs6uaZxWDfoxNvL5Orb7XcrztYo=";
    };
    language = "t32";
  };

  tree-sitter-tablegen = {
    pname = "tree-sitter-tablegen";
    version = "0.0.0+rev=e5e046e";
    src = fetchgit {
      url = "https://github.com/amaanq/tree-sitter-tablegen";
      rev = "e5e046e1b221e25111175469f02f3cf336010857";
      sha256 = "sha256-qh5AWLinsSwfbui7b3Vk7DRW3GaS4Avaa0iLeMmMFtM=";
    };
    language = "tablegen";
  };

  tree-sitter-teal = {
    pname = "tree-sitter-teal";
    version = "0.0.0+rev=2158ecc";
    src = fetchgit {
      url = "https://github.com/euclidianAce/tree-sitter-teal";
      rev = "2158ecce11ea542f9b791baf2c7fb33798174ed2";
      sha256 = "sha256-Vofqs1AW5/a7kdPjY8+fu/t/mfBpaXiFFeG1Y0hsP6E=";
    };
    language = "teal";
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

  tree-sitter-tiger = {
    pname = "tree-sitter-tiger";
    version = "0.0.0+rev=4a09924";
    src = fetchgit {
      url = "https://github.com/ambroisie/tree-sitter-tiger";
      rev = "4a099243ed68a4fc72fdad8ea3ce57ec411ebfe3";
      sha256 = "sha256-y3bpfBPwvkFNMl1qZtlnpVhi5nnOqo0K9XGS2bCWPmY=";
    };
    language = "tiger";
  };

  tree-sitter-tlaplus = {
    pname = "tree-sitter-tlaplus";
    version = "0.0.0+rev=7ba226c";
    src = fetchgit {
      url = "https://github.com/tlaplus-community/tree-sitter-tlaplus";
      rev = "7ba226cf85280c7917d082940022006e6a3b7b6f";
      sha256 = "sha256-XiygqAfENwt4h3g0/dodmuxrmvHlU0FQ6Yc+0m1eQJc=";
    };
    language = "tlaplus";
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

  tree-sitter-turtle = {
    pname = "tree-sitter-turtle";
    version = "0.0.0+rev=085437f";
    src = fetchgit {
      url = "https://github.com/BonaBeavis/tree-sitter-turtle";
      rev = "085437f5cb117703b7f520dd92161140a684f092";
      sha256 = "sha256-ub777Pjody2SvP2EjW7IwWj8YnMuMzdJ4AlrkP6WrdA=";
    };
    language = "turtle";
  };

  tree-sitter-twig = {
    pname = "tree-sitter-twig";
    version = "0.0.0+rev=779ee5a";
    src = fetchgit {
      url = "https://github.com/gbprod/tree-sitter-twig";
      rev = "779ee5ab1e065dcef7f51f253030dc875445b25f";
      sha256 = "sha256-4De6ETY0oqbvMXtTDyd1vwheJdfuIusNHjyqyspsz2A=";
    };
    language = "twig";
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

  tree-sitter-ungrammar = {
    pname = "tree-sitter-ungrammar";
    version = "0.0.0+rev=debd26f";
    src = fetchgit {
      url = "https://github.com/Philipp-M/tree-sitter-ungrammar";
      rev = "debd26fed283d80456ebafa33a06957b0c52e451";
      sha256 = "sha256-ftvcD8I+hYqH3EGxaRZ0w8FHjBA34OSTTsrUsAOtayU=";
    };
    language = "ungrammar";
  };

  tree-sitter-usd = {
    pname = "tree-sitter-usd";
    version = "0.0.0+rev=718a6b3";
    src = fetchgit {
      url = "https://github.com/ColinKennedy/tree-sitter-usd";
      rev = "718a6b3e939904e0b4fe7cff6742e96af4781f4b";
      sha256 = "sha256-6U4TreAeAGB7WRUtTXdxQvNa6Sl6E+f329/SZ6DOQ+0=";
    };
    language = "usd";
  };

  tree-sitter-uxntal = {
    pname = "tree-sitter-uxntal";
    version = "0.0.0+rev=14e4760";
    src = fetchgit {
      url = "https://github.com/amaanq/tree-sitter-uxntal";
      rev = "14e47600afef0affffcbfbe1543381b1ac8fbc5c";
      sha256 = "sha256-SgBWJ8b/9kMkSDafx+6eSl+FS4Hkd1Ei2ALhTLL7yRk=";
    };
    language = "uxntal";
  };

  tree-sitter-v = {
    pname = "tree-sitter-v";
    version = "0.0.0+rev=519e0f6";
    src = fetchgit {
      url = "https://github.com/vlang/vls";
      rev = "519e0f64007a40852e59bb72ff1b6e2375068664";
      sha256 = "sha256-ps5VmLSDoc5PF/rGhNAmKkOBsuVxgjn+ZQTit8MGyvk=";
    };
    language = "v";
    location = "tree_sitter_v";
  };

  tree-sitter-vala = {
    pname = "tree-sitter-vala";
    version = "0.0.0+rev=8f690bf";
    src = fetchgit {
      url = "https://github.com/vala-lang/tree-sitter-vala";
      rev = "8f690bfa639f2b83d1fb938ed3dd98a7ba453e8b";
      sha256 = "sha256-YZTE3PkBPCEkMXnLC0HSQ86v5+3/J7/ETDQp8eguFW8=";
    };
    language = "vala";
  };

  tree-sitter-verilog = {
    pname = "tree-sitter-verilog";
    version = "0.0.0+rev=4457145";
    src = fetchgit {
      url = "https://github.com/tree-sitter/tree-sitter-verilog";
      rev = "4457145e795b363f072463e697dfe2f6973c9a52";
      sha256 = "sha256-l4DgThuP9EFU55YQ9lgvVP/8pXojOllQ870gRsBF3FE=";
    };
    language = "verilog";
  };

  tree-sitter-vhs = {
    pname = "tree-sitter-vhs";
    version = "0.0.0+rev=fec6e98";
    src = fetchgit {
      url = "https://github.com/charmbracelet/tree-sitter-vhs";
      rev = "fec6e981b7795b68262ddf229d73d2aa03a89b9a";
      sha256 = "sha256-vGRmIFWUXSG3uDpKPcxALndV7gWiQ2nG4BOGL05oZ6U=";
    };
    language = "vhs";
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

  tree-sitter-vue = {
    pname = "tree-sitter-vue";
    version = "0.0.0+rev=91fe275";
    src = fetchgit {
      url = "https://github.com/ikatyang/tree-sitter-vue";
      rev = "91fe2754796cd8fba5f229505a23fa08f3546c06";
      sha256 = "sha256-IKaKR/AJ5R95D212asrLknjlET/2h6NwrgVdBX8fEKA=";
    };
    language = "vue";
  };

  tree-sitter-wgsl = {
    pname = "tree-sitter-wgsl";
    version = "0.0.0+rev=40259f3";
    src = fetchgit {
      url = "https://github.com/szebniok/tree-sitter-wgsl";
      rev = "40259f3c77ea856841a4e0c4c807705f3e4a2b65";
      sha256 = "sha256-voLkcJ/062hzipb3Ak/mgQvFbrLUJdnXq1IupzjMJXA=";
    };
    language = "wgsl";
  };

  tree-sitter-wgsl_bevy = {
    pname = "tree-sitter-wgsl_bevy";
    version = "0.0.0+rev=7cd38d6";
    src = fetchgit {
      url = "https://github.com/theHamsta/tree-sitter-wgsl-bevy";
      rev = "7cd38d6895060b023353e04f7af099ec64add5d1";
      sha256 = "sha256-QzfeFzGhWJGD+l+MeKyedRpdZsH+dGKE7UxRmh2uMH0=";
    };
    generate = true;
    language = "wgsl_bevy";
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

  tree-sitter-yang = {
    pname = "tree-sitter-yang";
    version = "0.0.0+rev=2c0e6be";
    src = fetchgit {
      url = "https://github.com/Hubro/tree-sitter-yang";
      rev = "2c0e6be8dd4dcb961c345fa35c309ad4f5bd3502";
      sha256 = "sha256-6EIK1EStHrUHBLZBsZqd1LL05ZAJ6PKUyIzBBsTVjO8=";
    };
    language = "yang";
  };

  tree-sitter-yuck = {
    pname = "tree-sitter-yuck";
    version = "0.0.0+rev=c348825";
    src = fetchgit {
      url = "https://github.com/Philipp-M/tree-sitter-yuck";
      rev = "c348825d3f86dec71dee0e1223c6bd73114e3579";
      sha256 = "sha256-H4tsLDo9Egp1mpZGcA5Z9C9wPFNxPEBDTugUYKeYW9I=";
    };
    language = "yuck";
  };

  tree-sitter-zig = {
    pname = "tree-sitter-zig";
    version = "0.0.0+rev=0d08703";
    src = fetchgit {
      url = "https://github.com/maxxnino/tree-sitter-zig";
      rev = "0d08703e4c3f426ec61695d7617415fff97029bd";
      sha256 = "sha256-a3W7eBUN4V3HD3YPr1+3tpuWQfIQy1Wu8qxCQx0hEnI=";
    };
    language = "zig";
  };
}
