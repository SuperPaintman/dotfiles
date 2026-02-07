{ lib, ... }:

with lib;

let
  stringOrPlaceholder = placeholder: cond: text:
    if cond then text
    else placeholder;
in

{
  options = with types; {
    variables = mkOption {
      type = let 
        primitives = [ int str path ];
        vars = oneOf (flatten [
          (listOf (oneOf primitives))
          primitives
        ]);
      in attrsOf (nullOr vars);
      default = { };
      description = ''
        The set of environment variables used in shell.
      '';
      apply =
        let
          toStr = v:
            if isPath v then "${v}"
            else toString v;
        in
        flip pipe [
          (filterAttrs (n: v: v != null))
          (mapAttrs (n: toList))
          (mapAttrs (n: v: concatMapStringsSep ":" toStr v))
        ];
    };

    aliases = mkOption {
      type = attrsOf (nullOr (either str path));
      default = { };
      description = ''
        The set of aliases.
      '';
      apply =
        flip pipe [
          (filterAttrs (n: v: v != null))
        ];
    };
  };

  lib = {
    mkExporedShEnvVars = vars:
      let
        HOME = vars.HOME or null;
        PATH = vars.PATH or null;

        mkExport = name: value: ''export ${name}="${concatStringsSep ":" (toList value)}"'';
        
        exportedVars = pipe vars [
          # (traceValSeqN 3) # Debug.
          (filterAttrs (n: v: v != null))
          (filterAttrs (n: v: n != "HOME" && n != "PATH"))
          (mapAttrsToList nameValuePair)

          # Lift some variables.
          (map ({ name, ... }@attrs: attrs // {
            priority =
              if hasPrefix "XDG_" name then 500
              else 1000;
          }))
          (sort (a: b: a.priority < b.priority))

          (map ({ name, value, ... }: mkExport name value))
        ];
      in ''
        ${stringOrPlaceholder "# export HOME" (HOME != null) (mkExport "HOME" HOME)}
        ${stringOrPlaceholder "# export PATH" (PATH != null && PATH != "" && (length (toList PATH)) > 0) ''
          if [ -z "''${__DOTFILES_ORIG_PATH_DONE:-}" ]; then
            export __DOTFILES_ORIG_PATH_DONE=1
            export __DOTFILES_ORIG_PATH="''${PATH:-}"
          fi
          export PATH="${concatStringsSep ":" (toList PATH)}''${__DOTFILES_ORIG_PATH:+:"$__DOTFILES_ORIG_PATH"}"
        ''}
        ${concatStringsSep "\n" exportedVars}
      '';

    mkShAliases = aliases: pipe aliases [
      (filterAttrs (n: v: v != null))
      (mapAttrsToList (n: v: "alias -- ${n}=${escapeShellArg v}"))
      (concatStringsSep "\n")
    ];
  };
}
