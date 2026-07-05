# See: https://github.com/ohmyzsh/ohmyzsh/blob/70ad5e3df8f7bed68aa6672029496926e632aedd/plugins/golang/_golang

{ lib, stdenvNoCC, installShellFiles, fetchurl }:

stdenvNoCC.mkDerivation rec {
  pname = "go-zsh-completions";
  version = "70ad5e3df8f7bed68aa6672029496926e632aedd";

  src = fetchurl {
    url = "https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/${version}/plugins/golang/_golang";
    hash = "sha256-+dGd9TlXFjTflR9mqykMzFV6Tp6cqKTzWBqOlNLQM8s=";
  };

  strictDeps = true;

  # dontUnpack = true;
  dontConfigure = true;
  dontBuild = true;

  nativeBuildInputs = [ installShellFiles ];

  unpackPhase = ''
    runHook preUnpack

    cp "$src" _golang

    runHook postUnpack
  '';

  installPhase = ''
    runHook preInstall

    installShellCompletion --cmd golang --zsh _golang

    runHook postInstall
  '';

  meta = {
    homepage = "https://github.com/ohmyzsh/ohmyzsh";
    license = lib.licenses.mit;
    platforms = lib.platforms.all;
  };
}
