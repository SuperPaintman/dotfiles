{ isMacOS ? false }:

with builtins;
let
  macOSOnly = path: if isMacOS then path else null;

  merge = items: foldl' (res: item: res // item) { } items;

  imports = items: merge (map import (filter (item: item != null) items));
in
imports [
  ./alacritty
  ./ansible
  ./awesome
  ./bash
  ./bin
  ./ctags
  ./doom
  ./git
  ./gtk
  ./htop
  ./lein
  ./lf
  ./neofetch
  ./npm
  ./polybar
  ./prettier
  ./rofi
  ./sbt
  (macOSOnly ./skhd) # OSX specific.
  ./tmux
  ./vim
  ./vscode
  ./xdg
  ./xresources
  (macOSOnly ./yabai) # OSX specific.
  ./yarn
  ./zsh
]
