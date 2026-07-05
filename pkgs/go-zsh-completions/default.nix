# See: https://github.com/zsh-users/zsh-completions/blob/0.36.0/src/_golang
# See: https://github.com/ohmyzsh/ohmyzsh/blob/70ad5e3df8f7bed68aa6672029496926e632aedd/plugins/golang/_golang

{ lib, stdenvNoCC, installShellFiles, fetchurl }:

stdenvNoCC.mkDerivation rec {
  pname = "go-zsh-completions";
  version = "0.36.0";

  src = fetchurl {
    url = "https://raw.githubusercontent.com/zsh-users/zsh-completions/refs/tags/${version}/src/_golang";
    hash = "sha256-k1uQHgEcLZNALXy0CPOOCmCj0p01aHqZd9ZpOj7EVuY=";
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
    homepage = "https://github.com/zsh-users/zsh-completions";
    license = with lib.licenses; [
      asl20
      bsd3
      isc
      mit
      mit-modern
    ];
    platforms = lib.platforms.unix;
  };
}
