{ lib
, buildGoModule
, makeWrapper
, fzf
, fd
, exa
, zoxide
, tmux
, nix-prefetch
}:

buildGoModule rec {
  name = "extras";

  src = ./.;

  subPackages = [
    "cmd/fzf-jump"
    "cmd/nix-update"
    "cmd/tmux-session-manager"
  ];

  vendorSha256 = "sha256-PD0i2QzinUAj1VkJkVyBiNy+eMoUreD4keG3rt0+ufc=";

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

    wrapProgram "$out/bin/nix-update" \
      --prefix PATH ':' ${lib.makeBinPath [
        nix-prefetch
      ]}
  '';
}
