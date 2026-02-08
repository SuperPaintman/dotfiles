{ lib, pkgs, ... }:

with lib;

rec {
  /* */
  mkWrapper' = prefix: package: args: postBuild: let
    prefix' = "${optionalString (prefix != "") "-"}${prefix}";
    name =
      if hasAttr "pname" package && hasAttr "version" package then
        "${package.pname}${prefix'}-wrapped-${package.version}"
      else
        "${package.name}${prefix'}-wrapped";
    paths = [ package ];
  in pkgs.symlinkJoin (args // {
    inherit name paths postBuild;
    buildInputs = [ pkgs.makeWrapper ] ++ (args.buildInputs or []);
  });

  /* */
  mkWrapper = mkWrapper' "";

  /* */
  mkAllFakeHomeWrapper' = fakeHome: package: mkWrapper' "fake-home" package { } ''
    for bin in "$out/bin/"* ; do
      if [ -f "$bin" ]; then
        wrapProgram "$bin" \
          --run 'export HOME="''${XDG_FAKE_HOME:-$HOME}"'
      fi
    done
  '';

  /* */
  mkAllFakeHomeWrapper = mkAllFakeHomeWrapper' "\${XDG_FAKE_HOME:-$HOME}";
}
