{ stdenv
, fetchurl
, unzip
, autoPatchelfHook
, dbus
, SDL2
, freetype
}:

stdenv.mkDerivation rec {
  name = "inochi-creator";
  version = "0.8.2";

  src = fetchurl {
    url = "https://github.com/Inochi2D/inochi-creator/releases/download/v${version}/inochi-creator-linux-x86_64.zip";
    hash = "sha256-4+DAjIWW7QM95EJtfLR3ZqAT6KvLeFfcwtswg5Kt3x4=";
  };

  nativeBuildInputs = [
    autoPatchelfHook
  ];

  buildInputs = [
    dbus
    SDL2
    freetype
  ];

  unpackPhase = ''
    ${unzip}/bin/unzip $src
  '';

  installPhase = ''
    mkdir -p $out/bin

    cp -r inochi-creator $out/bin/inochi-creator
  '';
}
