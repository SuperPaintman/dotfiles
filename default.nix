{ isLinux ? false, isMacOS ? false }@args:

with builtins;
let
  callIfFunction = f: args: if isFunction f then (f args) else f;
  linuxOnly = path: if isLinux then path else null;
  macOSOnly = path: if isMacOS then path else null;
  existsOnly = path: if pathExists path then path else null;

  merge = items: foldl' (res: item: res // item) { } items;

  imports = items: merge (map
    (item: callIfFunction (import item) args)
    (filter (item: item != null) items)
  );
in
imports [
  ./alacritty
  ./ansible
  (linuxOnly ./awesome)
  ./bash
  ./bin
  ./cargo
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
  (existsOnly ./secrets)
]
