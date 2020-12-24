{ pkgs ? import <nixpkgs> { } }:

with pkgs;
with pkgs.lua52Packages;
let
  luaformatter = buildLuarocksPackage {
    pname = "luaformatter";
    version = "scm-1";

    knownRockspec = (fetchurl {
      url = "https://luarocks.org/dev/luaformatter-scm-1.rockspec";
      sha256 = "13i8qshpvgvjxj3rwj39hz3zb29szxlmshlp4ms0hrkbay47za9k";
    }).outPath;

    src = fetchgit {
      url = "git://github.com/Koihik/LuaFormatter.git";
      rev = "6dedb51179d1deb1d32855d5357ec3e51e539a80";
      sha256 = "1hji56gch1cg44qcq2kblzqzjvv1g4jdfz39m5v7v65kl3kk1jdp";
      fetchSubmodules = true;
    };

    propagatedBuildInputs = [ lua ];
  };
in
pkgs.mkShell {
  buildInputs = [ luaformatter ];
}
