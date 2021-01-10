{ lib, writeShellScriptBin, stdenv, which, unzip, ... }:
let
  toExtensionPath' = out: x: "${out}/${x.pname}-${x.version}.xpi";
  toExtensionPath = x: toExtensionPath' x.out x;

  toExtension = x:
    if lib.isDerivation x
    then x
    else mkFirefoxExtension x;

  mkFirefoxExtension =
    { pname
    , version
    , url
    , sha256
    , meta ? { }
    }:
    stdenv.mkDerivation rec {
      inherit pname version meta;

      src = builtins.fetchurl { inherit url sha256; };

      preferLocalBuild = true;
      allowSubstitutes = false;

      buildCommand = ''
        dst="${toExtensionPath' "$out" { inherit pname version; }}"

        mkdir -p "$(dirname "$dst")"
        install -v -m644 "$src" "$dst"
      '';
    };

  firefox-install-extensions = { extensions ? [ ] }: writeShellScriptBin "firefox-install-extensions" ''
    set -e
    set -u
    set -o pipefail

    if ! ${which}/bin/which firefox > /dev/null 2>&1; then
      echo "Please install firefox" 1>&2
      exit 1
    fi


    ${lib.concatMapStringsSep
    "\n"
      (extension: ''
        firefox ${toExtensionPath (toExtension extension)}
      '')
    extensions}
  '';
in
firefox-install-extensions
