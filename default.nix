{ isMacOS ? false, ... }@args:

with builtins;

let
  macOSOnly = path: if isMacOS then path else null;

  callIfFunction = f: args: if isFunction f then (f args) else f;

  pipe = functions: val: foldl' (v: f: f v) val functions;

  merge = items: foldl' (res: item: res // item) {} items;

  imports = items:
    let
      defaultAttr = name: def: v: if hasAttr name v then v."${name}" else def;

      filterModules = modules: filter (v: v != null) modules;

      convertNewFormat = v: (
        if hasAttr "file" v || hasAttr "configFile" v || hasAttr "dataFile" v
        then
          {
            file = defaultAttr "file" {} v;
            configFile = defaultAttr "configFile" {} v;
            dataFile = defaultAttr "dataFile" {} v;
          }
        else
          { file = v; configFile = {}; dataFile = {}; }
      );

      modules = pipe [
        (map import)
        (map (m: callIfFunction m args))
        (map convertNewFormat)
      ] (filterModules items);
    in
      {
        file = merge (map (m: m.file) modules);
        configFile = merge (map (m: m.configFile) modules);
        dataFile = merge (map (m: m.dataFile) modules);
      };
in
imports [
  ./alacritty
  ./ansible
  ./awesome
  ./bash
  ./bin
  ./ctags
  # ./dunst
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
  (macOSOnly ./skhd) # OSX specific.
  ./tmux
  ./vim
  ./vscode
  ./xresources
  (macOSOnly ./yabai) # OSX specific.
  ./yarn
  ./zsh
]
