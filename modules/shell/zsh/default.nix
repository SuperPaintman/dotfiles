{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.modules.shell.zsh;

  common = pkgs.callPackage ../common.nix { inherit config; };
in

{
  # Options.
  options.modules.shell.zsh = with types; {
    enable = mkOption {
      type = bool;
      default = false;
      description = ''
        Whenever to configure `zsh`.
      '';
    };

    package = mkOption {
      type = package;
      default = pkgs.zsh;
      defaultText = literalExpression "pkgs.zsh";
      description = ''
        The zsh package to use.
      '';
    };

    variables = common.options.variables;
    extras.variables = common.lib.mkExtraOption "variables" { };

    aliases = common.options.aliases;
    extras.aliases = common.lib.mkExtraOption "aliases" { };

    keyBindings = common.options.keyBindings;
    extras.keyBindings = common.lib.mkExtraOption "keyBindings" { };

    functions = mkOption {
      type = lines;
      default = "";
      description = ''
        Shell functions.
      '';
    };
    extras.functions = common.lib.mkExtraOption "functions" { };

    theme = mkOption {
      type = lines;
      default = "";
      description = ''
        Shell theme.
      '';
    };
    extras.theme = common.lib.mkExtraOption "theme" { };
  };

  # Config.
  config = mkMerge [
    # Common options.
    {
      modules.shell.zsh = {
        variables = mapAttrs (n: mkDefault) config.modules.shell.variables;
        aliases = mapAttrs (n: mkDefault) config.modules.shell.aliases;
        functions = config.modules.shell.functions;
        theme = mkDefault (common.lib.mkTheme "zsh");
      };
    }

    (mkIf cfg.enable {
      modules = {
        users.packages = [ cfg.package ];

        shell.zsh.functions = ''
          reload() {
            source ~/.zshrc
          }
        '';

        home.configFiles = {
          "zsh/zshrc.zsh".source = pkgs.writeTextFile {
            name = "zshrc.zsh";
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
              # Key Bindings.
              ################################################################################
              ${cfg.extras.keyBindings.before}
              ${cfg.keyBindings}
              ${cfg.extras.keyBindings.after}

              ################################################################################
              # Functions.
              ################################################################################
              ${cfg.extras.functions.before}
              ${cfg.functions}
              ${cfg.extras.functions.after}

              ################################################################################
              # Theme.
              ################################################################################
              ${cfg.extras.theme.before}
              ${cfg.theme}
              ${cfg.extras.theme.after}
            '';
            checkPhase = ''
              # Verify syntax checking by parsing a script without running
              # any commands.
              ${cfg.package}/bin/zsh -n -o extendedglob "$target"

              # ${pkgs.shellcheck}/bin/shellcheck "$target"
            '';
          };
        };
      };
    })
  ];
}
