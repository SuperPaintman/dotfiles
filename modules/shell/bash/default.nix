{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.modules.shell.bash;

  common = import ../common.nix { inherit lib; };
in

{
  # Options.
  options.modules.shell.bash = with types; {
    enable = mkOption {
      type = bool;
      default = false;
      description = mdDoc ''
        Whenever to configure `bash`.
      '';
    };

    package = mkOption {
      type = package;
      default = pkgs.bashInteractive;
      defaultText = literalExpression "pkgs.bashInteractive";
      description = mdDoc ''
        The bash package to use.
      '';
    };

    variables = common.options.variables;
    extraVariables = mkOption {
      type = lines;
      default = "";
      description = ''
        Shell script code called after variables.
      '';
    };

    aliases = common.options.aliases;
    extraAliases = mkOption {
      type = lines;
      default = "";
      description = ''
        Shell script code called after aliases.
      '';
    };
  };

  # Config.
  config = mkMerge [
    # Common options.
    {
      modules.shell.bash = {
        variables = mapAttrs (n: mkDefault) config.modules.shell.variables;
        aliases = mapAttrs (n: mkDefault) config.modules.shell.aliases;
      };
    }

    (mkIf cfg.enable {
      modules = {
        users.packages = [ cfg.package ];

        home.configFiles = {
          # TODO(SuperPaintman): use real file.
          "bash2/bashrc".source = pkgs.writeTextFile {
            name = ".bashrc";
            executable = true;
            text = ''
              # shellcheck disable=SC2148 # No shebang.

              ################################################################################
              # Variables.
              ################################################################################
              ${common.lib.mkExporedShEnvVars cfg.variables}
              ${cfg.extraVariables}

              ################################################################################
              # Aliases.
              ################################################################################
              ${common.lib.mkShAliases cfg.aliases}
              ${cfg.extraAliases}
            '';
            checkPhase = ''
              # Verify syntax checking by parsing a script without running
              # any commands.
              ${cfg.package}/bin/bash -n -O extglob "$target"

              ${pkgs.shellcheck}/bin/shellcheck "$target"
            '';
          };
        };
      };
    })
  ];
}
