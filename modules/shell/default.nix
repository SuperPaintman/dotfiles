{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.modules.shell;

  common = import ./common.nix { inherit lib; };
in

{
  # Options.
  options.modules.shell = with types; {
    variables = common.options.variables;

    aliases = common.options.aliases;
  };

  # Config.
  config = mkMerge [
    (mkIf (cfg.bash.enable) {
      modules = rec {
        users.packages = with pkgs; [
          coreutils
          tree
          which
        ];

        shell.bash.extraVariables = let
          out = pkgs.runCommand "dircolors" { } ''
            eval "$(${pkgs.coreutils}/bin/dircolors -b)"
            echo -n "$LS_COLORS" > "$out"
          '';
        in ''
          # dircolors -b
          export LS_COLORS=${escapeShellArg (builtins.readFile out)}
        '';
        shell.zsh.extraVariables = shell.bash.extraVariables;
      };
    })

    {
      # Default variables.
      modules.shell.variables = {
        PATH = [ ];
      }
      # XDG_*
      // filterAttrs (n: v: hasPrefix "XDG_" n) config.environment.variables;

      modules.shell.aliases = {
        # Shortcuts. 
        ".." = "cd ..";
        "cd.." = "cd ..";
        "..." = "cd ../..";
        "...." = "cd ../../..";
        "....." = "cd ../../../..";
        "......" = "cd ../../../../..";
        "~" = "cd ~";

        ll = "ls -alh --group-directories-first";
        la = "ls -ah --group-directories-first";
        l = "ls -h --group-directories-first";

        dfh = "df -h --total";

        tree = "tree -C";

        where = "which";
      };
    }
  ];
}

