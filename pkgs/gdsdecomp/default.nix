# See: https://github.com/bruvzg/gdsdecomp

{ stdenv
, fetchurl
, runtimeShell
, unzip
, autoPatchelfHook
, steam-run
}:

stdenv.mkDerivation rec {
  name = "gdsdecomp";
  version = "0.5.3";

  src = fetchurl {
    url = "https://github.com/bruvzg/gdsdecomp/releases/download/v${version}/GDRE_tools-v${version}-linux.zip";
    hash = "sha256-ayp5gPOaPsxwyqRx07azk7OBy9/RsShbFEfjU45NlmY=";
  };

  nativeBuildInputs = [
    autoPatchelfHook
  ];

  unpackPhase = ''
    ${unzip}/bin/unzip $src
  '';

  installPhase = ''
    mkdir -p $out/{bin,opt/gdre_tools}

    cp gdre_tools.pck gdre_tools.x86_64 $out/opt/gdre_tools
    chmod +x $out/opt/gdre_tools/gdre_tools.x86_64

    # Create a bin file.
    cat <<-EOF > "$out/bin/gdre_tools"
    #!${runtimeShell} -e
    exec ${steam-run}/bin/steam-run "$out/opt/gdre_tools/gdre_tools.x86_64" "\$@"
    EOF
    chmod +x "$out/bin/gdre_tools"
  '';
}
