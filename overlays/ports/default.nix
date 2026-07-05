{ final, prev }:

let
  libx = (import ../../lib { pkgs = final; }).x;
in

let
  inherit (prev) callPackage lib;
  inherit (builtins) compareVersions hasAttr;
  inherit (lib) any filter concatStringsSep;

  log = libx.logger.makeLogger { domain = "overlays.ports"; trace = false; };

  sources = import ./sources.nix { inherit (prev) fetchgit; };

  port = name: pkg:
    if !(hasAttr name prev) then
      log.trace "${name}: not in prev, using overlay ${pkg.version}"
      pkg
    else if compareVersions prev.${name}.version pkg.version >= 0 then
      log.warn "${name}: prev ${prev.${name}.version} >= overlay ${pkg.version}, overlay is redundant"
      prev.${name}
    else
      log.trace "${name}: prev ${prev.${name}.version} < overlay ${pkg.version}, upgrading"
      pkg;

  pin = name: pkg:
    log.trace "${name}: pinned to ${pkg.version}"
    pkg;

  ifDepsChanged = deps: name: pkg:
    let
      changed = n:
        !(hasAttr n prev)
        || final.${n}.version != prev.${n}.version;
    in
    if any changed deps then
      log.trace "${name}: deps changed [${concatStringsSep ", " (filter changed deps)}], upgrading"
      pkg
    else if hasAttr name prev then
      log.trace "${name}: deps unchanged, keeping"
      prev.${name}
    else
      log.trace "${name}: deps unchanged but not in prev, using overlay"
      pkg;
in 

rec {
  lua-language-server = port "lua-language-server"
    (callPackage "${sources.lua-language-server}/pkgs/by-name/lu/lua-language-server/package.nix" { });

  go_latest = port "go_latest"
    go_1_26;
  buildGoLatestModule = ifDepsChanged [ "go_latest" ] "buildGoLatestModule"
    buildGo126Module;

  go_1_25 = port "go_1_25"
    (callPackage "${sources.go}/pkgs/development/compilers/go/1.25.nix" {
      inherit buildGo125Module;
    });
  buildGo125Module = ifDepsChanged [ "go_1_25" ] "buildGo125Module"
    (callPackage "${sources.go}/pkgs/build-support/go/module.nix" {
      go = go_1_25;
    });

  go_1_26 = port "go_1_26"
    (callPackage "${sources.go}/pkgs/development/compilers/go/1.26.nix" {
      inherit buildGo126Module;
    });
  buildGo126Module = ifDepsChanged [ "go_1_26" ] "buildGo126Module"
    (callPackage "${sources.go}/pkgs/build-support/go/module.nix" {
      go = go_1_26;
    });

  gopls = port "gopls"
    (callPackage "${sources.gopls}/pkgs/by-name/go/gopls/package.nix" {
      inherit buildGoLatestModule;
    });
}
