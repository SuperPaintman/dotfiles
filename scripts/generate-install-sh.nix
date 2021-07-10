name: path:

with import <nixpkgs> { };
with builtins;
let
  callIfFunction = f: args: if isFunction f then (f args) else f;
  toRelativePath = n: p: lib.removePrefix ((toPath ./..) + "/${n}/") (toPath p);
  mark = tag: path: (if isPath path then { inherit path; } else path) // { "_${tag}" = true; };
  marked = tag: path: (
    if isPath path
    then false
    else if (hasAttr "_${tag}" path) && path."_${tag}" then true
    else false
  );
  files = callIfFunction (import path) {
    linuxOnly = mark "linuxOnly";
    macOSOnly = mark "macOSOnly";
    optional = mark "optional";
  };
  hasSource = v: hasAttr "source" v;
  isLinuxOnly = marked "linuxOnly";
  isMacOSOnly = marked "macOSOnly";
  isOptional = marked "optional";
  filterFiles = pred: files:
    lib.filterAttrs (n: f: (hasAttr "source" f) && (pred f.source)) files;
in
''
  #!/usr/bin/env bash

  #
  # This file is generated; DO NOT EDIT.
  #

  set -e

  ROOT="$(dirname "$(realpath "''${BASH_SOURCE[0]}")")"
  EXIT_CODE=0

  source "$ROOT/../common.sh"


  ${lib.concatStringsSep ""
  (
    lib.mapAttrsToList
    (
      n: f: ''
        link $@ "$ROOT/${toRelativePath name f.source}" "$HOME/${n}" || { EXIT_CODE="$?"; }
      ''
    )
    (filterFiles isPath files)
  )}

  ${lib.concatStringsSep ""
  (
    lib.mapAttrsToList
    (
      n: f: ''
        link --optional $@ "$ROOT/${toRelativePath name f.source.path}" "$HOME/${n}" || { EXIT_CODE="$?"; }
      ''
    )
    (filterFiles isOptional files)
  )}

  if is_linux; then
    : # Linux specific files.
    ${lib.concatStringsSep ""
    (
      lib.mapAttrsToList
      (
        n: f: ''
          link $@ "$ROOT/${toRelativePath name f.source.path}" "$HOME/${n}" || { EXIT_CODE="$?"; }
        ''
      )
      (filterFiles (f: (isLinuxOnly f) && !(isOptional f)) files)
    )}

    ${lib.concatStringsSep ""
    (
      lib.mapAttrsToList
      (
        n: f: ''
          link --optional $@ "$ROOT/${toRelativePath name f.source.path}" "$HOME/${n}" || { EXIT_CODE="$?"; }
        ''
      )
      (filterFiles (f: (isLinuxOnly f) && (isOptional f)) files)
    )}
  fi

  if is_osx; then
    : # OSX specific files.
    ${lib.concatStringsSep ""
    (
      lib.mapAttrsToList
      (
        n: f: ''
          link $@ "$ROOT/${toRelativePath name f.source.path}" "$HOME/${n}" || { EXIT_CODE="$?"; }
        ''
      )
      (filterFiles (f: (isMacOSOnly f) && !(isOptional f)) files)
    )}

    ${lib.concatStringsSep ""
    (
      lib.mapAttrsToList
      (
        n: f: ''
          link --optional $@ "$ROOT/${toRelativePath name f.source.path}" "$HOME/${n}" || { EXIT_CODE="$?"; }
        ''
      )
      (filterFiles (f: (isMacOSOnly f) && (isOptional f)) files)
    )}
  fi

  exit "$EXIT_CODE"
''
