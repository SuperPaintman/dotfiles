final: prev:

let
  inherit (prev) lib;

  overlayFiles = lib.pipe ./secrets [
    builtins.readDir
    lib.attrNames
    (lib.filter (n: n != "default.nix" && lib.hasSuffix ".nix" n))
    (lib.map (n: import "${./secrets}/${n}"))
  ];
in

lib.composeManyExtensions overlayFiles final prev
