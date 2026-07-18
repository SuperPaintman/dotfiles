{ final, prev }:

let
  libx = (import ../../lib { pkgs = final; }).x;
in

let
  inherit (prev) callPackage lib;
  inherit (builtins) compareVersions hasAttr;
  inherit (lib) any filter concatStringsSep isString isList hasAttrByPath getAttrFromPath;

  log = libx.logger.makeLogger { domain = "overlays.ports"; trace = false; };

  sources = import ./sources.nix { inherit (prev) fetchgit; };

  fetchFromCodeberg = lib.makeOverridable (args: prev.fetchFromGitea ({
    domain = "codeberg.org";
    # functionName = "fetchFromCodeberg";
  } // args));

  port = name: pkg: let
      name' = if isList name then concatStringsSep name "." else name;
      attrPath = if isList name then name else [ name ];
      getPkg = getAttrFromPath attrPath;
      prevPkg = getPkg prev;
    in
    if !(hasAttrByPath attrPath prev) then
      log.trace "${name'}: not in prev, using overlay ${pkg.version}"
      pkg
    else if compareVersions prevPkg.version pkg.version >= 0 then
      log.warn "${name'}: prev ${prevPkg.version} >= overlay ${pkg.version}, overlay is redundant"
      prevPkg
    else
      log.trace "${name'}: prev ${prevPkg.version} < overlay ${pkg.version}, upgrading"
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

  zigPackages = prev.zigPackages // (let 
    zigPackages = lib.recurseIntoAttrs (callPackage "${sources.zig}/pkgs/development/compilers/zig" (let 
      scope = {
        inherit callPackage fetchFromCodeberg;
      };

      callPackage = prev.newScope scope;
    in {
      inherit callPackage;
    }));
  in {
    # "0.14" = port [ "zigPackages" "0.14" ]
    #   zigPackages."0.14";

    # "0.15" = port [ "zigPackages" "0.15" ]
    #   zigPackages."0.15";

    "0.16" = port [ "zigPackages" "0.16" ]
      zigPackages."0.16";
  });

  # zig = port "zig"
  #   zig_latest;

  zig_latest = port "zig_latest"
    zig_0_16;

  # zig_0_14 = port "zig_0_14"
  #   zigPackages."0.14";

  # zig_0_15 = port "zig_0_15"
  #   zigPackages."0.15";

  zig_0_16 = port "zig_0_16"
    zigPackages."0.16";

  zls = port "zls"
    zls_0_16;

  # zls_0_14 = port "zls_0_14"
  #   (callPackage "${sources.zsl}/pkgs/development/tools/zls" {
  #     inherit zig_0_14;
  #     zig_0_15 = null;
  #     zig_0_16 = null;
  #   }).zls_0_14;

  # zls_0_15 = port "zls_0_15"
  #   (callPackage "${sources.zsl}/pkgs/development/tools/zls" {
  #     zig_0_14 = null;
  #     inherit zig_0_15;
  #     zig_0_16 = null;
  #   }).zls_0_15;

  zls_0_16 = port "zls_0_16"
    (callPackage "${sources.zls}/pkgs/development/tools/zls" {
      zig_0_14 = null;
      zig_0_15 = null;
      inherit zig_0_16;
    }).zls_0_16;
}
