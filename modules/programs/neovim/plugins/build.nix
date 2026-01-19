{ stdenv, lib, ... }:

{ pname
, version
, src
, plugin
, branch ? null
, commit ? null
, installPhase ? null
, patches ? [ ]
, passthru ? { }
}:

let
  mkOverride = self: f:
    let
      newSelf = self // (if lib.isAttrs f then f else f self);
    in
    newSelf // { override = mkOverride newSelf; };

  self = stdenv.mkDerivation {
    inherit pname version src patches;

    installPhase = ''
      mkdir -p "$out"
      for d in after autoload colors doc ftplugin lua plugin queries syntax types; do
        if [ -d "$d" ]; then
          cp -r "$d" "$out/$d"
        fi
      done
    '' + lib.optionalString (installPhase != null) installPhase;

    dontBuild = true;
    dontFixup = true; # Don't move the doc dir.

    passthru =
      let
        passthruSelf = {
          lazy = {
            inherit plugin;
            dir = self;
          }
          // lib.optionalAttrs (branch != null) { inherit branch; }
          // lib.optionalAttrs (commit != null) { inherit commit; }
          // passthru.lazy or { }
          // {
            override = mkOverride passthruSelf.lazy;
          };
        }
        // passthru;
      in
      passthruSelf;
  };
in
self
