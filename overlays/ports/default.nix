{ final, prev }:

let
  pkgs = final;

  inherit (pkgs) callPackage lib;
  inherit (lib) trace id;

  debug =
    if false
    then trace
    else msg: id;

  # Overlay package only if the current version is older.
  ifNewer = name: path: overrides:
    let
      current = prev.${name};
      package = callPackage path overrides;

      newer = builtins.compareVersions current.version package.version >= 0;

      msg = "current version of ${name} is ${if newer then "newer" else "older"}: ${current.version} >= ${package.version}";
    in
    if newer
    then
      trace "warning: ${msg}: probably delete the overlay?" current
    else 
      debug msg package;
in

{
  lua-language-server = ifNewer "lua-language-server" ./nixpkgs/lua-language-server { };
}
