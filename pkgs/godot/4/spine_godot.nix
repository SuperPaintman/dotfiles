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
    rev = "b83ee23be8c0de65c66c3c1ff2ea50b6d0efbee2";
    hash = "sha256-e7+FUVi+soTer8uhF32bGXmar69VTrejyQt0HqLwgN4=";
  };

  phases = [ "unpackPhase" "installPhase" ];

  installPhase = ''
    mkdir -p "$out"
    cp -r "spine-godot/spine_godot/"* "$out"
    cp -r "spine-cpp/spine-cpp/" "$out/spine-cpp"
  '';
}
