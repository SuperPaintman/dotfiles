let
  merge = items: builtins.foldl' (res: item: res // item) {} items;
in
merge [
  (import ./ansible)
  (import ./bash)
  (import ./bin)
  (import ./ctags)
  (import ./git)
  (import ./htop)
  (import ./lein)
  (import ./neofetch)
  (import ./npm)
  (import ./prettier)
  (import ./sbt)
  (import ./tmux)
  (import ./vscode)
  (import ./yarn)
  (import ./zsh)
]
