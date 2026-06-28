{ final, prev }:

let
  pkgs = final;

  inherit (pkgs) callPackage stdenv lib;
  inherit (lib) assertMsg trace traceVal traceValFn id isString;
  inherit (builtins) typeOf hasAttr;

  debug = if false then trace else msg: id;

  # Overlay package only if the current version is older.
  ifNewerFn = name: overlay: fn:
    let
      overlayVersion = overlay.version;
    in
    if !(hasAttr name prev) then
      debug "[overlays.ports]: current version of '${name}' does not exist: null >= ${overlayVersion}" (fn false overlay)
    else
      let
        current = prev.${name};
        currentVersion = current.version;

        newer = builtins.compareVersions currentVersion overlayVersion >= 0;
        msg = "[overlays.ports]: current version of '${name}' is ${if newer then "newer" else "older"}: ${currentVersion} >= ${overlayVersion}"
          + (if newer then ": probably delete the overlay?" else "");
      in
      assert assertMsg (isString currentVersion)
        "[overlays.ports]: current.version must be a string string, got ${typeOf currentVersion}";
      assert assertMsg (isString overlayVersion)
        "[overlays.ports]: overlay.version must be a string string, got ${typeOf overlayVersion}";
      if newer then
        trace msg (fn true current)
      else
        debug msg (fn false overlay);

  ifNewer = name: overlay: ifNewerFn name overlay (_: id);
in

rec {
  lua-language-server = ifNewer "lua-language-server" (callPackage ./nixpkgs/lua-language-server { });

  go_latest = ifNewer "go_latest" go_1_25;
  buildGoLatestModule = ifNewerFn "go_latest" go_latest (newer: go: if newer then prev.buildGoLatestModule else callPackage ./nixpkgs/go-modules/generic {
    inherit go;
  });

  go_1_25 = ifNewer "go_1_25" (callPackage ./nixpkgs/go/1.25.nix {
    inherit buildGo125Module;
  });
  buildGo125Module = ifNewerFn "go_1_25" go_1_25 (newer: go: if newer then prev.buildGo125Module else callPackage ./nixpkgs/go-modules/generic {
    inherit go;
  });

  gopls = ifNewer "gopls" (callPackage ./nixpkgs/gopls {
    inherit buildGoLatestModule;
  });
}
