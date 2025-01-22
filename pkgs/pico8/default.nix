# See: https://nixos.wiki/wiki/PICO-8
{ stdenv, lib, fetchurl, steam-run, runtimeShell, copyDesktopItems, makeDesktopItem }:

let 
  pico8Icon = fetchurl {
    url = "https://www.lexaloffle.com/gfx/p8b_pico8.png";
    sha256 = "sha256-yKrwe8ewBO4c2mvx8aoQDGA9HIlqbOoy6TlhZkqAx+o=";
  };

  pico8HomeDir = "$HOME/.local/share/pico8";
in

stdenv.mkDerivation {
  name = "pico8";

  nativeBuildInputs = [
    copyDesktopItems
  ];

  phases = [ "installPhase" ];

  installPhase = ''
    runHook preInstall

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

    exec "${steam-run}/bin/steam-run" "${pico8HomeDir}/pico8" "$@"
    EOF
    chmod +x "$out/bin/pico8"

    runHook postInstall
  '';

  desktopItems = [(makeDesktopItem {
    name = "pico8";
    desktopName = "PICO-8";
    keywords = [
      "Game"
      "Retro"
      "Development"
    ];
    exec = "pico8";
    terminal = false;
    type = "Application";
    icon = pico8Icon;
    # icon = "pico8";
    categories = [
      "Development"
      "IDE"
      "Game"
    ];
    startupNotify = true;
    actions = {
      "Windowed" = {
        name = "Open windowed";
        exec = "pico8 -windowed 1";
      };
    };
  })];

  meta = {
    description = "PICO-8 is a fantasy console for making, sharing and playing tiny games and other computer programs.";
    homepage = "https://www.lexaloffle.com/pico-8.php";
    license = lib.licenses.unfree;
    platforms = [ "x86_64-linux" ];
    mainProgram = "pico8";
  };
}

