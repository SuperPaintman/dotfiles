# This file is generated; DO NOT EDIT.

# See: https://nixos.wiki/wiki/Vscode
{ pkgs, ... }:

(
  with pkgs; with pkgs.vscode-extensions; [
    ms-vscode.cpptools
    local.vscode-extensions.sumneko.lua
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
      version = "3.41.20220516";
      sha256 = "0mkz4a0gk4wvywkxlr5srxh60mqvdgy06ap7qam0kbzdg716cyya";
    }
    {
      name = "Go";
      publisher = "golang";
      version = "0.33.0";
      sha256 = "1wd9zg4jnn7y75pjqhrxm4g89i15gff69hsxy7y5i6njid0x3x0w";
    }
    {
      name = "language-haskell";
      publisher = "justusadam";
      version = "3.6.0";
      sha256 = "115y86w6n2bi33g1xh6ipz92jz5797d3d00mr4k8dv5fz76d35dd";
    }
    {
      name = "vscode-ghc-simple";
      publisher = "dramforever";
      version = "0.2.3";
      sha256 = "1pd7p4xdvcgmp8m9aymw0ymja1qxvds7ikgm4jil7ffnzl17n6kp";
    }
    {
      name = "brittany";
      publisher = "MaxGabriel";
      version = "0.0.9";
      sha256 = "1cfbzc8fmvfsxyfwr11vnszvirl47zzjbjp6rihg5518gf5wd36k";
    }
    {
      name = "nix-ide";
      publisher = "jnoortheen";
      version = "0.1.20";
      sha256 = "16mmivdssjky11gmih7zp99d41m09r0ii43n17d4i6xwivagi9a3";
    }
    {
      name = "python";
      publisher = "ms-python";
      version = "2022.7.11371008";
      sha256 = "0w88gc73akgq5890sz0xzgmwxyps6vfxnghfz4kprwx3si199sdf";
    }
    {
      name = "rust-analyzer";
      publisher = "rust-lang";
      version = "0.3.1057";
      sha256 = "0piz5dgihg1plwfaq5ybi71hq1hfva9dq8s1kj35hkffl7k0jjsh";
    }
    {
      name = "stylus";
      publisher = "alan";
      version = "0.0.4";
      sha256 = "0rlzkc6g9g44526ln5gmb4xsrn64rnmz4ddkiarpr4sf26dndpjq";
    }
    {
      name = "svelte-vscode";
      publisher = "svelte";
      version = "105.16.1";
      sha256 = "1ridb70vdhirsqfrp2cvmlijkcb997gzakq1nr5xxbcih09r60y0";
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
      name = "vscode-theme-onelight";
      publisher = "akamud";
      version = "2.2.3";
      sha256 = "1mzd77sv6lb6kfv5fvdvzggs488q553cf752byrml981ys9r7khz";
    }
    {
      name = "vscode-theme-onedark";
      publisher = "akamud";
      version = "2.2.3";
      sha256 = "1m6f6p7x8vshhb03ml7sra3v01a7i2p3064mvza800af7cyj3w5m";
    }
    {
      name = "even-better-toml";
      publisher = "tamasfe";
      version = "0.14.2";
      sha256 = "17djwa2bnjfga21nvyz8wwmgnjllr4a7nvrsqvzm02hzlpwaskcl";
    }
    {
      name = "terraform";
      publisher = "HashiCorp";
      version = "2.10.2";
      sha256 = "0fkkjkybjshgzbkc933jscxyxqwmqnhq3718pnw9hsac8qv0grrz";
    }
    {
      name = "vscode-nginx";
      publisher = "william-voyek";
      version = "0.7.2";
      sha256 = "0s4akrhdmrf8qwn6vp8kc31k5hx2k2wml5mcashfc09hxiqsf2cq";
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
      version = "0.1.1";
      sha256 = "0r58hfzxvgmr1xsirkyq2ffdmk3nmwj406d08aiqipr3i7kkrxih";
    }
    {
      name = "prettier-vscode";
      publisher = "esbenp";
      version = "9.5.0";
      sha256 = "0h5g746ij36h22v1y2883bqaphds7h1ck8mg8bywn9r723mxdy1g";
    }
    {
      name = "quokka-vscode";
      publisher = "WallabyJs";
      version = "1.0.472";
      sha256 = "1zl44ibimi3sd966xlphs2s9h48idasmw06p63i5mvnscpj3jfc4";
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
      version = "0.7.0";
      sha256 = "0fm4sxx1cb679vn4v85dw8dfp5x0p74m9p2b56gqkvdap0f2q351";
    }
    {
      name = "rest-client";
      publisher = "humao";
      version = "0.24.6";
      sha256 = "196pm7gv0488bpv1lklh8hpwmdqc4yimz389gad6nsna368m4m43";
    }
    {
      name = "partial-diff";
      publisher = "ryu1kn";
      version = "1.4.3";
      sha256 = "0x3lkvna4dagr7s99yykji3x517cxk5kp7ydmqa6jb4bzzsv1s6h";
    }
    {
      name = "jinjahtml";
      publisher = "samuelcolvin";
      version = "0.17.0";
      sha256 = "120z8barzgva0sr1g7xj4arpjz96v4zxh2zgk56jzdgnafzyq71b";
    }
    {
      name = "vscode-neovim";
      publisher = "asvetliakov";
      version = "0.0.84";
      sha256 = "042z6qi5y6n8znnf23w1r0rn1i8pc8s253vc3jh3i8nqfjkx02x5";
    }
  ]
)
