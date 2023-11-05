# http://en.esotericsoftware.com/spine-godot

{ stdenv
, fetchFromGitHub
}:

stdenv.mkDerivation rec {
  pname = "spine_godot";
  version = "4.1";

  src = fetchFromGitHub {
    owner = "EsotericSoftware";
    repo = "spine-runtimes";
    rev = "d12431d72cb49f322d8c4812fe17377df2bde1b0";
    hash = "sha256-si7ZxBUosOrqQ3hNaj/kABc4MIr3ZCqT/dhG5uCcpdU=";
  };

  phases = [ "unpackPhase" "installPhase" ];

  installPhase = ''
    mkdir -p "$out"
    cp -r "spine-godot/spine_godot/"* "$out"
    cp -r "spine-cpp/spine-cpp/" "$out/spine-cpp"
  '';
}
