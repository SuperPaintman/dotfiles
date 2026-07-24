# See: https://thevaluable.dev/zsh-completion-guide-examples/
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

    # Entire config.
    extras.config = common.lib.mkExtraOption "config" { };
  };

  # Config.
  config = mkMerge [
    # Common options.
    {
      modules.shell.zsh = {
        variables = mapAttrs (n: mkDefault) config.modules.shell.variables;
        aliases = mapAttrs (n: mkDefault) config.modules.shell.aliases;
        functions = config.modules.shell.functions;
        theme = ''
          ${builtins.readFile ../theme.sh}
          ${builtins.readFile ../theme.zsh}
        '';
      };
    }

    (mkIf cfg.enable {
      modules = {
        users.packages = [ cfg.package ];

        shell.zsh.keyBindings = let 
          ifInteractive = text: ''
            if [[ -o interactive ]]; then
            ${text}
            fi
          '';
        in mkMerge [
          (ifInteractive ''
            # Vim-like jumplist: Ctrl-I and Ctrl-O
            autoload -Uz add-zsh-hook

            typeset -ga __JUMPLIST_BACK
            typeset -ga __JUMPLIST_FORWARD
            typeset -gi __JUMPLIST_MAX=100
            typeset -gi __JUMPLIST_LOCK=0

            __jumplist_cd() {
              local code=0
              if (( __JUMPLIST_LOCK != 0 )); then
                return "$code"
              fi

              __JUMPLIST_LOCK=1
              builtin cd -- "$1" || code="$?"
              __JUMPLIST_LOCK=0

              return "$code"
            }

            __jumplist_record_hook() {
              if (( __JUMPLIST_LOCK != 0 )); then
                return 0
              fi

              [[ -n "$OLDPWD" && "$OLDPWD" != "$PWD" ]] || return
              if (( "''${#__JUMPLIST_BACK}" >= __JUMPLIST_MAX )); then
                shift __JUMPLIST_BACK
              fi
              __JUMPLIST_BACK+=( "$OLDPWD" )
              __JUMPLIST_FORWARD=()

              return 0
            }
            add-zsh-hook chpwd __jumplist_record_hook

            jumplist-back() {
              local dst

              while (( "''${#__JUMPLIST_BACK}" )); do
                dst="''${__JUMPLIST_BACK[-1]}"

                __JUMPLIST_BACK[-1]=()
                [[ -d "$dst" && "$dst" != "$PWD" ]] || continue
                if (( "''${#__JUMPLIST_FORWARD}" >= __JUMPLIST_MAX )); then
                  shift __JUMPLIST_FORWARD
                fi
                __JUMPLIST_FORWARD+=( "$PWD" )
                __jumplist_cd "$dst"

                break
              done

              zle reset-prompt
            }
            zle -N jumplist-back

            jumplist-forward() {
              local dst

              while (( "''${#__JUMPLIST_FORWARD}" )); do
                dst="''${__JUMPLIST_FORWARD[-1]}"

                __JUMPLIST_FORWARD[-1]=()
                [[ -d "$dst" && "$dst" != "$PWD" ]] || continue
                __JUMPLIST_BACK+=( "$PWD" )
                __jumplist_cd "$dst"

                break
              done

              zle reset-prompt
            }
            zle -N jumplist-forward

            # 5 - Ctrl
            # 6 - Shift+Ctrl
            bindkey '^O' jumplist-back # Ctrl-o
            bindkey '^[[105;5u' jumplist-forward # Ctrl-i
          '')
        ];

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
              # Extras Before
              ################################################################################
              ${cfg.extras.config.before}

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

              ################################################################################
              # Extras After
              ################################################################################
              ${cfg.extras.config.after}
            '';
            checkPhase = ''
              # Verify syntax checking by parsing a script without running
              # any commands.
              ${cfg.package}/bin/zsh -n -o extendedglob "$target"

              # ${pkgs.shellcheck}/bin/shellcheck "$target"
            '';
          };
        };

        home.files = {
          # TODO(SuperPaintman): delete later.
          # Backword compatability until files are migrated.
          ".zshrc.migration".text = ''
            export __DOTFILES_MIGRATION_ZSH=1
            if [ -f ~/.config/zsh/zshrc.zsh ]; then
              source ~/.config/zsh/zshrc.zsh
            fi
          '';
        };
      };
    })
  ];
}
