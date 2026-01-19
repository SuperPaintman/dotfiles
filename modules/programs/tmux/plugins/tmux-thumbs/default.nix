{ lib, rustPlatform, fetchFromGitHub, makeWrapper, tmux, ... }:

rustPlatform.buildRustPackage rec {
  pname = "tmux-thumbs";
  version = "0.8.0";

  src = fetchFromGitHub {
    owner = "fcsonline";
    repo = pname;
    rev = version;
    sha256 = "sha256-XMz1ZOTz2q1Dt4QdxG83re9PIsgvxTTkytESkgKxhGM=";
  };

  cargoHash = "sha256-xvfjWS1QZWrlwytFyWVtjOyB3EPT9leodVLt72yyM4E=";

  nativeBuildInputs = [
    makeWrapper
  ];

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

    for bin in $out/bin/*; do
      wrapProgram "$bin" \
        --prefix PATH ':' ${lib.makeBinPath [
          tmux
        ]}
    done
  '';


  meta = with lib; {
    description = "Copy pasting in terminal with vimium/vimperator like hints";
    homepage = "https://github.com/Morantron/tmux-fingers";
    license = with licenses; [ mit ];
  };
}
