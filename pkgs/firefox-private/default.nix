{ stdenvNoCC, firefox, makeDesktopItem, copyDesktopItems }:

stdenvNoCC.mkDerivation rec {
  pname = "firefox-private";
  inherit (firefox) version;

  strictDeps = true;

  dontUnpack = true;
  dontConfigure = true;
  # dontBuild = true;
  # dontInstall = true;

  nativeBuildInputs = [ copyDesktopItems ];

  desktopItems = [
    (makeDesktopItem {
      name = "firefox-private";
      exec = "${firefox}/bin/firefox --private-window %U";
      desktopName = "Firefox (Private)";
      genericName = "Web Browser";
      icon = "firefox";
      terminal = false;
      categories = [
        "Network"
        "WebBrowser"
      ];
      mimeTypes = [
        "text/html"
        "text/xml"
        "application/xhtml+xml"
        "application/vnd.mozilla.xul+xml"
        "x-scheme-handler/http"
        "x-scheme-handler/https"
        "x-scheme-handler/ftp"
      ];
    })
  ];

  passthru.firefox = firefox;
  inherit (firefox) meta;
}
