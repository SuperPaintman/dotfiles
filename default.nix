let
  merge = items: builtins.foldl' (res: item: res // item) {} items;

  imports = items: merge (builtins.map import items);
in
imports [
  ./alacritty
  ./ansible
  ./awesome
  ./bash
  ./bin
  ./ctags
  ./git
  ./htop
  ./lein
  ./lf
  ./neofetch
  ./npm
  ./polybar
  ./prettier
  ./rofi
  ./sbt
  ./skhd # OSX specific.
  ./tmux
  ./vim
  ./vscode
  ./xresources
  ./yabai # OSX specific.
  ./yarn
  ./zsh
]
