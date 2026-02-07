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

    functions = mkOption {
      type = lines;
      default = "";
      description = ''
        Shell functions.
      '';
    };
  };

  # Config.
  config = {
    # Default variables.
    modules.shell.variables = {
      PATH = [ ];

      EDITOR = mkDefault "vi";
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

      e = "$EDITOR";
    };

    modules.shell.functions = ''
      :q() {
        exit 0
      }
    '';
  };
}

