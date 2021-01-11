{ isLinux ? false, isMacOS ? false }:

with builtins;
let
  linuxOnly = path: if isLinux then path else null;
  macOSOnly = path: if isMacOS then path else null;

  merge = items: foldl' (res: item: res // item) { } items;

  imports = items: merge (map import (filter (item: item != null) items));
in
imports [
  ./alacritty
  ./ansible
  (linuxOnly ./awesome)
  ./bash
  ./bin
  ./ctags
  ./doom
  ./git
  (linuxOnly ./gtk)
  ./htop
  ./lein
  ./lf
  ./neofetch
  ./npm
  ./polybar
  ./prettier
  (linuxOnly ./rofi)
  ./sbt
  (macOSOnly ./skhd) # OSX specific.
  ./tmux
  ./vim
  ./vscode
  (linuxOnly ./xdg)
  (linuxOnly ./xresources)
  (macOSOnly ./yabai) # OSX specific.
  ./yarn
  ./zsh
]
