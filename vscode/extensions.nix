# This file is generated; DO NOT EDIT.

# See: https://nixos.wiki/wiki/Vscode
{ pkgs, ... }:

(
  with pkgs.vscode-extensions; [
    ms-vscode.cpptools
  ]
) ++ (
  pkgs.vscode-utils.extensionsFromVscodeMarketplace [
    {
      name = "clang-format";
      publisher = "xaver";
      version = "1.9.0";
      sha256 = "0bwc4lpcjq1x73kwd6kxr674v3rb0d2cjj65g3r69y7gfs8yzl5b";
    }
    {
      name = "cmake";
      publisher = "twxs";
      version = "0.0.17";
      sha256 = "11hzjd0gxkq37689rrr2aszxng5l9fwpgs9nnglq3zhfa1msyn08";
    }
    {
      name = "dart-code";
      publisher = "Dart-Code";
      version = "3.11.0";
      sha256 = "0rgszz5iw6ja2cjmg3vl1m1a4392rkykcw2n7xskf1pgc73kf1h0";
    }
    {
      name = "elm-ls-vscode";
      publisher = "Elmtooling";
      version = "1.5.2";
      sha256 = "180si30c26jmh397ish8p1il628fgq54fgs8p2y6861pacc49kxw";
    }
    {
      name = "flutter";
      publisher = "Dart-Code";
      version = "3.12.2";
      sha256 = "0a7s9nadr10dia8j247aha98snqfq7vpafpsgmn4ls4nshr3ayjv";
    }
    {
      name = "Go";
      publisher = "golang";
      version = "0.14.1";
      sha256 = "1zj87m0swjnr7k9nwxj2db96h90fs1cny7w9c0q4kqnrrysh8ala";
    }
    {
      name = "language-haskell";
      publisher = "justusadam";
      version = "3.3.0";
      sha256 = "1285bs89d7hqn8h8jyxww7712070zw2ccrgy6aswd39arscniffs";
    }
    {
      name = "vscode-ghc-simple";
      publisher = "dramforever";
      version = "0.1.22";
      sha256 = "0x3csdn3pz5rhl9mhplpm8kxb40l1dw5rnwhh3zsif3rz0nqhk2a";
    }
    {
      name = "brittany";
      publisher = "MaxGabriel";
      version = "0.0.9";
      sha256 = "1cfbzc8fmvfsxyfwr11vnszvirl47zzjbjp6rihg5518gf5wd36k";
    }
    {
      name = "lua";
      publisher = "sumneko";
      version = "0.17.0";
      sha256 = "1s639aw3x8j9wz8rffivvpid8bbd7d77zb75y3vb9259ndxppy7q";
    }
    {
      name = "Nix";
      publisher = "bbenoist";
      version = "1.0.1";
      sha256 = "0zd0n9f5z1f0ckzfjr38xw2zzmcxg1gjrava7yahg5cvdcw6l35b";
    }
    {
      name = "python";
      publisher = "ms-python";
      version = "2020.9.114305";
      sha256 = "1vh0wvfvzszc58lw7dbl60knpm5l6rrsghfchhn5dvwyadx4a33h";
    }
    {
      name = "rust";
      publisher = "rust-lang";
      version = "0.7.8";
      sha256 = "039ns854v1k4jb9xqknrjkj8lf62nfcpfn0716ancmjc4f0xlzb3";
    }
    {
      name = "vimL";
      publisher = "fallenwood";
      version = "0.0.3";
      sha256 = "16m19bc4zq4hkxd7b7rknslvzrajz7ihlygliab5zsnh005yspwk";
    }
    {
      name = "monokai-extended";
      publisher = "SuperPaintman";
      version = "0.5.1";
      sha256 = "1iispppb8rxsrnvc9pd1f5wm2ig2dcqa9j6jpqwarhmh5yvpnqy2";
    }
    {
      name = "docthis";
      publisher = "oouo-diogo-perdigao";
      version = "0.8.2";
      sha256 = "1v7njs8l283k0l05rn6zbm76hmk6dg2hgbkm36bdka27kxqnxacd";
    }
    {
      name = "llvm";
      publisher = "RReverser";
      version = "0.0.3";
      sha256 = "14d0iki124h1dj5v54rxk358qslpw7rpm0s2ky769nmq0km8xf6q";
    }
    {
      name = "prettier-vscode";
      publisher = "esbenp";
      version = "4.5.0";
      sha256 = "0s6bjl8ndp1dbacanphvc27dkxnrv46vwl68wrj8gq8vj86dwqmj";
    }
    {
      name = "quokka-vscode";
      publisher = "WallabyJs";
      version = "1.0.291";
      sha256 = "11dghkx8v3rx97fx2v1wlvxhihgiia6b9hgmr714z0sa267fnv2v";
    }
    {
      name = "vscode-arduino";
      publisher = "vsciot-vscode";
      version = "0.2.29";
      sha256 = "0q727mgncrcjlrag6aaa95h65sa7x7z23c8cxnjcpmkgfb2gcmin";
    }
    {
      name = "gitignore";
      publisher = "codezombiech";
      version = "0.6.0";
      sha256 = "0gnc0691pwkd9s8ldqabmpfvj0236rw7bxvkf0bvmww32kv1ia0b";
    }
    {
      name = "rest-client";
      publisher = "humao";
      version = "0.24.3";
      sha256 = "1pb30rxg5f0s20x1s8h51kblgyv6idnm50qm21sfv9n0vw00wipk";
    }
    {
      name = "partial-diff";
      publisher = "ryu1kn";
      version = "1.4.1";
      sha256 = "1r4kg4slgxncdppr4fn7i5vfhvzcg26ljia2r97n6wvwn8534vs9";
    }
    {
      name = "jinjahtml";
      publisher = "samuelcolvin";
      version = "0.15.0";
      sha256 = "18mjabpzldsaz5r1sp94kwk28chrmifcr4aql0fag6yh2kms1jas";
    }
  ]
)
