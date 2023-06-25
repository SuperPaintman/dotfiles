{ lib
, buildGoModule
, makeWrapper
, fzf
, fd
, exa
, zoxide
, tmux
}:

buildGoModule rec {
  name = "extras";

  src = ./.;

  subPackages = [
    "cmd/fzf-jump"
    "cmd/tmux-session-manager"
  ];

  vendorSha256 = "sha256-YoufxUbr3hNfivIjbI1OJdszTyP0gxCfcS6uiGZmnb4=";

  nativeBuildInputs = [
    makeWrapper
  ];

  postInstall = ''
    wrapProgram "$out/bin/fzf-jump" \
      --prefix PATH ':' ${lib.makeBinPath [
        fzf
        fd
        exa
        zoxide
        tmux
      ]}
  '';
}
