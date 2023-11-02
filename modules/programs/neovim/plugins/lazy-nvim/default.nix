{ lib, stdenv, fetchFromGitHub, neovim }:

with lib;

stdenv.mkDerivation rec {
  pname = "lazy.nvim";
  version = "9.25.1";

  src = fetchFromGitHub {
    owner = "folke";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-83vaoW2D9Sfidip9JlCr7/+oAMn6m9dH/Jv0AIT1yrw=";
  };

  patches = [
    ./0001-no-helptags-update.patch
    ./0002-no-git-and-fs-manipulations.patch
  ];

  buildPhase = ''
    ${neovim}/bin/nvim \
      --clean \
      --cmd ":helptags $PWD/doc | quit | quit" > /dev/null
  '';

  installPhase = ''
    mkdir -p "$out"

    cp -r {README.md,lua,doc} "$out"
  '';

  dontFixup = true; # Don't move the doc dir.
}

