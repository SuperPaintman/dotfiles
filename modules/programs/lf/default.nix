# Terminal file manager.
# See: https://github.com/gokcehan/lf
# See: https://github.com/gokcehan/lf/blob/master/doc.md#settings

{ config, lib, pkgs, ... }:

with lib;

let
  inherit (config.modules.home) standalone;
  cfg = config.modules.programs.lf;

  lfpreview = pkgs.writeShellScriptBin "lfpreview" ''
    exec ${pkgs.bat}/bin/bat \
      --color=always \
      --style=changes,numbers \
      "$1"
  '';
in

{
  # Options.
  options.modules.programs.lf = with types; {
    enable = mkOption {
      type = bool;
      default = false;
      description = ''
        Whenever to configure `lf`.
      '';
    };

    package = mkOption {
      type = package;
      default = pkgs.lf;
      defaultText = literalExpression "pkgs.lf";
      description = ''
        The lf package to use.
      '';
    };

    extraConfig = mkOption {
      type = lines;
      default = "";
      description = ''
        Extra configuration for LF.
      '';
    };
  };

  # Config.
  config = mkIf cfg.enable {
    modules = {
      users.packages = [ cfg.package ];

      shell.variables = {
        LF_ICONS = "$XDG_CONFIG_HOME/lf/icons";
      };

      shell.functions = ''
        lfcd() {
          local tmp
          local dir

          tmp="$(umask 077 && mktemp)"
          lf -last-dir-path="$tmp" "$@"
          if [ -f "$tmp" ]; then
            dir="$(cat "$tmp")"
            rm -f "$tmp"
            if [ -d "$dir" ] && [ "$dir" != "$(pwd)" ]; then
              builtin cd "$dir" || return "$?"
            fi
          fi
        }

        cd() {
          if [ "$#" = 0 ]; then
            lfcd
          else
            # shellcheck disable=SC2068 # We need to re-split elements.
            builtin cd $@ || return "$?"
          fi
        }
      '';

      # TODO(SuperPaintman): delete this block, once migrated to shell.variables. 
      environment.variables = {
        LF_ICONS = "$XDG_CONFIG_HOME/lf/icons";
      };

      home.configFiles = {
        "lf/lfrc".text = concatStringsSep "\n" (
          [
            (builtins.readFile ./lfrc)
          ]
          ++ optional (!standalone) ''
            # Show icons before each item in the list.
            set icons false

            # Set the path of a previewer file to filter the content of regular
            # files for previewing.
            set previewer ${lfpreview}/bin/lfpreview
          ''
          ++ [
            cfg.extraConfig
          ]
        );

        # TODO(SuperPaintman): enable icons later.
        # See: https://github.com/gokcehan/lf/blob/master/etc/icons_colored.example
        # "lf/icons".text = pipe [
        #   { type = "ln"; icon = ""; } # LINK
        #   { type = "or"; icon = ""; } # ORPHAN
        #   { type = "tw"; icon = ""; } # STICKY_OTHER_WRITABLE
        #   { type = "ow"; icon = ""; } # OTHER_WRITABLE
        #   { type = "st"; icon = ""; } # STICKY
        #   { type = "di"; icon = ""; } # DIR
        #   { type = "pi"; icon = ""; } # FIFO
        #   { type = "so"; icon = ""; } # SOCK
        #   { type = "bd"; icon = ""; } # BLK
        #   { type = "cd"; icon = ""; } # CHR
        #   { type = "su"; icon = ""; } # SETUID
        #   { type = "sg"; icon = ""; } # SETGID
        #   { type = "ex"; icon = ""; } # EXEC
        #   { type = "fi"; icon = ""; } # FILE
        #
        #   { type = "*.go"; icon = ""; color = "00;38;2;81;154;186"; }
        #   { type = "*.lua"; icon = ""; color = "00;38;2;81;160;207"; }
        #   { type = "*.nix"; icon = "󱄅"; color = "00;38;2;126;186;228"; }
        # ] [
        #   (map ({ type ? "", icon ? "", color ? "" }: ''${type} ${icon} ${color}''))
        #   (concatStringsSep "\n")
        # ];
      };

      # TODO(SuperPaintman):
      #     I want to migrate the following files/snippets into this config.
      #
      #     Probably a custom option (like shell.functions.bash = ...).
      /*
      # from bash/functions.sh

      lfcd() {
          if ! which lf > /dev/null 2>&1; then
              echo "Please install lf" 1>&2
              return 1
          fi

          tmp="$(mktemp)"
          lf -last-dir-path="$tmp" "$@"
          if [ -f "$tmp" ]; then
              dir="$(cat "$tmp")"
              rm -f "$tmp"
              if [ -d "$dir" ]; then
                  if [ "$dir" != "$(pwd)" ]; then
                      cd "$dir"
                  fi
              fi
          fi
      }

      # from bash/aliases.sh

      # Use `lfcd` (`lf`) as `cd` without arguments.
      if can lfcd; then
          cd() {
              if [ "$#" = 0 ]; then
                  lfcd
              else
                  builtin cd $@
              fi
          }
      fi
      */
    };
  };
}
