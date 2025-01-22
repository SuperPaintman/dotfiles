# See: https://nixos.wiki/wiki/PICO-8
{ stdenv, buildFHSUserEnv, runtimeShell }:

let 
  fhs = buildFHSUserEnv {
    name = "pico8-fhs";
    targetPkgs = pkgs: (with pkgs; [
      xorg.libX11
      xorg.libXext
      xorg.libXcursor
      xorg.libXinerama
      xorg.libXi
      xorg.libXrandr
      xorg.libXScrnSaver
      xorg.libXxf86vm
      xorg.libxcb
      xorg.libXrender
      xorg.libXfixes
      xorg.libXau
      xorg.libXdmcp
      alsa-lib
      udev
      wget
    ]);
    runScript = "bash -c 'exec $@' $@";
  };

  pico8HomeDir = "$HOME/.local/share/pico8";
in

stdenv.mkDerivation {
  name = "pico8";

  phases = [ "installPhase" ];

  installPhase = ''
    mkdir -p "$out/bin"

    cat <<'EOF' > "$out/bin/pico8"
    #!${runtimeShell} -e

    if [ ! -f "${pico8HomeDir}/pico8" ]; then
      {
        echo 'Cannot find pico8 executable!'
        echo ""
        echo "You probably haven't installed it yet."
        echo ""
        echo "Download your pico8 release from the following page:"
        echo ""
        echo '    https://www.lexaloffle.com/account.php?page=activate'
        echo ""
        echo 'And then extract it into ${pico8HomeDir}'
        echo ""
        echo '    $ mkdir -p /tmp/pico8'
        echo '    $ unzip /path/to/your/pico8.zip -d "/tmp/pico8"'
        echo '    $ mkdir -p "${pico8HomeDir}"'
        echo '    $ mv /tmp/pico8/pico-8/* "${pico8HomeDir}"'
        echo ""
      } > /dev/stderr
      exit 1
    fi

    exec "${fhs}/bin/pico8-fhs" "${pico8HomeDir}/pico8" "$@"
    EOF
    chmod +x "$out/bin/pico8"
  '';
}

