{ config, lib, pkgs, ... }:

with lib;

let
  inherit (config.modules.home) standalone;

  mkBin = package: name: if standalone then name else "${package}/bin/${name}";

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

    keyBindings = mkOption {
      type = lines;
      default = "";
      description = ''
        The list of key bindings.
      '';
    };
  };

  lib = rec {
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
        ${concatStringsSep "\n" exportedVars}
        ${stringOrPlaceholder "# export PATH" (PATH != null && PATH != "" && (length (toList PATH)) > 0) ''
          if [ -z "''${__DOTFILES_ORIG_PATH_DONE:-}" ]; then
            export __DOTFILES_ORIG_PATH_DONE=1
            export __DOTFILES_ORIG_PATH="''${PATH:-}"
          fi
          export PATH="${concatStringsSep ":" (toList PATH)}''${__DOTFILES_ORIG_PATH:+:"$__DOTFILES_ORIG_PATH"}"
        ''}
      '';

    mkShAliases = aliases: pipe aliases [
      (filterAttrs (n: v: v != null))
      (mapAttrsToList (n: v: "alias -- ${n}=${escapeShellArg v}"))
      (concatStringsSep "\n")
    ];

    mkExtraOption' = name: order: opts: with types; mkOption {
      type = lines;
      default = "";
      description = ''
        Shell script code called ${order} the ${name} block.
      '';
    } // opts;

    mkExtraOption = name: opts: {
      before = mkExtraOption' name "before" opts;
      after = mkExtraOption' name "after" opts;
    };

    mkTheme = shell: let 
      colors.normal = let 
        # mkBash = c: "\\[\\033[${c}m\\]";
        mkBash = c: "\\033[${c}m";
        mkZSH = c: "%{$fg[${c}]}%";
      in {
        red = { bash = mkBash "00;31"; zsh = mkZSH "red"; };
        green = { bash = mkBash "00;32"; zsh = mkZSH "green"; };
        yellow = { bash = mkBash "00;33"; zsh = mkZSH "yellow"; };
        blue = { bash = mkBash "00;34"; zsh = mkZSH "blue"; };
        reset = { bash = mkBash "00"; zsh = "%{$reset_color%}"; };
      };
      colors.bright = let 
        # mkBash = c: "\\[\\033[${c}m\\]";
        mkBash = c: "\\033[${c}m";
        mkZSH = c: "%{$fg_bold[${c}]}%";
      in {
        red = { bash = mkBash "01;31"; zsh = mkZSH "red"; };
        green = { bash = mkBash "01;32"; zsh = mkZSH "green"; };
        yellow = { bash = mkBash "01;33"; zsh = mkZSH "yellow"; };
        blue = { bash = mkBash "01;34"; zsh = mkZSH "blue"; };
        reset = { bash = mkBash "00"; zsh = "%{$reset_color%}"; };
      };

      var = name: "__DOTFILES_THEME_${name}";
      shVar = name: "\${${var name}}";

      mkColorNormal = color: colors.normal.${color}.${shell};
      mkColorBright = color: colors.bright.${color}.${shell};
      c = mkColorNormal;
      cb = mkColorBright;

      # placeholders = {
      #   username = { bash = "\\u"; zsh = "%n"; };
      #   hostname = { bash = "\\h"; zsh = "%m"; };
      # };
      #
      # mkPlaceholder = name: placeholders.${name}.${shell};
      # p = mkPlaceholder;

      parts = {
        username = "${cb "green"}${shVar "USERNAME"}${c "reset"}";
        hostname = "${cb "green"}${shVar "HOSTNAME"}${c "reset"}";
        pwd = "${c "red"}$(__dotfiles_theme_fish_pwd)${c "reset"}";
        status = "${shVar "USER_COLOR"}${shVar "USER_CARET"}${c "reset"}";
      };
    in ''
      export ${var "USERNAME"}="$(whoami)"
      export ${var "HOSTNAME"}="$(hostname)"
      export ${var "USER_CARET"}='$'
      export ${var "USER_COLOR"}='${c "green"}'
      if [ "''${UID:-1000}" = "0" ]; then
        export ${var "USER_CARET"}='#'
        export ${var "USER_COLOR"}='${c "red"}'
      fi

      __dotfiles_theme_exit_code() {
        if [ "$1" -gt 0 ]; then
          echo " [${cb "red"}$1${c "reset"}]"
        else
          echo ""
        fi
      }

      __dotfiles_theme_fish_pwd() {
        echo "$(pwd | ${mkBin pkgs.perl "perl"} -pe '
        BEGIN {
            binmode STDIN,  ":encoding(UTF-8)";
            binmode STDOUT, ":encoding(UTF-8)";
        }; s|^$ENV{HOME}|~|g; s|/([^/.])[^/]*(?=/)|/$1|g; s|/\.([^/])[^/]*(?=/)|/.$1|g
        ')"
      }

      export ${var "TIMER_START"}=""
      __dotfiles_theme_timer_start() {
        if [ "''${${var "TIMER_START"}:-}x" = "x" ]; then
          export ${var "TIMER_START"}="''${SECONDS}"
          # export ${var "TIMER_START"}="$(date +'%s%3N')"
        fi
      }
      trap __dotfiles_theme_timer_start DEBUG

      export ${var "TIMER_ELAPSED"}=""
      __dotfiles_theme_timer_stop() {
        local timer_stop="$SECONDS"
        # local timer_stop="$(date +'%s%3N')"

        export ${var "TIMER_ELAPSED"}="$((timer_stop - ${var "TIMER_START"}))"
        export ${var "TIMER_START"}=""
      }
      PROMPT_COMMAND=__dotfiles_theme_timer_stop

      __dotfiles_theme_timer() {
        echo " ${c "blue"}${shVar "TIMER_ELAPSED"}s${c "reset"}"
      }

      __dotfiles_theme_time() {
        date +'${c "yellow"}%H:%M:%S${c "reset"}'
      }

      __dotfiles_theme_shell_level_deep() {
        if [ "''${TMUX:-}x" != "x" ] ; then
          test "''${SHLVL:-1}" -gt 2
        else
          test "''${SHLVL:-1}" -gt 1
        fi
      }

      __dotfiles_theme_shell_level() {
        if __dotfiles_theme_shell_level_deep; then
          echo " ${cb "blue"}${c "reset"}"
        fi
      }

      __dotfiles_theme_prompt_left() {
        local exitcode="$?"
        echo -e "${concatStringsSep "" [
          parts.username
          "@"
          parts.hostname
          " "
          parts.pwd
          ''$(__dotfiles_theme_shell_level)''
          ''$(__dotfiles_theme_exit_code "$exitcode")''
          " "
          ''$(__dotfiles_theme_time)''
          " "
          ''$(__dotfiles_theme_timer)''
          " "
          parts.status
          " "
        ]}"
      }

      export PS1='$(__dotfiles_theme_prompt_left)'
    '';
  };
}
