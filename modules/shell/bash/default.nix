{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.modules.shell.bash;

  common = pkgs.callPackage ../common.nix { inherit config; };

  mkBashOptions = flip pipe [
    (filterAttrs (n: v: v != null))
    (mapAttrs (n: v: if v then "-s" else "-u"))
    (mapAttrsToList (n: v: ''shopt ${v} ${n}''))
    (concatStringsSep "\n")
  ];
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

    options = mkOption {
      type = attrsOf (nullOr bool);
      default = { };
      description = ''
        The set of bash options.
      '';
      apply =
        flip pipe [
          (filterAttrs (n: v: v != null))
        ];
    };
    extras.options = common.lib.mkExtraOption "options" { };

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
      modules.shell.bash = {
        variables = mapAttrs (n: mkDefault) config.modules.shell.variables;
        aliases = mapAttrs (n: mkDefault) config.modules.shell.aliases;
        functions = config.modules.shell.functions;
        theme = mkDefault (common.lib.mkTheme "bash");
      };
    }

    (mkIf cfg.enable {
      modules = {
        users.packages = [ cfg.package ];

        shell.bash.variables = rec {
          # See: https://www.gnu.org/software/bash/manual/html_node/Bash-Variables.html

          # The maximum number of commands to remember on the history list.
          HISTSIZE = "2000";

          # The maximum number of lines contained in the history file.
          HISTFILESIZE = HISTSIZE;

          # If this variable is set and not null, its value is used as a
          # format string for strftime(3) to print the time stamp associated
          # with each history entry displayed by the history builtin.
          HISTTIMEFORMAT = "[%F %T] ";

          # A colon-separated list of values controlling how commands are saved
          # on the history list. 
          #
          # - ‘ignorespace’ - lines which begin with a space character are not 
          #                   saved in the history list.
          # - ‘ignoredups’  - causes lines which match the previous history 
          #                   entry not to be saved.
          # - ‘ignoreboth’  -  shorthand for ‘ignorespace’ and ‘ignoredups’.
          HISTCONTROL = "ignoreboth";

          # The name of the file to which the command history is saved.
          HISTFILE = "$XDG_STATE_HOME/bash/history";

          # A colon-separated list of patterns used to decide which command
          # lines should be saved on the history list.
          #
          # - ‘&’ - identical to ignoredups.
          # - '[ ]*’ - identical to ignorespace.
          HISTIGNORE = [
            "&"
            "[ ]*"
            "history"
            "clear"
          ];
        };

        shell.bash.options = {
          # See: https://www.gnu.org/software/bash/manual/html_node/The-Shopt-Builtin.html
          #
          # Run `shopt` to see all options.

          # If set, a command name that is the name of a directory is executed 
          # as if it were the argument to the cd command.
          # This option is only used by interactive shells.
          autocd = true;

          # If set, Bash checks the window size after each external
          # (non-builtin) command and, if necessary, updates the values of
          # LINES and COLUMNS, using the file descriptor associated with stderr
          # if it is a terminal.
          # This option is enabled by default. 
          checkwinsize = true;

          # If set, Bash attempts to save all lines of a multiple-line command
          # in the same history entry. This allows easy re-editing of
          # multi-line commands.
          cmdhist = true;

          # If set, Bash quotes all shell metacharacters in filenames and 
          # directory names when performing completion.
          # If not set, Bash removes metacharacters such as the dollar sign
          # from the set of characters that will be quoted in completed
          # filenames when these metacharacters appear in shell variable
          # references in words to be completed.
          complete_fullquote = true;

          # If set, aliases are expanded as described below under Aliases.
          expand_aliases = true;

          # If set, enable the extended pattern matching features.
          extglob = true;

          # If set, $'string' and $"string" quoting is performed within 
          # ${parameter} expansions enclosed in double quotes.
          extquote = true;

          # If set, the suffixes specified by the FIGNORE shell variable cause
          # words to be ignored when performing word completion even if the
          # ignored words are the only possible completions.
          force_fignore = true;

          # If set, range expressions used in pattern matching bracket 
          # expressions behave as if in the traditional C locale when
          # performing comparisons.
          globasciiranges = true;

          # If set, filename expansion will never match the filenames . and .., 
          # even if the pattern begins with a ‘.’.
          globskipdots = true;

          # If set, the history list is appended to the file named by the value
          # of the HISTFILE variable when the shell exits, rather than
          # overwriting the file.
          histappend = true; # DEFAUTL: false

          # If set, and Readline is being used, Bash will attempt to perform
          # hostname completion when a word containing a ‘@’ is being completed
          hostcomplete = false; # DEFAULT: true

          # In an interactive shell, a word beginning with ‘#’ causes that word
          # and all remaining characters on that line to be ignored, as in a 
          # non-interactive shell.
          interactive_comments = true;

          # If set, Bash matches filenames in a case-insensitive fashion when
          # performing filename expansion.
          nocaseglob = true; # DEFAULT: false

          # If set, Bash expands occurrences of ‘&’ in the replacement string
          # of pattern substitution to the text matched by the pattern, as
          # described above.
          patsub_replacement = true;

          # If set, enable the programmable completion facilities.
          progcomp = true;

          # If set, prompt strings undergo parameter expansion, command
          # substitution, arithmetic expansion, and quote removal after being
          # expanded.
          promptvars = true;

          # If set, the . (source) builtin uses the value of PATH to find the
          # directory containing the file supplied as an argument when
          # the -p option is not supplied.
          sourcepath = true;
        };

        shell.bash.functions = ''
          reload() {
            source ~/.bashrc
          }
        '';

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
              # Options.
              ################################################################################
              ${cfg.extras.options.before}
              ${mkBashOptions cfg.options}
              ${cfg.extras.options.after}

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
              ${cfg.package}/bin/bash -n -O extglob "$target"

              # ${pkgs.shellcheck}/bin/shellcheck "$target"
            '';
          };
        };

        home.activation.bashXDGDirs = ''
          if [ ! -d "$XDG_DATA_HOME/bash" ]; then
            mkdir "$XDG_DATA_HOME/bash"
          fi
          if [ ! -d "$XDG_STATE_HOME/bash" ]; then
            mkdir "$XDG_STATE_HOME/bash"
          fi
        '';
      };
    })
  ];
}
