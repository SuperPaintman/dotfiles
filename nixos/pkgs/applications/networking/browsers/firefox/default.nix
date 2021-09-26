{ firefox, lib, makeDesktopItem }:

makeDesktopItem {
  name = "firefox-private";
  exec = "${firefox}/bin/firefox --private-window %U";
  desktopName = "Firefox (Private)";
  genericName = "Web Browser";
  icon = "firefox";
  terminal = "false";
  categories = lib.concatStringsSep ";" [
    "Network"
    "WebBrowser"
  ];
  mimeType = lib.concatStringsSep ";" [
    "text/html"
    "text/xml"
    "application/xhtml+xml"
    "application/vnd.mozilla.xul+xml"
    "x-scheme-handler/http"
    "x-scheme-handler/https"
    "x-scheme-handler/ftp"
  ];
}
