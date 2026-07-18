{ lib, stdenvNoCC, installShellFiles, zsh }:

stdenvNoCC.mkDerivation rec {
  name = "zig-zsh-completions";

  src = ./_zig;

  dontConfigure = true;
  dontBuild = true;
  doCheck = true;
  dontFixup = true;

  nativeBuildInputs = [ installShellFiles ];

  unpackPhase = ''
    runHook preUnpack

    cp -r "$src" ./_zig

    runHook postUnpack
  '';

  checkPhase = ''
    runHook preCheck

    ${zsh}/bin/zsh -n _zig

    runHook postCheck
  '';

  installPhase = ''
    runHook preInstall

    installShellCompletion --cmd zig --zsh _zig

    runHook postInstall
  '';
}
