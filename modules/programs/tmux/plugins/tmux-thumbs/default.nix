{ lib, rustPlatform, fetchFromGitHub, ... }:

rustPlatform.buildRustPackage rec {
  pname = "tmux-thumbs";
  version = "0.8.0";

  src = fetchFromGitHub {
    owner = "fcsonline";
    repo = pname;
    rev = version;
    sha256 = "sha256-XMz1ZOTz2q1Dt4QdxG83re9PIsgvxTTkytESkgKxhGM=";
  };

  cargoSha256 = "sha256-XqAX42HOTIDJk+6fWmpsGifIei9O+BfRdu9dvkMU/II=";

  patches = [
    ./0001-tmux-thumbs-dir.patch
  ];

  postPatch = ''
    for script in "tmux-thumbs.sh" "tmux-thumbs.tmux"; do
      patchShebangs "$script"
      substituteInPlace "$script" \
        --replace "@out@" "$out" \
        --replace "@version@" "$version"
    done
  '';

  postInstall = ''
    install -D "tmux-thumbs.sh" "$out/bin/tmux-thumbs.sh"
    install -D "tmux-thumbs.tmux" "$out/bin/tmux-thumbs.tmux"
  '';


  meta = with lib; {
    description = "Copy pasting in terminal with vimium/vimperator like hints";
    homepage = "https://github.com/Morantron/tmux-fingers";
    license = with licenses; [ mit ];
  };
}
