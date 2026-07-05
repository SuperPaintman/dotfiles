{ lib
, buildGoModule
, makeWrapper
, fzf
, fd
, eza
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
    "cmd/rofi-modes"
    "cmd/tmux-session-manager"
  ];

  vendorHash = "sha256-PD0i2QzinUAj1VkJkVyBiNy+eMoUreD4keG3rt0+ufc=";

  nativeBuildInputs = [
    makeWrapper
  ];

  postInstall = ''
    wrapProgram "$out/bin/fzf-jump" \
      --prefix PATH ':' ${lib.makeBinPath [
        fzf
        fd
        eza
        zoxide
        tmux
      ]}

    wrapProgram "$out/bin/nix-update" \
      --prefix PATH ':' ${lib.makeBinPath [
        nix-prefetch
      ]}

    wrapProgram "$out/bin/tmux-session-manager" \
      --prefix PATH ':' ${lib.makeBinPath [
        fzf
        fd
        zoxide
        tmux
      ]}
  '';
}
