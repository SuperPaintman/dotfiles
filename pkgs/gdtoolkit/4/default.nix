# TODO(SuperPaintman): the requires should be auto-generated.
#
# See: https://github.com/Scony/godot-gdscript-toolkit
# See: https://github.com/NixOS/nixpkgs/blob/nixos-23.05/pkgs/development/tools/gdtoolkit/default.nix

{ python3Packages
, fetchFromGitHub
}:

let
  inherit (python3Packages) buildPythonApplication buildPythonPackage fetchPypi;

  pypiPackage =
    { pname
    , version
    , sha256
    , propagatedBuildInputs ? [ ]
    , doCheck ? false
    }: buildPythonPackage rec {
      inherit pname version propagatedBuildInputs doCheck;

      src = fetchPypi { inherit pname version sha256; };
    };
in

buildPythonApplication rec {
  pname = "gdtoolkit";
  version = "4.1.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-OY0Meh0LjAEVDzFDB4DXB0ysNO9CkrNqxoFMfATtyQk=";
  };

  disabled = python3Packages.pythonOlder "3.7";

  propagatedBuildInputs = with python3Packages; [
    setuptools
    lark
    pyyaml
  ] ++ [
    (pypiPackage {
      pname = "docopt-ng";
      version = "0.8.1";
      sha256 = "sha256-6mphooj8hk7uayLW/iiqIC1Z/Ib60F8W/145zE6n9uM=";
    })
    (pypiPackage {
      pname = "radon";
      version = "6.0.1";
      sha256 = "sha256-0awAU5Q6iTh4lA/tyLGaznA4b8nJvwoJIppEEl6/RbU=";
      propagatedBuildInputs = with python3Packages; [
        colorama
      ] ++ [
        (pypiPackage {
          pname = "mando";
          version = "0.7.1";
          sha256 = "sha256-GLqpmbS2E/rvsA6sTvrc8U9RC1m5JLZuCCiaod6MNQA=";
          propagatedBuildInputs = with python3Packages; [
            six
          ];
        })
      ];
    })
  ];

  doCheck = false;
}
