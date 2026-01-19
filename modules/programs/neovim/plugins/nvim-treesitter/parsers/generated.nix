{ fetchgit, ... }:

{
  tree-sitter-arduino = {
    pname = "tree-sitter-arduino";
    version = "0.0.0+rev=017696b";
    src = fetchgit {
      url = "https://github.com/ObserverOfTime/tree-sitter-arduino";
      rev = "017696bdf47ca2b10948c5a511f9ab387722d0f3";
      sha256 = "sha256-eoctUt+Wmeq7agl6ZPDD+ycp49bAWiWHQP11bGdXUZs=";
    };
    language = "arduino";
  };

  tree-sitter-asm = {
    pname = "tree-sitter-asm";
    version = "0.0.0+rev=04962e1";
    src = fetchgit {
      url = "https://github.com/RubixDev/tree-sitter-asm";
      rev = "04962e15f6b464cf1d75eada59506dc25090e186";
      sha256 = "sha256-a/wbmJQFddf+19E2uHmObQ5XfUkF5iaCSI1Y8avntGw=";
    };
    language = "asm";
  };

  tree-sitter-authzed = {
    pname = "tree-sitter-authzed";
    version = "0.0.0+rev=1dec7e1";
    src = fetchgit {
      url = "https://github.com/mleonidas/tree-sitter-authzed";
      rev = "1dec7e1af96c56924e3322cd85fdce15d0a31d00";
      sha256 = "sha256-qPSQF95DO7WByVy9YXEOus3q3U4QfWuUFbJGVXd4EtQ=";
    };
    language = "authzed";
  };

  tree-sitter-awk = {
    pname = "tree-sitter-awk";
    version = "0.0.0+rev=34bbdc7";
    src = fetchgit {
      url = "https://github.com/Beaglefoot/tree-sitter-awk";
      rev = "34bbdc7cce8e803096f47b625979e34c1be38127";
      sha256 = "sha256-MDfAtG6ZC0KttJ5bdW71Jgts+SAJitRnwu8xQ26N9K0=";
    };
    language = "awk";
  };

  tree-sitter-bash = {
    pname = "tree-sitter-bash";
    version = "0.0.0+rev=0c46d79";
    src = fetchgit {
      url = "https://github.com/tree-sitter/tree-sitter-bash";
      rev = "0c46d792d54c536be5ff7eb18eb95c70fccdb232";
      sha256 = "sha256-ODWgFpCLLPgzNYXFhfAVvDXPr5bW8/49ezsaS9MOWMk=";
    };
    language = "bash";
  };

  tree-sitter-c = {
    pname = "tree-sitter-c";
    version = "0.0.0+rev=2a265d6";
    src = fetchgit {
      url = "https://github.com/tree-sitter/tree-sitter-c";
      rev = "2a265d69a4caf57108a73ad2ed1e6922dd2f998c";
      sha256 = "sha256-6sebiNg9P/B/5HrbGO7bl3GHVMfVUepetJuszEeTh+8=";
    };
    language = "c";
  };

  tree-sitter-c_sharp = {
    pname = "tree-sitter-c_sharp";
    version = "0.0.0+rev=b5eb574";
    src = fetchgit {
      url = "https://github.com/tree-sitter/tree-sitter-c-sharp";
      rev = "b5eb5742f6a7e9438bee22ce8026d6b927be2cd7";
      sha256 = "sha256-ORhtfxQ6N72UjFx6WRfdYpkM9mVkTkxQ3PX3ydjIvX4=";
    };
    language = "c_sharp";
  };

  tree-sitter-caddy = {
    pname = "tree-sitter-caddy";
    version = "0.0.0+rev=2686186";
    src = fetchgit {
      url = "https://github.com/opa-oz/tree-sitter-caddy";
      rev = "2686186edb61be47960431c93a204fb249681360";
      sha256 = "sha256-pKKx2qCqP/8JLhNebTogM24qzxh6bdX5i4mqGzTJKkw=";
    };
    language = "caddy";
  };

  tree-sitter-capnp = {
    pname = "tree-sitter-capnp";
    version = "0.0.0+rev=7b0883c";
    src = fetchgit {
      url = "https://github.com/amaanq/tree-sitter-capnp";
      rev = "7b0883c03e5edd34ef7bcf703194204299d7099f";
      sha256 = "sha256-WKrZuOMxmdGlvUI9y8JgwCNMdJ8MULucMhkmW8JCiXM=";
    };
    language = "capnp";
  };

  tree-sitter-cmake = {
    pname = "tree-sitter-cmake";
    version = "0.0.0+rev=fe48221";
    src = fetchgit {
      url = "https://github.com/uyha/tree-sitter-cmake";
      rev = "fe48221d4d9842d916d66b5e71ab3c6307ec28b3";
      sha256 = "sha256-lU6EU+ikUJ1Q/SzJ2/PzziRLO8PSS3oQ8hCANO4n8Tw=";
    };
    language = "cmake";
  };

  tree-sitter-comment = {
    pname = "tree-sitter-comment";
    version = "0.0.0+rev=3555706";
    src = fetchgit {
      url = "https://github.com/stsewd/tree-sitter-comment";
      rev = "3555706cef8b98d3e4c7379d7260548ff03ad363";
      sha256 = "sha256-7iY7D7wz+rYRWhi+429a2pcF0mUMBCnnecIssxlqvt0=";
    };
    language = "comment";
  };

  tree-sitter-cpp = {
    pname = "tree-sitter-cpp";
    version = "0.0.0+rev=e5cea0e";
    src = fetchgit {
      url = "https://github.com/tree-sitter/tree-sitter-cpp";
      rev = "e5cea0ec884c5c3d2d1e41a741a66ce13da4d945";
      sha256 = "sha256-2uVlKVnMKnugJv4Py3PtFI8rmx2RMwUIYfQ8zDNugGw=";
    };
    generate = true;
    language = "cpp";
  };

  tree-sitter-css = {
    pname = "tree-sitter-css";
    version = "0.0.0+rev=6e327db";
    src = fetchgit {
      url = "https://github.com/tree-sitter/tree-sitter-css";
      rev = "6e327db434fec0ee90f006697782e43ec855adf5";
      sha256 = "sha256-en379DlqzzvQNvKgE8CtiA00j7phUyipttqbnETGHKc=";
    };
    language = "css";
  };

  tree-sitter-csv = {
    pname = "tree-sitter-csv";
    version = "0.0.0+rev=7eb7297";
    src = fetchgit {
      url = "https://github.com/amaanq/tree-sitter-csv";
      rev = "7eb7297823605392d2bbcc4c09b1cd18d6fa9529";
      sha256 = "sha256-5VL7uREH0lloAWo9rdJXsjDsWxgL6fngWJSmi4fM7UQ=";
    };
    language = "csv";
    location = "csv";
  };

  tree-sitter-cue = {
    pname = "tree-sitter-cue";
    version = "0.0.0+rev=770737b";
    src = fetchgit {
      url = "https://github.com/eonpatapon/tree-sitter-cue";
      rev = "770737bcff2c4aa3f624d439e32b07dbb07102d3";
      sha256 = "sha256-ujSBOwOnjsKuFhHtt4zvj90VcQsak8mEcWYJ0e5/mKc=";
    };
    language = "cue";
  };

  tree-sitter-desktop = {
    pname = "tree-sitter-desktop";
    version = "0.0.0+rev=6d66eea";
    src = fetchgit {
      url = "https://github.com/ValdezFOmar/tree-sitter-desktop";
      rev = "6d66eea37afa1d6bc1e25ef457113743df42416d";
      sha256 = "sha256-vaWcgt4bwO1PCG0BJrp6oSY6DEWfMiuWtOPUwKvzmPg=";
    };
    language = "desktop";
  };

  tree-sitter-devicetree = {
    pname = "tree-sitter-devicetree";
    version = "0.0.0+rev=16f640f";
    src = fetchgit {
      url = "https://github.com/joelspadin/tree-sitter-devicetree";
      rev = "16f640f3c59117c9e749d581634afdb00e004f4c";
      sha256 = "sha256-0J1Q25JEWVAlBHAgWRtHAwIIDNoSLYrEdMC45/jf7Uc=";
    };
    language = "devicetree";
  };

  tree-sitter-dhall = {
    pname = "tree-sitter-dhall";
    version = "0.0.0+rev=4a6c08a";
    src = fetchgit {
      url = "https://github.com/jbellerb/tree-sitter-dhall";
      rev = "4a6c08abfb54827db4e722d6cdca81b093898988";
      sha256 = "sha256-EP6eL04ltnnP2ypNsq6rLrG3F4bVg7QtnK3k0KP2/MY=";
    };
    language = "dhall";
  };

  tree-sitter-diff = {
    pname = "tree-sitter-diff";
    version = "0.0.0+rev=e42b8de";
    src = fetchgit {
      url = "https://github.com/the-mikedavis/tree-sitter-diff";
      rev = "e42b8def4f75633568f1aecfe01817bf15164928";
      sha256 = "sha256-1ibGin1e6+geAQNoV/KLCBOoXYcZo7S5+Q2XgsZPIfU=";
    };
    language = "diff";
  };

  tree-sitter-disassembly = {
    pname = "tree-sitter-disassembly";
    version = "0.0.0+rev=0229c02";
    src = fetchgit {
      url = "https://github.com/ColinKennedy/tree-sitter-disassembly";
      rev = "0229c0211dba909c5d45129ac784a3f4d49c243a";
      sha256 = "sha256-IM3HzOhJmbb334PZ8q+r2EMi5Bv/rLoy+llPN0aghr8=";
    };
    language = "disassembly";
  };

  tree-sitter-dockerfile = {
    pname = "tree-sitter-dockerfile";
    version = "0.0.0+rev=971acdd";
    src = fetchgit {
      url = "https://github.com/camdencheek/tree-sitter-dockerfile";
      rev = "971acdd908568b4531b0ba28a445bf0bb720aba5";
      sha256 = "sha256-WJJ/rjFea1sudGIyjKGupwm39TJ1zbyWlLgoRf1KCBI=";
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

  tree-sitter-doxygen = {
    pname = "tree-sitter-doxygen";
    version = "0.0.0+rev=ccd998f";
    src = fetchgit {
      url = "https://github.com/amaanq/tree-sitter-doxygen";
      rev = "ccd998f378c3f9345ea4eeb223f56d7b84d16687";
      sha256 = "sha256-Yh6FaRvWmeqnSnBgOojWbs1wJaeEoNJlvSEqgzjGh7o=";
    };
    language = "doxygen";
  };

  tree-sitter-editorconfig = {
    pname = "tree-sitter-editorconfig";
    version = "0.0.0+rev=3f2b371";
    src = fetchgit {
      url = "https://github.com/ValdezFOmar/tree-sitter-editorconfig";
      rev = "3f2b371537355f6e53cc3af37f79ba450efb5132";
      sha256 = "sha256-z5pTG7EbmEZV+5RtXI8jGxxb0ifb67EJXquWQ0IA1a8=";
    };
    language = "editorconfig";
  };

  tree-sitter-embedded_template = {
    pname = "tree-sitter-embedded_template";
    version = "0.0.0+rev=8495d10";
    src = fetchgit {
      url = "https://github.com/tree-sitter/tree-sitter-embedded-template";
      rev = "8495d106154741e6d35d37064f864758ece75de6";
      sha256 = "sha256-DCEno1QzPcM9853hldrm4IAqKsTNALe//laDn+Hcr8Q=";
    };
    language = "embedded_template";
  };

  tree-sitter-enforce = {
    pname = "tree-sitter-enforce";
    version = "0.0.0+rev=aedd0bb";
    src = fetchgit {
      url = "https://github.com/simonvic/tree-sitter-enforce";
      rev = "aedd0bbab9dcc9caec9cc4e32bd303e86509522b";
      sha256 = "sha256-0oqp3tlbTrKtI5clrkOKP04M1zYb3yyJ6RHvQrHyWDM=";
    };
    language = "enforce";
  };

  tree-sitter-fish = {
    pname = "tree-sitter-fish";
    version = "0.0.0+rev=70640c0";
    src = fetchgit {
      url = "https://github.com/ram02z/tree-sitter-fish";
      rev = "70640c0696abde32622afc43291a385681afbd32";
      sha256 = "sha256-ED1lJ1GlbT/ptr+S9J1mD9fnfuewPko2rvj/qMVPCso=";
    };
    language = "fish";
  };

  tree-sitter-fsh = {
    pname = "tree-sitter-fsh";
    version = "0.0.0+rev=fad2e17";
    src = fetchgit {
      url = "https://github.com/mgramigna/tree-sitter-fsh";
      rev = "fad2e175099a45efbc98f000cc196d3674cc45e0";
      sha256 = "sha256-91r1FCQTocDkhS5Tx0vnFliitMStVzNTpf6BwPyaqVM=";
    };
    language = "fsh";
  };

  tree-sitter-func = {
    pname = "tree-sitter-func";
    version = "0.0.0+rev=f780ca5";
    src = fetchgit {
      url = "https://github.com/amaanq/tree-sitter-func";
      rev = "f780ca55e65e7d7360d0229331763e16c452fc98";
      sha256 = "sha256-jM0VJZlfhenAZbhabpgsoRIGny3WSDoimZtwogcvaSI=";
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

  tree-sitter-gap = {
    pname = "tree-sitter-gap";
    version = "0.0.0+rev=7db7959";
    src = fetchgit {
      url = "https://github.com/gap-system/tree-sitter-gap";
      rev = "7db79590d2f8b0e0246008ecfd569b4bfca587a9";
      sha256 = "sha256-M/nk1XM9vZe0XoFr6EttWCY4fjzw2r5I/XImJNjUwGk=";
    };
    language = "gap";
  };

  tree-sitter-gaptst = {
    pname = "tree-sitter-gaptst";
    version = "0.0.0+rev=69086d7";
    src = fetchgit {
      url = "https://github.com/gap-system/tree-sitter-gaptst";
      rev = "69086d7627c03e1f4baf766bcef14c60d9e92331";
      sha256 = "sha256-U0P9QoOZST1h6XI83CI0/6/CDTvqkv1Yiq62h6YdHpI=";
    };
    language = "gaptst";
  };

  tree-sitter-gdscript = {
    pname = "tree-sitter-gdscript";
    version = "0.0.0+rev=48b4933";
    src = fetchgit {
      url = "https://github.com/PrestonKnopp/tree-sitter-gdscript";
      rev = "48b49330888a4669b48619b211cc8da573827725";
      sha256 = "sha256-mGmrCK3nGSzi/66mOxvpRyTA9b74aTMSoIISqzj+l90=";
    };
    language = "gdscript";
  };

  tree-sitter-gdshader = {
    pname = "tree-sitter-gdshader";
    version = "0.0.0+rev=ffd9f95";
    src = fetchgit {
      url = "https://github.com/GodOfAvacyn/tree-sitter-gdshader";
      rev = "ffd9f958df13cae04593781d7d2562295a872455";
      sha256 = "sha256-JWlDs0w10TqsPYgZvvaJwAueOciCYaws1Nr8rb0UKy4=";
    };
    language = "gdshader";
  };

  tree-sitter-git_config = {
    pname = "tree-sitter-git_config";
    version = "0.0.0+rev=9c2a1b7";
    src = fetchgit {
      url = "https://github.com/the-mikedavis/tree-sitter-git-config";
      rev = "9c2a1b7894e6d9eedfe99805b829b4ecd871375e";
      sha256 = "sha256-O0w0BhhPPwhnKfniAFSPMWfBsZUTrijifAsmFiAncWg=";
    };
    language = "git_config";
  };

  tree-sitter-git_rebase = {
    pname = "tree-sitter-git_rebase";
    version = "0.0.0+rev=bff4b66";
    src = fetchgit {
      url = "https://github.com/the-mikedavis/tree-sitter-git-rebase";
      rev = "bff4b66b44b020d918d67e2828eada1974a966aa";
      sha256 = "sha256-k4C7dJUkvQxIxcaoVmG2cBs/CeYzVqrip2+2mRvHtZc=";
    };
    language = "git_rebase";
  };

  tree-sitter-gitattributes = {
    pname = "tree-sitter-gitattributes";
    version = "0.0.0+rev=5425944";
    src = fetchgit {
      url = "https://github.com/ObserverOfTime/tree-sitter-gitattributes";
      rev = "5425944fd61bf2b3bad2c17c2dc9f53172b0f01d";
      sha256 = "sha256-MYz+Z3Qc2unH3OJXo93BPC9mL5YCTnTpiAT3lZhT1ek=";
    };
    language = "gitattributes";
  };

  tree-sitter-gitcommit = {
    pname = "tree-sitter-gitcommit";
    version = "0.0.0+rev=a716678";
    src = fetchgit {
      url = "https://github.com/gbprod/tree-sitter-gitcommit";
      rev = "a716678c0f00645fed1e6f1d0eb221481dbd6f6d";
      sha256 = "sha256-KYfcs99p03b0RiPYnZeKJf677fmVf658FLZcFk2v2Ws=";
    };
    language = "gitcommit";
  };

  tree-sitter-gleam = {
    pname = "tree-sitter-gleam";
    version = "0.0.0+rev=99ec410";
    src = fetchgit {
      url = "https://github.com/gleam-lang/tree-sitter-gleam";
      rev = "99ec4101504452c488b7c835fb65cfef75b090b7";
      sha256 = "sha256-FEecjw1nYYO8U+qLjOK28qTMCO1pJkwdUDzlDvmle4c=";
    };
    language = "gleam";
  };

  tree-sitter-glsl = {
    pname = "tree-sitter-glsl";
    version = "0.0.0+rev=24a6c8e";
    src = fetchgit {
      url = "https://github.com/theHamsta/tree-sitter-glsl";
      rev = "24a6c8ef698e4480fecf8340d771fbcb5de8fbb4";
      sha256 = "sha256-BVtYKfKJB+oKA0KvQdpWvZ5XAFvQXTNVId96BLTAYmM=";
    };
    generate = true;
    language = "glsl";
  };

  tree-sitter-gn = {
    pname = "tree-sitter-gn";
    version = "0.0.0+rev=bc06955";
    src = fetchgit {
      url = "https://github.com/amaanq/tree-sitter-gn";
      rev = "bc06955bc1e3c9ff8e9b2b2a55b38b94da923c05";
      sha256 = "sha256-Sn6He4YRrKJe4QvGiaauquYBVQol0lWeIuOwkdUEzkQ=";
    };
    language = "gn";
  };

  tree-sitter-gnuplot = {
    pname = "tree-sitter-gnuplot";
    version = "0.0.0+rev=8923c1e";
    src = fetchgit {
      url = "https://github.com/dpezto/tree-sitter-gnuplot";
      rev = "8923c1e38b9634a688a6c0dce7c18c8ffb823e79";
      sha256 = "sha256-fR3lIscfrBqpBH1jZ4RB1Qa8r+hxy6I0OzzoQqAe2aw=";
    };
    language = "gnuplot";
  };

  tree-sitter-go = {
    pname = "tree-sitter-go";
    version = "0.0.0+rev=5e73f47";
    src = fetchgit {
      url = "https://github.com/tree-sitter/tree-sitter-go";
      rev = "5e73f476efafe5c768eda19bbe877f188ded6144";
      sha256 = "sha256-PgFdtkPMgkNK7Gv6dBf89lNjJrZyt9Wp5h5OIwd83aw=";
    };
    language = "go";
  };

  tree-sitter-goctl = {
    pname = "tree-sitter-goctl";
    version = "0.0.0+rev=49c4353";
    src = fetchgit {
      url = "https://github.com/chaozwn/tree-sitter-goctl";
      rev = "49c43532689fe1f53e8b9e009d0521cab02c432b";
      sha256 = "sha256-HYPj95Kg+C5Ax++Z83yUnhrf2iIVTuwOBhVVLlYQaGs=";
    };
    language = "goctl";
  };

  tree-sitter-godot_resource = {
    pname = "tree-sitter-godot_resource";
    version = "0.0.0+rev=91c55fd";
    src = fetchgit {
      url = "https://github.com/PrestonKnopp/tree-sitter-godot-resource";
      rev = "91c55fdf325a832659e59cdf4a02bfe8a423f14c";
      sha256 = "sha256-Hmpc8JsbgCo/iuIxn9E3XL1kJPi8wADlSvH3inlacFc=";
    };
    language = "godot_resource";
  };

  tree-sitter-gomod = {
    pname = "tree-sitter-gomod";
    version = "0.0.0+rev=6efb596";
    src = fetchgit {
      url = "https://github.com/camdencheek/tree-sitter-go-mod";
      rev = "6efb59652d30e0e9cd5f3b3a669afd6f1a926d3c";
      sha256 = "sha256-KD6Fio9qie3wbGAvQaYsMdYOK1QjnRrGExt1oL/6mis=";
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

  tree-sitter-gotmpl = {
    pname = "tree-sitter-gotmpl";
    version = "0.0.0+rev=5f19a36";
    src = fetchgit {
      url = "https://github.com/ngalaiko/tree-sitter-go-template";
      rev = "5f19a36bb1eebb30454e277b222b278ceafed0dd";
      sha256 = "sha256-apZ5yhWzLxaJFxMcuugNTuCxdDUxhKTZecZFsvjyqdo=";
    };
    language = "gotmpl";
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

  tree-sitter-gpg = {
    pname = "tree-sitter-gpg";
    version = "0.0.0+rev=63e80cf";
    src = fetchgit {
      url = "https://github.com/ObserverOfTime/tree-sitter-gpg-config";
      rev = "63e80cfe1302da9f9c7ee8d9df295f47d7d181bf";
      sha256 = "sha256-W8BglyjX/OytZCACpVi9V/k7A0Q4JaVQV+9NcyqtFsc=";
    };
    language = "gpg";
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

  tree-sitter-gstlaunch = {
    pname = "tree-sitter-gstlaunch";
    version = "0.0.0+rev=549aef2";
    src = fetchgit {
      url = "https://github.com/theHamsta/tree-sitter-gstlaunch";
      rev = "549aef253fd38a53995cda1bf55c501174372bf7";
      sha256 = "sha256-zNUx/9dxEqyqTXCxEiNnYPzplnR7l9b2L4frYpPOA9M=";
    };
    language = "gstlaunch";
  };

  tree-sitter-haskell = {
    pname = "tree-sitter-haskell";
    version = "0.0.0+rev=0975ef7";
    src = fetchgit {
      url = "https://github.com/tree-sitter/tree-sitter-haskell";
      rev = "0975ef72fc3c47b530309ca93937d7d143523628";
      sha256 = "sha256-0wmdbXHZbHkv4pTrB1fCbExx9E83l+zaocGa+SvQsZQ=";
    };
    language = "haskell";
  };

  tree-sitter-haskell_persistent = {
    pname = "tree-sitter-haskell_persistent";
    version = "0.0.0+rev=577259b";
    src = fetchgit {
      url = "https://github.com/MercuryTechnologies/tree-sitter-haskell-persistent";
      rev = "577259b4068b2c281c9ebf94c109bd50a74d5857";
      sha256 = "sha256-ASdkBQ57GfpLF8NXgDzJMB/Marz9p1q03TZkwMgF/eQ=";
    };
    language = "haskell_persistent";
  };

  tree-sitter-heex = {
    pname = "tree-sitter-heex";
    version = "0.0.0+rev=008626a";
    src = fetchgit {
      url = "https://github.com/connorlay/tree-sitter-heex";
      rev = "008626a3fad379d17c81d5ed576edd9bd7a4fbf7";
      sha256 = "sha256-qBWiTT4K72zTfQE7BlMHbtpMOVVsv/cpzfc6JmTz7uk=";
    };
    language = "heex";
  };

  tree-sitter-helm = {
    pname = "tree-sitter-helm";
    version = "0.0.0+rev=5f19a36";
    src = fetchgit {
      url = "https://github.com/ngalaiko/tree-sitter-go-template";
      rev = "5f19a36bb1eebb30454e277b222b278ceafed0dd";
      sha256 = "sha256-apZ5yhWzLxaJFxMcuugNTuCxdDUxhKTZecZFsvjyqdo=";
    };
    language = "helm";
    location = "dialects/helm";
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

  tree-sitter-html = {
    pname = "tree-sitter-html";
    version = "0.0.0+rev=cbb91a0";
    src = fetchgit {
      url = "https://github.com/tree-sitter/tree-sitter-html";
      rev = "cbb91a0ff3621245e890d1c50cc811bffb77a26b";
      sha256 = "sha256-lNMiSDAQ49QpeyD1RzkIIUeRWdp2Wrv6+XQZdZ40c1g=";
    };
    language = "html";
  };

  tree-sitter-http = {
    pname = "tree-sitter-http";
    version = "0.0.0+rev=db8b439";
    src = fetchgit {
      url = "https://github.com/rest-nvim/tree-sitter-http";
      rev = "db8b4398de90b6d0b6c780aba96aaa2cd8e9202c";
      sha256 = "sha256-T/O4oxPEIg3nLi3CxCwGW+iXC18fWW2xgsY5nrptk/M=";
    };
    language = "http";
  };

  tree-sitter-java = {
    pname = "tree-sitter-java";
    version = "0.0.0+rev=a7db522";
    src = fetchgit {
      url = "https://github.com/tree-sitter/tree-sitter-java";
      rev = "a7db5227ec40fcfe94489559d8c9bc7c8181e25a";
      sha256 = "sha256-fNq5MMMr83wqn7lNgj0pfSZDF4XO98YbzfNsFjr3Kpw=";
    };
    language = "java";
  };

  tree-sitter-javadoc = {
    pname = "tree-sitter-javadoc";
    version = "0.0.0+rev=330cc9c";
    src = fetchgit {
      url = "https://github.com/rmuir/tree-sitter-javadoc";
      rev = "330cc9cb4f33545f7bfce6c3b6aa77fe6db1b537";
      sha256 = "sha256-CohZaeMihAZ4PK3nZbp0aGybUZQOGrjFZ/T+z2qD6DU=";
    };
    language = "javadoc";
  };

  tree-sitter-javascript = {
    pname = "tree-sitter-javascript";
    version = "0.0.0+rev=6fbef40";
    src = fetchgit {
      url = "https://github.com/tree-sitter/tree-sitter-javascript";
      rev = "6fbef40512dcd9f0a61ce03a4c9ae7597b36ab5c";
      sha256 = "sha256-X9DDCBF+gQYL0syfqgKVFvzoy2tnBl+veaYi7bUuRms=";
    };
    language = "javascript";
  };

  tree-sitter-jinja = {
    pname = "tree-sitter-jinja";
    version = "0.0.0+rev=9af6ce9";
    src = fetchgit {
      url = "https://github.com/cathaysia/tree-sitter-jinja";
      rev = "9af6ce9380fabd3d5b19d0254b8c8936e879c471";
      sha256 = "sha256-9powNKoE5JpB+5vVtZLE5falMiS6I/ZXp4NrqabiWLs=";
    };
    language = "jinja";
    location = "tree-sitter-jinja";
  };

  tree-sitter-jinja_inline = {
    pname = "tree-sitter-jinja_inline";
    version = "0.0.0+rev=9af6ce9";
    src = fetchgit {
      url = "https://github.com/cathaysia/tree-sitter-jinja";
      rev = "9af6ce9380fabd3d5b19d0254b8c8936e879c471";
      sha256 = "sha256-9powNKoE5JpB+5vVtZLE5falMiS6I/ZXp4NrqabiWLs=";
    };
    language = "jinja_inline";
    location = "tree-sitter-jinja_inline";
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
    version = "0.0.0+rev=a417db5";
    src = fetchgit {
      url = "https://github.com/tree-sitter/tree-sitter-jsdoc";
      rev = "a417db5dbdd869fccb6a8b75ec04459e1d4ccd2c";
      sha256 = "sha256-MMLgza5H9NWYn9jtOumwg3cz3hqb8GQGFc/yRSvUIVI=";
    };
    language = "jsdoc";
  };

  tree-sitter-json = {
    pname = "tree-sitter-json";
    version = "0.0.0+rev=46aa487";
    src = fetchgit {
      url = "https://github.com/tree-sitter/tree-sitter-json";
      rev = "46aa487b3ade14b7b05ef92507fdaa3915a662a3";
      sha256 = "sha256-s8aAOrM4Mh4O60iSORMefN3nvFxThFk/On5DvK1BwWs=";
    };
    language = "json";
  };

  tree-sitter-json5 = {
    pname = "tree-sitter-json5";
    version = "0.0.0+rev=ab0ba82";
    src = fetchgit {
      url = "https://github.com/Joakker/tree-sitter-json5";
      rev = "ab0ba8229d639ec4f3fa5f674c9133477f4b77bd";
      sha256 = "sha256-LaCCjvYnmofOVQ2Nqlzfh3KP3fNG0HBxkOng0gjYY1g=";
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
    version = "0.0.0+rev=ddd075f";
    src = fetchgit {
      url = "https://github.com/sourcegraph/tree-sitter-jsonnet";
      rev = "ddd075f1939aed8147b7aa67f042eda3fce22790";
      sha256 = "sha256-ODGRkirfUG8DqV6ZcGRjKeCyEtsU0r+ICK0kCG6Xza0=";
    };
    language = "jsonnet";
  };

  tree-sitter-just = {
    pname = "tree-sitter-just";
    version = "0.0.0+rev=bb0c898";
    src = fetchgit {
      url = "https://github.com/IndianBoy42/tree-sitter-just";
      rev = "bb0c898a80644de438e6efe5d88d30bf092935cd";
      sha256 = "sha256-FwEuH/2R745jsuFaVGNeUTv65xW+MPjbcakRNcAWfZU=";
    };
    language = "just";
  };

  tree-sitter-kcl = {
    pname = "tree-sitter-kcl";
    version = "0.0.0+rev=b0b2eb3";
    src = fetchgit {
      url = "https://github.com/kcl-lang/tree-sitter-kcl";
      rev = "b0b2eb38009e04035a6e266c7e11e541f3caab7c";
      sha256 = "sha256-Aeu1j77GdsNpo9PU+FcqN3ttT0eLaDKY4n8buftMiDc=";
    };
    language = "kcl";
  };

  tree-sitter-kconfig = {
    pname = "tree-sitter-kconfig";
    version = "0.0.0+rev=9ac99fe";
    src = fetchgit {
      url = "https://github.com/amaanq/tree-sitter-kconfig";
      rev = "9ac99fe4c0c27a35dc6f757cef534c646e944881";
      sha256 = "sha256-8gZZLGL7giVHQIirjUIfsx3scP1L1VTFIZX7QOyjWvk=";
    };
    language = "kconfig";
  };

  tree-sitter-kdl = {
    pname = "tree-sitter-kdl";
    version = "0.0.0+rev=b37e3d5";
    src = fetchgit {
      url = "https://github.com/amaanq/tree-sitter-kdl";
      rev = "b37e3d58e5c5cf8d739b315d6114e02d42e66664";
      sha256 = "sha256-irx8aMEdZG2WcQVE2c7ahwLjqEoUAOOjvhDDk69a6lE=";
    };
    language = "kdl";
  };

  tree-sitter-lalrpop = {
    pname = "tree-sitter-lalrpop";
    version = "0.0.0+rev=8d38e97";
    src = fetchgit {
      url = "https://github.com/traxys/tree-sitter-lalrpop";
      rev = "8d38e9755c05d37df8a24dadb0fc64f6588ac188";
      sha256 = "sha256-rqJ0Zr9zxPkqux+DCSaUszqijFpc35fUB6sAPdGdt/0=";
    };
    language = "lalrpop";
  };

  tree-sitter-latex = {
    pname = "tree-sitter-latex";
    version = "0.0.0+rev=7b06f6e";
    src = fetchgit {
      url = "https://github.com/latex-lsp/tree-sitter-latex";
      rev = "7b06f6ed394308e7407a1703d2724128c45fc9d7";
      sha256 = "sha256-HbRjblLBExpBkBBjHyEHfnK0oootjAsqkwjmGH3/UYI=";
    };
    language = "latex";
  };

  tree-sitter-linkerscript = {
    pname = "tree-sitter-linkerscript";
    version = "0.0.0+rev=f99011a";
    src = fetchgit {
      url = "https://github.com/amaanq/tree-sitter-linkerscript";
      rev = "f99011a3554213b654985a4b0a65b3b032ec4621";
      sha256 = "sha256-Do8MIcl5DJo00V4wqIbdVC0to+2YYwfy08QWqSLMkQA=";
    };
    language = "linkerscript";
  };

  tree-sitter-llvm = {
    pname = "tree-sitter-llvm";
    version = "0.0.0+rev=c14cb83";
    src = fetchgit {
      url = "https://github.com/benwilliamgraham/tree-sitter-llvm";
      rev = "c14cb839003348692158b845db9edda201374548";
      sha256 = "sha256-L3XwPhvwIR/mUbugMbaHS9dXyhO7bApv/gdlxQ+2Bbo=";
    };
    language = "llvm";
  };

  tree-sitter-lua = {
    pname = "tree-sitter-lua";
    version = "0.0.0+rev=db16e76";
    src = fetchgit {
      url = "https://github.com/MunifTanjim/tree-sitter-lua";
      rev = "db16e76558122e834ee214c8dc755b4a3edc82a9";
      sha256 = "sha256-uJdXqlDn8F8mjh/NukpkQA6jdd7YjYOBbugzIrBb6GA=";
    };
    language = "lua";
  };

  tree-sitter-luadoc = {
    pname = "tree-sitter-luadoc";
    version = "0.0.0+rev=873612a";
    src = fetchgit {
      url = "https://github.com/amaanq/tree-sitter-luadoc";
      rev = "873612aadd3f684dd4e631bdf42ea8990c57634e";
      sha256 = "sha256-ttGBB9sn+xd9jWzjNAzpo/lwYVYZGSUGEip4K3PfBP0=";
    };
    language = "luadoc";
  };

  tree-sitter-luap = {
    pname = "tree-sitter-luap";
    version = "0.0.0+rev=c134aae";
    src = fetchgit {
      url = "https://github.com/amaanq/tree-sitter-luap";
      rev = "c134aaec6acf4fa95fe4aa0dc9aba3eacdbbe55a";
      sha256 = "sha256-4mMUHBsdK4U4uhh8GpKlG3p/s3ZCcLX1qATPyTD4Xhg=";
    };
    language = "luap";
  };

  tree-sitter-luau = {
    pname = "tree-sitter-luau";
    version = "0.0.0+rev=a8914d6";
    src = fetchgit {
      url = "https://github.com/amaanq/tree-sitter-luau";
      rev = "a8914d6c1fc5131f8e1c13f769fa704c9f5eb02f";
      sha256 = "sha256-5qbZA2mxTvrsfUrpgD+4y3oeJsifA91c/hfcVwQBRgI=";
    };
    language = "luau";
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
    version = "0.0.0+rev=bbf1b3f";
    src = fetchgit {
      url = "https://github.com/acristoffers/tree-sitter-matlab";
      rev = "bbf1b3f0bd7417c1efb8958fe95be3d0d540207a";
      sha256 = "sha256-dFsHOqleUTJCzidlKv/5kpawYhbn0jmOIpPrpJQJj80=";
    };
    language = "matlab";
  };

  tree-sitter-meson = {
    pname = "tree-sitter-meson";
    version = "0.0.0+rev=a56af66";
    src = fetchgit {
      url = "https://github.com/Decodetalkers/tree-sitter-meson";
      rev = "a56af662e8540412fed5e40cc20435b2b9a20502";
      sha256 = "sha256-RT/CXsbo+TZeG+6m9kwSoS5RImchTe5P/7tRlgTnPJo=";
    };
    language = "meson";
  };

  tree-sitter-muttrc = {
    pname = "tree-sitter-muttrc";
    version = "0.0.0+rev=173b0ab";
    src = fetchgit {
      url = "https://github.com/neomutt/tree-sitter-muttrc";
      rev = "173b0ab53a9c07962c9777189c4c70e90f1c1837";
      sha256 = "sha256-zma/oyMFI+r+/616yXV9b4ptC1FNYpHlpqY/Fez++n0=";
    };
    language = "muttrc";
  };

  tree-sitter-nasm = {
    pname = "tree-sitter-nasm";
    version = "0.0.0+rev=d1b3638";
    src = fetchgit {
      url = "https://github.com/naclsn/tree-sitter-nasm";
      rev = "d1b3638d017f2a8585e26dcfc66fe1df94185e30";
      sha256 = "sha256-38yRvaSkHZ7iRmHlXdCssJtd/RQRfBB437HzBwWv2mg=";
    };
    language = "nasm";
  };

  tree-sitter-nginx = {
    pname = "tree-sitter-nginx";
    version = "0.0.0+rev=989da76";
    src = fetchgit {
      url = "https://github.com/opa-oz/tree-sitter-nginx";
      rev = "989da760be05a3334af3ec88705cbf57e6a9c41d";
      sha256 = "sha256-tIbwsh7cnpm1jkIKaXQ7NI/LXWzEOsZyNLfe/qTNkkM=";
    };
    language = "nginx";
  };

  tree-sitter-nickel = {
    pname = "tree-sitter-nickel";
    version = "0.0.0+rev=25464b3";
    src = fetchgit {
      url = "https://github.com/nickel-lang/tree-sitter-nickel";
      rev = "25464b33522c3f609fa512aa9651707c0b66d48b";
      sha256 = "sha256-dQeUoHQHkPYywYIm3TMnTWPXUlh2xh8M5CVUiXASBu8=";
    };
    language = "nickel";
  };

  tree-sitter-nix = {
    pname = "tree-sitter-nix";
    version = "0.0.0+rev=cfc53fd";
    src = fetchgit {
      url = "https://github.com/cstrahan/tree-sitter-nix";
      rev = "cfc53fd287d23ab7281440a8526c73542984669b";
      sha256 = "sha256-eqqneqZqA73McjPZfy7GbUi4ccmDYC5O++Ezt9+lqi4=";
    };
    language = "nix";
  };

  tree-sitter-norg = {
    pname = "tree-sitter-norg";
    version = "0.0.0+rev=d89d95a";
    src = fetchgit {
      url = "https://github.com/nvim-neorg/tree-sitter-norg";
      rev = "d89d95af13d409f30a6c7676387bde311ec4a2c8";
      sha256 = "sha256-z3h5qMuNKnpQgV62xZ02F5vWEq4VEnm5lxwEnIFu+Rw=";
    };
    language = "norg";
  };

  tree-sitter-objdump = {
    pname = "tree-sitter-objdump";
    version = "0.0.0+rev=28d3b2e";
    src = fetchgit {
      url = "https://github.com/ColinKennedy/tree-sitter-objdump";
      rev = "28d3b2e25a0b1881d1b47ed1924ca276c7003d45";
      sha256 = "sha256-OPqIhgItghXplQ78Vlwd0G6KtDWTVkaG17RPqx1b5JY=";
    };
    language = "objdump";
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
    version = "0.0.0+rev=1d16b8e";
    src = fetchgit {
      url = "https://github.com/ObserverOfTime/tree-sitter-pem";
      rev = "1d16b8e063fdf4385e389096c4bc4999eaaef05f";
      sha256 = "sha256-NhiSqaLjzEJHj8JimFdcZBVAR00lKf9O5JLtwIUCKhw=";
    };
    language = "pem";
  };

  tree-sitter-perl = {
    pname = "tree-sitter-perl";
    version = "0.0.0+rev=ecd90bd";
    src = fetchgit {
      url = "https://github.com/tree-sitter-perl/tree-sitter-perl";
      rev = "ecd90bd8b381bcc7219fed4fe351903630e761c6";
      sha256 = "sha256-iIa0FJ4kCgfOM/jKwSpaGyOlNwUtczhqoO5gKW7PAHI=";
    };
    language = "perl";
  };

  tree-sitter-php = {
    pname = "tree-sitter-php";
    version = "0.0.0+rev=576a56f";
    src = fetchgit {
      url = "https://github.com/tree-sitter/tree-sitter-php";
      rev = "576a56fa7f8b68c91524cdd211eb2ffc43e7bb11";
      sha256 = "sha256-kTiqj4KWHTZVJ6R6axubNGdcTNA+W02RTsBcoeR2xGU=";
    };
    language = "php";
    location = "php";
  };

  tree-sitter-php_only = {
    pname = "tree-sitter-php_only";
    version = "0.0.0+rev=576a56f";
    src = fetchgit {
      url = "https://github.com/tree-sitter/tree-sitter-php";
      rev = "576a56fa7f8b68c91524cdd211eb2ffc43e7bb11";
      sha256 = "sha256-kTiqj4KWHTZVJ6R6axubNGdcTNA+W02RTsBcoeR2xGU=";
    };
    language = "php_only";
    location = "php_only";
  };

  tree-sitter-po = {
    pname = "tree-sitter-po";
    version = "0.0.0+rev=bd860a0";
    src = fetchgit {
      url = "https://github.com/erasin/tree-sitter-po";
      rev = "bd860a0f57f697162bf28e576674be9c1500db5e";
      sha256 = "sha256-/St0VxDTAF872ZlBph1TukRoO0PBIOMT0D11DZ6nSLQ=";
    };
    language = "po";
  };

  tree-sitter-pod = {
    pname = "tree-sitter-pod";
    version = "0.0.0+rev=0bf8387";
    src = fetchgit {
      url = "https://github.com/tree-sitter-perl/tree-sitter-pod";
      rev = "0bf8387987c21bf2f8ed41d2575a8f22b139687f";
      sha256 = "sha256-yV2kVAxWxdyIJ3g2oivDc01SAQF0lc7UMT2sfv9lKzI=";
    };
    language = "pod";
  };

  tree-sitter-pony = {
    pname = "tree-sitter-pony";
    version = "0.0.0+rev=73ff874";
    src = fetchgit {
      url = "https://github.com/amaanq/tree-sitter-pony";
      rev = "73ff874ae4c9e9b45462673cbc0a1e350e2522a7";
      sha256 = "sha256-/9bTbep2AXLoiijeft9amMeFQ6fHXzItjH+bD/w6pDo=";
    };
    language = "pony";
  };

  tree-sitter-printf = {
    pname = "tree-sitter-printf";
    version = "0.0.0+rev=df6b699";
    src = fetchgit {
      url = "https://github.com/ObserverOfTime/tree-sitter-printf";
      rev = "df6b69967db7d74ab338a86a9ab45c0966c5ee3c";
      sha256 = "sha256-54yEvxL6u+Mya4INj1AIb1ldYv1WdQV55z8+wgKdthc=";
    };
    language = "printf";
  };

  tree-sitter-prisma = {
    pname = "tree-sitter-prisma";
    version = "0.0.0+rev=73f39a6";
    src = fetchgit {
      url = "https://github.com/victorhqc/tree-sitter-prisma";
      rev = "73f39a6d5401cfdcd143951e499336cf5ab2ffaa";
      sha256 = "sha256-0wHh+Gf2wer/35NdEWOCQFNdRH/wVWnRx9HnlX7vZho=";
    };
    language = "prisma";
  };

  tree-sitter-promql = {
    pname = "tree-sitter-promql";
    version = "0.0.0+rev=77625d7";
    src = fetchgit {
      url = "https://github.com/MichaHoffmann/tree-sitter-promql";
      rev = "77625d78eebc3ffc44d114a07b2f348dff3061b0";
      sha256 = "sha256-IJbnC03pDfcSAF//Ux+LqqfjtagGSD5Nu46yUo0vT5Q=";
    };
    language = "promql";
  };

  tree-sitter-properties = {
    pname = "tree-sitter-properties";
    version = "0.0.0+rev=579b62f";
    src = fetchgit {
      url = "https://github.com/tree-sitter-grammars/tree-sitter-properties";
      rev = "579b62f5ad8d96c2bb331f07d1408c92767531d9";
      sha256 = "sha256-4WgGbU6fthFH1DcvlQiqNGXucCfxA+hANZ7Y+r8eXHg=";
    };
    language = "properties";
  };

  tree-sitter-proto = {
    pname = "tree-sitter-proto";
    version = "0.0.0+rev=e9f6b43";
    src = fetchgit {
      url = "https://github.com/treywood/tree-sitter-proto";
      rev = "e9f6b43f6844bd2189b50a422d4e2094313f6aa3";
      sha256 = "sha256-Ue6w6HWy+NTJt+AKTFfJIUf3HXHTwkUkDk4UdDMSD+U=";
    };
    language = "proto";
  };

  tree-sitter-psv = {
    pname = "tree-sitter-psv";
    version = "0.0.0+rev=7eb7297";
    src = fetchgit {
      url = "https://github.com/amaanq/tree-sitter-csv";
      rev = "7eb7297823605392d2bbcc4c09b1cd18d6fa9529";
      sha256 = "sha256-5VL7uREH0lloAWo9rdJXsjDsWxgL6fngWJSmi4fM7UQ=";
    };
    language = "psv";
    location = "psv";
  };

  tree-sitter-puppet = {
    pname = "tree-sitter-puppet";
    version = "0.0.0+rev=15f1929";
    src = fetchgit {
      url = "https://github.com/amaanq/tree-sitter-puppet";
      rev = "15f192929b7d317f5914de2b4accd37b349182a6";
      sha256 = "sha256-bO5g5AdhzpB13yHklpAndUHIX7Rvd7OMjH0Ds2ATA6Q=";
    };
    language = "puppet";
  };

  tree-sitter-python = {
    pname = "tree-sitter-python";
    version = "0.0.0+rev=710796b";
    src = fetchgit {
      url = "https://github.com/tree-sitter/tree-sitter-python";
      rev = "710796b8b877a970297106e5bbc8e2afa47f86ec";
      sha256 = "sha256-t9etfZcrliF7f9hfiomh2U9P+3ufAm8iSK1y9rOhP7s=";
    };
    language = "python";
  };

  tree-sitter-ql = {
    pname = "tree-sitter-ql";
    version = "0.0.0+rev=1fd627a";
    src = fetchgit {
      url = "https://github.com/tree-sitter/tree-sitter-ql";
      rev = "1fd627a4e8bff8c24c11987474bd33112bead857";
      sha256 = "sha256-mJ/bj09mT1WTaiKoXiRXDM7dkenf5hv2ArXieeTVe6I=";
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
    version = "0.0.0+rev=0889da4";
    src = fetchgit {
      url = "https://github.com/yuja/tree-sitter-qmljs";
      rev = "0889da4632bba3ec6f39ef4102625654890c15c1";
      sha256 = "sha256-Twj2taG7xFTPXTvzDcWeIqxUAkuhsybwZvtwK/HiruE=";
    };
    language = "qmljs";
  };

  tree-sitter-query = {
    pname = "tree-sitter-query";
    version = "0.0.0+rev=930202c";
    src = fetchgit {
      url = "https://github.com/nvim-treesitter/tree-sitter-query";
      rev = "930202c2a80965a7a9ca018b5b2a08b25dfa7f12";
      sha256 = "sha256-uXApakOZy9Gd/fl9C9qFZgptlT6rUlOmT6KW8sWP5Ag=";
    };
    language = "query";
  };

  tree-sitter-rasi = {
    pname = "tree-sitter-rasi";
    version = "0.0.0+rev=6c9bbcf";
    src = fetchgit {
      url = "https://github.com/Fymyte/tree-sitter-rasi";
      rev = "6c9bbcfdf5f0f553d9ebc01750a3aa247a37b8aa";
      sha256 = "sha256-sPrIVgGGaBaXeqHNxjcdJ/S2FvxyV6rD9UPKU/tpspw=";
    };
    language = "rasi";
  };

  tree-sitter-readline = {
    pname = "tree-sitter-readline";
    version = "0.0.0+rev=74addc9";
    src = fetchgit {
      url = "https://github.com/ribru17/tree-sitter-readline";
      rev = "74addc90fc539d31d413c0c7cf7581997a7fa46e";
      sha256 = "sha256-cbQnAPtgMnA41CTI9OyY8WYvdlJOC9g0ZMbitNSvtmI=";
    };
    language = "readline";
  };

  tree-sitter-regex = {
    pname = "tree-sitter-regex";
    version = "0.0.0+rev=b638d29";
    src = fetchgit {
      url = "https://github.com/tree-sitter/tree-sitter-regex";
      rev = "b638d29335ef41215b86732dd51be34c701ef683";
      sha256 = "sha256-KHPwvjqvgqLKGL/OeotF1djSSSrAsb2H3CNUmgiva18=";
    };
    language = "regex";
  };

  tree-sitter-rego = {
    pname = "tree-sitter-rego";
    version = "0.0.0+rev=20b5a59";
    src = fetchgit {
      url = "https://github.com/FallenAngel97/tree-sitter-rego";
      rev = "20b5a5958c837bc9f74b231022a68a594a313f6d";
      sha256 = "sha256-XwlVsOlxYzB0x+T05iuIp7nFAoQkMByKiHXZ0t5QsjI=";
    };
    language = "rego";
  };

  tree-sitter-requirements = {
    pname = "tree-sitter-requirements";
    version = "0.0.0+rev=7289100";
    src = fetchgit {
      url = "https://github.com/ObserverOfTime/tree-sitter-requirements";
      rev = "728910099ddea7f1f94ea95a35a70d1ea76a1639";
      sha256 = "sha256-IiIvU4iyqlP9px6qCivmQXusp/vuhOJBfWqMfcdKN7s=";
    };
    language = "requirements";
  };

  tree-sitter-rescript = {
    pname = "tree-sitter-rescript";
    version = "0.0.0+rev=4606cd8";
    src = fetchgit {
      url = "https://github.com/rescript-lang/tree-sitter-rescript";
      rev = "4606cd81c4c31d1d02390fee530858323410a74c";
      sha256 = "sha256-md3fgW+h99va2Rwxzub7nrsEe64fC52g6NPCaXGAaxg=";
    };
    language = "rescript";
  };

  tree-sitter-rnoweb = {
    pname = "tree-sitter-rnoweb";
    version = "0.0.0+rev=1a74dc0";
    src = fetchgit {
      url = "https://github.com/bamonroe/tree-sitter-rnoweb";
      rev = "1a74dc0ed731ad07db39f063e2c5a6fe528cae7f";
      sha256 = "sha256-sCjSS6iunij2SXHNzQcTq0HKawH9i5h/vQ6yl77opXw=";
    };
    language = "rnoweb";
  };

  tree-sitter-robot = {
    pname = "tree-sitter-robot";
    version = "0.0.0+rev=17c2300";
    src = fetchgit {
      url = "https://github.com/Hubro/tree-sitter-robot";
      rev = "17c2300e91fc9da4ba14c16558bf4292941dc074";
      sha256 = "sha256-9f0xFmhEQnETvV2SAZW+jRtsVdl0ZT3CDmGkcd3Fn88=";
    };
    language = "robot";
  };

  tree-sitter-robots = {
    pname = "tree-sitter-robots";
    version = "0.0.0+rev=8e3a420";
    src = fetchgit {
      url = "https://github.com/opa-oz/tree-sitter-robots-txt";
      rev = "8e3a4205b76236bb6dbebdbee5afc262ce38bb62";
      sha256 = "sha256-OePLE85CWbl0hnre4Apq5Ix2GA8juGV2TE891Py4AME=";
    };
    language = "robots";
  };

  tree-sitter-rst = {
    pname = "tree-sitter-rst";
    version = "0.0.0+rev=4e562e1";
    src = fetchgit {
      url = "https://github.com/stsewd/tree-sitter-rst";
      rev = "4e562e1598b95b93db4f3f64fe40ddefbc677a15";
      sha256 = "sha256-C65FmrEUyMQN+rF3RTN1oNVJtGiTHMZvdRyy/tMjVqY=";
    };
    language = "rst";
  };

  tree-sitter-ruby = {
    pname = "tree-sitter-ruby";
    version = "0.0.0+rev=89bd7a8";
    src = fetchgit {
      url = "https://github.com/tree-sitter/tree-sitter-ruby";
      rev = "89bd7a8e5450cb6a942418a619d30469f259e5d6";
      sha256 = "sha256-84Nqw6QyGqwKAT+7Cdrzl1SikfJ3doX3tngGZWaXkVc=";
    };
    language = "ruby";
  };

  tree-sitter-rust = {
    pname = "tree-sitter-rust";
    version = "0.0.0+rev=e86119b";
    src = fetchgit {
      url = "https://github.com/tree-sitter/tree-sitter-rust";
      rev = "e86119bdb4968b9799f6a014ca2401c178d54b5f";
      sha256 = "sha256-zJHUx5ZQVJ80hWWWh/PlO0jrOcCHDm9EPUTmZChab6g=";
    };
    language = "rust";
  };

  tree-sitter-scfg = {
    pname = "tree-sitter-scfg";
    version = "0.0.0+rev=2f3709e";
    src = fetchgit {
      url = "https://github.com/rockorager/tree-sitter-scfg";
      rev = "2f3709e7656fa2c443f92041c91a9f843f8cd625";
      sha256 = "sha256-2/n+pSR6Ojahm8iBnpNsQscrXQqzZflKBA42gX29u50=";
    };
    language = "scfg";
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

  tree-sitter-sflog = {
    pname = "tree-sitter-sflog";
    version = "0.0.0+rev=3597575";
    src = fetchgit {
      url = "https://github.com/aheber/tree-sitter-sfapex";
      rev = "3597575a429766dd7ecce9f5bb97f6fec4419d5d";
      sha256 = "sha256-TOytPX/jBdVDYHBacpT9hAVVZcW+XGvIsubAqs9Dm80=";
    };
    language = "sflog";
    location = "sflog";
  };

  tree-sitter-slint = {
    pname = "tree-sitter-slint";
    version = "0.0.0+rev=f11da7e";
    src = fetchgit {
      url = "https://github.com/slint-ui/tree-sitter-slint";
      rev = "f11da7e62051ba8b9d4faa299c26de8aeedfc1cd";
      sha256 = "sha256-NTxJwVYq3o+9+BbBi4Lcj++mB4hvKAN3N+dRadXuBNo=";
    };
    language = "slint";
  };

  tree-sitter-smali = {
    pname = "tree-sitter-smali";
    version = "0.0.0+rev=fdfa6a1";
    src = fetchgit {
      url = "https://github.com/tree-sitter-grammars/tree-sitter-smali";
      rev = "fdfa6a1febc43c7467aa7e937b87b607956f2346";
      sha256 = "sha256-S0U6Xuntz16DrpYwSqMQu8Cu7UuD/JufHUxIHv826yw=";
    };
    language = "smali";
  };

  tree-sitter-smithy = {
    pname = "tree-sitter-smithy";
    version = "0.0.0+rev=fa898ac";
    src = fetchgit {
      url = "https://github.com/indoorvivants/tree-sitter-smithy";
      rev = "fa898ac0885d1da9a253695c3e0e91f5efc587cd";
      sha256 = "sha256-tB+q4RNru4Zi3jU9fBLKdzsXT0uP1PECLfeCCNTyaIo=";
    };
    language = "smithy";
  };

  tree-sitter-sql = {
    pname = "tree-sitter-sql";
    version = "0.0.0+rev=b9d1095";
    src = fetchgit {
      url = "https://github.com/derekstride/tree-sitter-sql";
      rev = "b9d109588d5b5ed986c857464830c2f0bef53f18";
      sha256 = "sha256-uEiwHIlLC6AyqD3/fH9KmXMdgQUb30MwBGrjPoyAPbc=";
    };
    language = "sql";
  };

  tree-sitter-ssh_config = {
    pname = "tree-sitter-ssh_config";
    version = "0.0.0+rev=0dd3c7e";
    src = fetchgit {
      url = "https://github.com/ObserverOfTime/tree-sitter-ssh-config";
      rev = "0dd3c7e9f301758f6c69a6efde43d3048deb4d8a";
      sha256 = "sha256-jNB9cHOfHDIRPELm8LedJjNzjx16/ApcPGi8eaaJKZs=";
    };
    language = "ssh_config";
  };

  tree-sitter-starlark = {
    pname = "tree-sitter-starlark";
    version = "0.0.0+rev=a453dbf";
    src = fetchgit {
      url = "https://github.com/amaanq/tree-sitter-starlark";
      rev = "a453dbf3ba433db0e5ec621a38a7e59d72e4dc69";
      sha256 = "sha256-iBchBq9NE4QqHc8MbWs4YgzUH6EB0W7RCIk07I6Zm+I=";
    };
    language = "starlark";
  };

  tree-sitter-strace = {
    pname = "tree-sitter-strace";
    version = "0.0.0+rev=d819cdd";
    src = fetchgit {
      url = "https://github.com/sigmaSd/tree-sitter-strace";
      rev = "d819cdd5dbe455bd3c859193633c8d91c0df7c36";
      sha256 = "sha256-u2LznohljEq7WEoVbwr1ZyV+qbchDuoktJFCeh4iePg=";
    };
    language = "strace";
  };

  tree-sitter-styled = {
    pname = "tree-sitter-styled";
    version = "0.0.0+rev=319cdca";
    src = fetchgit {
      url = "https://github.com/mskelton/tree-sitter-styled";
      rev = "319cdcaa0346ba6db668a222d938e5c3569e2a51";
      sha256 = "sha256-thZNygJ3GonJRdmGqLtoJqQu/yt85noIAEsfyKHLdoo=";
    };
    language = "styled";
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
    version = "0.0.0+rev=ae5199d";
    src = fetchgit {
      url = "https://github.com/tree-sitter-grammars/tree-sitter-svelte";
      rev = "ae5199db47757f785e43a14b332118a5474de1a2";
      sha256 = "sha256-cH9h7i6MImw7KlcuVQ6XVKNjd9dFjo93J1JdTWmEpV4=";
    };
    language = "svelte";
  };

  tree-sitter-tcl = {
    pname = "tree-sitter-tcl";
    version = "0.0.0+rev=f15e711";
    src = fetchgit {
      url = "https://github.com/tree-sitter-grammars/tree-sitter-tcl";
      rev = "f15e711167661d1ba541d4f62b9dbfc4ce61ec56";
      sha256 = "sha256-173xUAc2/LMDQSTEM3l3R4UuF/R5fdUyhEpXv6Eh02s=";
    };
    language = "tcl";
  };

  tree-sitter-templ = {
    pname = "tree-sitter-templ";
    version = "0.0.0+rev=def9849";
    src = fetchgit {
      url = "https://github.com/vrischmann/tree-sitter-templ";
      rev = "def9849184de71a797c4e2b2837df85abeccf92c";
      sha256 = "sha256-LeCLVE0TxKIwkR1x1p4ZFUC/Q/qpOE64Ycn/GaWrZYA=";
    };
    language = "templ";
  };

  tree-sitter-tera = {
    pname = "tree-sitter-tera";
    version = "0.0.0+rev=25a7c61";
    src = fetchgit {
      url = "https://github.com/uncenter/tree-sitter-tera";
      rev = "25a7c617192253bddfa65e378975d8c476419010";
      sha256 = "sha256-5ahHmvvuOY+1FhfOdbNIQokodfG1WXG1gK7BA1sEyYk=";
    };
    language = "tera";
  };

  tree-sitter-terraform = {
    pname = "tree-sitter-terraform";
    version = "0.0.0+rev=de10d49";
    src = fetchgit {
      url = "https://github.com/MichaHoffmann/tree-sitter-hcl";
      rev = "de10d494dbd6b71cdf07a678fecbf404dbfe4398";
      sha256 = "sha256-oRNNxE5AnI0TyJl92pk0E9xGj5xom/+0kpPMUE/O/TY=";
    };
    language = "terraform";
    location = "dialects/terraform";
  };

  tree-sitter-textproto = {
    pname = "tree-sitter-textproto";
    version = "0.0.0+rev=568471b";
    src = fetchgit {
      url = "https://github.com/PorterAtGoogle/tree-sitter-textproto";
      rev = "568471b80fd8793d37ed01865d8c2208a9fefd1b";
      sha256 = "sha256-VAj8qSxbkFqNp0X8BOZNvGTggSXZvzDjODedY11J0BQ=";
    };
    language = "textproto";
  };

  tree-sitter-thrift = {
    pname = "tree-sitter-thrift";
    version = "0.0.0+rev=68fd0d8";
    src = fetchgit {
      url = "https://github.com/duskmoon314/tree-sitter-thrift";
      rev = "68fd0d80943a828d9e6f49c58a74be1e9ca142cf";
      sha256 = "sha256-owZbs8ttjKrqTA8fQ/NmBGyIUUItSUvvW4hRv0NPV8Y=";
    };
    language = "thrift";
  };

  tree-sitter-tmux = {
    pname = "tree-sitter-tmux";
    version = "0.0.0+rev=0252ecd";
    src = fetchgit {
      url = "https://github.com/Freed-Wu/tree-sitter-tmux";
      rev = "0252ecd080016e45e6305ef1a943388f5ae2f4b4";
      sha256 = "sha256-8f78qYxqoiOAnl3HzEbF4Rci3rFy0SnELoU+QP7pUlk=";
    };
    language = "tmux";
  };

  tree-sitter-toml = {
    pname = "tree-sitter-toml";
    version = "0.0.0+rev=64b5683";
    src = fetchgit {
      url = "https://github.com/tree-sitter-grammars/tree-sitter-toml";
      rev = "64b56832c2cffe41758f28e05c756a3a98d16f41";
      sha256 = "sha256-m9RlGkHiOL/PNENrdEPqtPlahSqGymsx7gZrCoN/Lsk=";
    };
    generate = true;
    language = "toml";
  };

  tree-sitter-tsv = {
    pname = "tree-sitter-tsv";
    version = "0.0.0+rev=7eb7297";
    src = fetchgit {
      url = "https://github.com/amaanq/tree-sitter-csv";
      rev = "7eb7297823605392d2bbcc4c09b1cd18d6fa9529";
      sha256 = "sha256-5VL7uREH0lloAWo9rdJXsjDsWxgL6fngWJSmi4fM7UQ=";
    };
    language = "tsv";
    location = "tsv";
  };

  tree-sitter-tsx = {
    pname = "tree-sitter-tsx";
    version = "0.0.0+rev=75b3874";
    src = fetchgit {
      url = "https://github.com/tree-sitter/tree-sitter-typescript";
      rev = "75b3874edb2dc714fb1fd77a32013d0f8699989f";
      sha256 = "sha256-A0M6IBoY87ekSV4DfGHDU5zzFWdLjGqSyVr6VENgA+s=";
    };
    generate = true;
    language = "tsx";
    location = "tsx";
  };

  tree-sitter-typescript = {
    pname = "tree-sitter-typescript";
    version = "0.0.0+rev=75b3874";
    src = fetchgit {
      url = "https://github.com/tree-sitter/tree-sitter-typescript";
      rev = "75b3874edb2dc714fb1fd77a32013d0f8699989f";
      sha256 = "sha256-A0M6IBoY87ekSV4DfGHDU5zzFWdLjGqSyVr6VENgA+s=";
    };
    generate = true;
    language = "typescript";
    location = "typescript";
  };

  tree-sitter-typespec = {
    pname = "tree-sitter-typespec";
    version = "0.0.0+rev=42fb163";
    src = fetchgit {
      url = "https://github.com/happenslol/tree-sitter-typespec";
      rev = "42fb163442ef2691b9b720fb4e4e846809415d18";
      sha256 = "sha256-yWXfDC4etuXn1jV8DsSSL028LUXSnsvCaog6ggtd8ro=";
    };
    language = "typespec";
  };

  tree-sitter-udev = {
    pname = "tree-sitter-udev";
    version = "0.0.0+rev=18a1d18";
    src = fetchgit {
      url = "https://github.com/ObserverOfTime/tree-sitter-udev";
      rev = "18a1d183c4c0cc40438bae2ebf8191aaf2dee8dc";
      sha256 = "sha256-ySo+vS+il1tmTPZ6OJMduyJxsjjI3eIkYSMYs10Bcnk=";
    };
    language = "udev";
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
    version = "0.0.0+rev=4e0875f";
    src = fetchgit {
      url = "https://github.com/ColinKennedy/tree-sitter-usd";
      rev = "4e0875f724d94d0c2ff36f9b8cb0b12f8b20d216";
      sha256 = "sha256-r6Sm8FiTgxdYc5cAG5JXVtA5/2jID5H/xmKbjSYn/zI=";
    };
    language = "usd";
  };

  tree-sitter-verilog = {
    pname = "tree-sitter-verilog";
    version = "0.0.0+rev=15fbf73";
    src = fetchgit {
      url = "https://github.com/gmlarumbe/tree-sitter-systemverilog";
      rev = "15fbf73dafaffc89050d247857beb27500ea30e8";
      sha256 = "sha256-cCnFq2cL2lnTBXSVTVbHiGW/MDJARgqgGUjKmaTpOJI=";
    };
    language = "verilog";
  };

  tree-sitter-vim = {
    pname = "tree-sitter-vim";
    version = "0.0.0+rev=11b688a";
    src = fetchgit {
      url = "https://github.com/neovim/tree-sitter-vim";
      rev = "11b688a1f0e97c0c4e3dbabf4a38016335f4d237";
      sha256 = "sha256-UvH/k0gWEhrgxG1HnrdmaLHzygkaKk4hx2gK/6TZYNM=";
    };
    language = "vim";
  };

  tree-sitter-vimdoc = {
    pname = "tree-sitter-vimdoc";
    version = "0.0.0+rev=2694c3d";
    src = fetchgit {
      url = "https://github.com/neovim/tree-sitter-vimdoc";
      rev = "2694c3d27e2ca98a0ccde72f33887394300d524e";
      sha256 = "sha256-DAHOhNqd9DQ9KNkJdjbUmSV6qhTOmPrIaC/7rBNCqzY=";
    };
    language = "vimdoc";
  };

  tree-sitter-vue = {
    pname = "tree-sitter-vue";
    version = "0.0.0+rev=22bdfa6";
    src = fetchgit {
      url = "https://github.com/tree-sitter-grammars/tree-sitter-vue";
      rev = "22bdfa6c9fc0f5ffa44c6e938ec46869ac8a99ff";
      sha256 = "sha256-LnmUtJJpBIZPTJqrQQ7WI8V44hPw3yxR+j2jR0pHIdY=";
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
    version = "0.0.0+rev=47c1818";
    src = fetchgit {
      url = "https://github.com/theHamsta/tree-sitter-wgsl-bevy";
      rev = "47c1818d245a6156a488c4c4d06e9336714bae9b";
      sha256 = "sha256-oL9HDMDl6MgDLZw4NWtdX7W775JZKwD2BweAO+9iI/k=";
    };
    generate = true;
    language = "wgsl_bevy";
  };

  tree-sitter-xcompose = {
    pname = "tree-sitter-xcompose";
    version = "0.0.0+rev=fff3e72";
    src = fetchgit {
      url = "https://github.com/ObserverOfTime/tree-sitter-xcompose";
      rev = "fff3e72242aa110ebba6441946ea4d12d200fa68";
      sha256 = "sha256-PNg1z+7CuvpQdksKJOCQ59dZrv4PORdYo6CSw3GrBtk=";
    };
    language = "xcompose";
  };

  tree-sitter-xml = {
    pname = "tree-sitter-xml";
    version = "0.0.0+rev=0d9a809";
    src = fetchgit {
      url = "https://github.com/tree-sitter-grammars/tree-sitter-xml";
      rev = "0d9a8099c963ed53e183425c1b47fa2622c8eaf7";
      sha256 = "sha256-0kqCDLCxsvrqu5pKrDZDJt9lSlxU6fzM/CxrWb/oodw=";
    };
    language = "xml";
    location = "xml";
  };

  tree-sitter-xresources = {
    pname = "tree-sitter-xresources";
    version = "0.0.0+rev=d0f9dc7";
    src = fetchgit {
      url = "https://github.com/ValdezFOmar/tree-sitter-xresources";
      rev = "d0f9dc7cec4dc15fc6f9d556bb4e9dd5050328a6";
      sha256 = "sha256-3TBpNdIsmOutazBlMKAsQaq7RPu4vUeZMFuZ2/2HDKo=";
    };
    language = "xresources";
  };

  tree-sitter-yaml = {
    pname = "tree-sitter-yaml";
    version = "0.0.0+rev=1805917";
    src = fetchgit {
      url = "https://github.com/tree-sitter-grammars/tree-sitter-yaml";
      rev = "1805917414a9a8ba2473717fd69447277a175fae";
      sha256 = "sha256-hYWIZLxAeUxPuCn6BuYP8T7UjLlHkeiIMm6iU0b40aU=";
    };
    language = "yaml";
  };

  tree-sitter-zig = {
    pname = "tree-sitter-zig";
    version = "0.0.0+rev=b670c8d";
    src = fetchgit {
      url = "https://github.com/tree-sitter-grammars/tree-sitter-zig";
      rev = "b670c8df85a1568f498aa5c8cae42f51a90473c0";
      sha256 = "sha256-lDMmnmeGr2ti9W692ZqySWObzSUa9vY7f+oHZiE8N+U=";
    };
    language = "zig";
  };
}
