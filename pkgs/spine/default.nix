# See: https://esotericsoftware.com/spine-license/...

{ stdenv
, fetchurl
, runtimeShell
, steam-run
}:

let
  secret = import ./secret.nix;
in

stdenv.mkDerivation rec {
  name = "spine";

  src = fetchurl {
    url = "https://eu.esotericsoftware.com/launcher/linux/${secret.license}";
    inherit (secret) sha256;
  };

  unpackPhase = ''
    tar -xf "$src" --strip 1
  '';

  installPhase = ''
    mkdir -p $out/{bin,spine}
    
    # Install spine files.
    cp -r license.rtf Spine.sh launcher "$out/spine"

    # Create a bin file.
    cat <<-EOF > "$out/bin/spine"
    #!${runtimeShell}
    exec ${steam-run}/bin/steam-run "$out/spine/Spine.sh"
    EOF
    chmod +x "$out/bin/spine"
  '';

  dontPatchShebangs = true;
  dontStrip = true;
  dontPatchELF = true;
  dontAutoPatchelf = true;
}
