{ pkgs ? import <nixpkgs> { } }:

let
  inherit (pkgs) lib;
in

with lib;

let
  nixpkgsVersion = pipe lib.version [
    (splitString ".")
    (take 2)
    (concatStringsSep ".")
  ];

  toGithubUrl = owner: repo: branch: path:
    "https://github.com/${owner}/${repo}/blob/${branch}/${path}";

  toNixOSGithubUrl = toGithubUrl "NixOS" "nixpkgs" "nixos-${nixpkgsVersion}";
  toCustomGithubUrl = toGithubUrl "SuperPaintman" "dotfiles" "master";
in

let
  eval = lib.evalModules {
  # eval = import (pkgs.path + "/nixos/lib/eval-config.nix") {
    modules = [
      # Custom modules.
      ../modules

      { _module.check = false; }
    ];
    specialArgs = { inherit pkgs; };
  };

  optionsDoc = pkgs.nixosOptionsDoc {
    # inherit (eval) options;
    options = builtins.removeAttrs eval.options ["_module"];
    warningsAreErrors = false;

    transformOptions = opt: opt // {
      # Clean up declaration sites to not refer to the NixOS source tree.
      declarations = map
        (decl: 
          # Built-in modules.
          if hasPrefix (toString pkgs.path) (toString decl) then
            let
              subpath = removePrefix "/" (removePrefix (toString pkgs.path) (toString decl));
            in
            { name = subpath; url = toNixOSGithubUrl subpath; }
          # Custom modules.
          else if hasPrefix (toString ../.) (toString decl) then
            let
              subpath = removePrefix "/" (removePrefix (toString ../.) (toString decl));
            in
            { name = subpath; url = toCustomGithubUrl subpath; }
          else
            decl)
        opt.declarations;
    };
  };

  mkNixDoc = category: file: pkgs.runCommand "nixdoc_${category}.json" { } ''
    ${pkgs.nixdoc}/bin/nixdoc \
      --file ${file} \
      --prefix "lib.x" \
      --category ${escapeShellArg category} \
      --description "" \
      --json-output \
      | ${pkgs.jq}/bin/jq \
      > "$out"
  '';
in

pkgs.runCommand "docs" { } ''
  mkdir -p "$out"
  mkdir -p "$out/functions"

  cp ${optionsDoc.optionsCommonMark} "$out/options.md"
  cat ${optionsDoc.optionsJSON}/share/doc/nixos/options.json | ${pkgs.jq}/bin/jq > "$out/options.json"

  ${concatMapStringsSep "\n"
    (category: ''cp ${mkNixDoc category ../lib/${category}.nix} "$out/functions/${category}.json"'')
    [ "colors" "generators" ]
  }
''
