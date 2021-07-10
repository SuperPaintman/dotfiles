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
  size = set: length (attrValues set);
  isEmpty = set: (size set) == 0;
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
  toSourcePath = v: if isPath v then v else v.path;
  toLink = { optional ? false }: n: f:
    ''link ${lib.optionalString optional "--optional "}$@ "$ROOT/${toRelativePath name (toSourcePath f.source)}" "$HOME/${n}" || { EXIT_CODE="$?"; }'';
  concatFiles = sep: f: files:
    lib.concatStringsSep sep (lib.mapAttrsToList f files);
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

  ${concatFiles "\n"
    (toLink { })
    (filterFiles isPath files)
  }

  ${concatFiles "\n"
    (toLink { optional = true; })
    (filterFiles isOptional files)
  }
'' + (
  let
    linuxFiles = filterFiles (f: (isLinuxOnly f) && !(isOptional f)) files;
    linuxOptionalFiles = filterFiles (f: (isLinuxOnly f) && (isOptional f)) files;
  in
  lib.optionalString (!(isEmpty linuxFiles) || !(isEmpty linuxOptionalFiles)) ''
    if is_linux; then
      ${concatFiles "\n  "
        (toLink { })
        linuxFiles
      }

      ${concatFiles "\n  "
        (toLink { optional = true; })
        linuxOptionalFiles
      }
    fi
  ''
) + (
  let
    macOSFiles = filterFiles (f: (isMacOSOnly f) && !(isOptional f)) files;
    macOSOptionalFiles = filterFiles (f: (isMacOSOnly f) && (isOptional f)) files;
  in
  lib.optionalString (!(isEmpty macOSFiles) || !(isEmpty macOSOptionalFiles)) ''
    if is_osx; then
      : # OSX specific files.
      ${concatFiles "\n  "
        (toLink { })
        macOSFiles
      }

      ${concatFiles "\n  "
        (toLink { optional = true; })
        macOSOptionalFiles
      }
    fi
  ''
) + ''
  exit "$EXIT_CODE"
''
