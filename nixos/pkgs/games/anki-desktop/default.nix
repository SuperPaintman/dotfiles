{ anki-bin ? null, stdenv, lib, makeDesktopItem }:

makeDesktopItem {
  name = "anki";
  exec = "${anki-bin}/bin/anki %f";
  desktopName = "Anki";
  comment = "An intelligent spaced-repetition memory training program";
  genericName = "Flashcards";
  # http://www.myiconfinder.com/icon/anki-flashcard-program-japanese/10959
  icon = ./icon.png;
  terminal = "false";
  categories = lib.concatStringsSep ";" [
    "Education"
  ];
  mimeType = lib.concatStringsSep ";" [
    "application/x-apkg"
    "application/x-anki"
  ];
}
