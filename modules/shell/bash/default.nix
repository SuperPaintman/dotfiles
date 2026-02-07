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
      description = ''
        Whenever to configure `bash`.
      '';
    };

    package = mkOption {
      type = package;
      default = pkgs.bashInteractive;
      defaultText = literalExpression "pkgs.bashInteractive";
      description = ''
        The bash package to use.
      '';
    };

    variables = common.options.variables;
    extras.variables = common.lib.mkExtraOption "variables" { };

    aliases = common.options.aliases;
    extras.aliases = common.lib.mkExtraOption "aliases" { };

    functions = mkOption {
      type = lines;
      default = "";
      description = ''
        Shell functions.
      '';
    };
    extras.functions = common.lib.mkExtraOption "functions" { };
  };

  # Config.
  config = mkMerge [
    # Common options.
    {
      modules.shell.bash = {
        variables = mapAttrs (n: mkDefault) config.modules.shell.variables;
        aliases = mapAttrs (n: mkDefault) config.modules.shell.aliases;
        functions = config.modules.shell.functions;
      };
    }

    (mkIf cfg.enable {
      modules = {
        users.packages = [ cfg.package ];

        home.configFiles = {
          "bash/bashrc.sh".source = pkgs.writeTextFile {
            name = "bashrc.sh";
            executable = true;
            text = ''
              # shellcheck disable=SC2148 # No shebang.
              # shellcheck disable=SC2120

              ################################################################################
              # Variables.
              ################################################################################
              ${cfg.extras.variables.before}
              ${common.lib.mkExporedShEnvVars cfg.variables}
              ${cfg.extras.variables.after}

              ################################################################################
              # Aliases.
              ################################################################################
              ${cfg.extras.aliases.before}
              ${common.lib.mkShAliases cfg.aliases}
              ${cfg.extras.aliases.after}

              ################################################################################
              # Functions.
              ################################################################################
              ${cfg.extras.functions.before}
              ${cfg.functions}
              ${cfg.extras.functions.after}
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
