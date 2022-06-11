{ isLinux ? false, isMacOS ? false }@args:

with builtins;
let
  callIfFunction = f: args: if isFunction f then (f args) else f;
  merge = items: foldl' (res: item: res // item) { } items;

  linuxOnly = path: if isLinux then path else null;
  macOSOnly = path: if isMacOS then path else null;
  optional = path: if pathExists path then path else null;

  imports = items: merge (map
    (item: callIfFunction (import item) { inherit linuxOnly macOSOnly optional; })
    (filter (item: item != null) items)
  );
in
imports ([
  ./alacritty
  ./ansible
  ./awesome
  ./bash
  ./bin
  ./cargo
  ./ctags
  ./discord
  ./doom
  ./git
  ./gtk
  ./htop
  ./lein
  ./lf
  ./neofetch
  ./nixpkgs
  ./npm
  ./nvim
  ./polybar
  ./prettier
  ./rofi
  ./sbt
  ./skhd
  ./tmux
  ./vim
  ./vscode
  ./xdg
  ./xmodmap
  ./xresources
  ./yabai
  ./yarn
  ./zsh
] ++ (
  if pathExists ./secrets
  then import ./secrets (args // { inherit linuxOnly macOSOnly optional; })
  else [ ]
))
