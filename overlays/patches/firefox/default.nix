# A private window launcher for Firefox.
{ firefox, symlinkJoin, makeDesktopItem }:

let
  unwrapped = firefox;
in

symlinkJoin {
  pname = "${unwrapped.pname}-with-private";
  inherit (unwrapped) version;

  paths = [ 
    unwrapped
    (makeDesktopItem {
      name = "firefox-private";
      exec = "${unwrapped}/bin/firefox --private-window %U";
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

  passthru.unwrapped = unwrapped;
  inherit (unwrapped) meta;
}
