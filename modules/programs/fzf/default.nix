# See: https://github.com/junegunn/fzf
# See: https://github.com/junegunn/fzf/wiki

{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.modules.programs.fzf;

  formatOptionArgs = args: concatStringsSep "," (mapAttrsToList
    (name: value: "${name}:${value}")
    args);

  formatOptions = options: concatStringsSep " " (mapAttrsToList
    (name: args: "--${name}=${escapeShellArg (formatOptionArgs args)}")
    options);
in

{
  # Options.
  options.modules.programs.fzf = with types; {
    enable = mkOption {
      type = bool;
      default = false;
      description = mdDoc ''
        Whenever to configure `fzf`.
      '';
    };

    package = mkOption {
      type = package;
      default = pkgs.fzf;
      defaultText = literalExpression "pkgs.fzf";
      description = mdDoc ''
        The fzf package to use.
      '';
    };
  };

  # Config.
  config = mkIf cfg.enable {
    modules = {
      users.packages = [ cfg.package ];

      environment.variables = {
        FZF_DEFAULT_COMMAND = "fd --type f"; # TODO(SuperPaintman): check if fd is installed.

        FZF_DEFAULT_OPTS = formatOptions {
          # Color.
          # See: https://github.com/junegunn/fzf/wiki/Color-schemes#color-configuration
          color = {
            hl = "blue";
            "hl+" = "bright-blue";
            prompt = "blue";
            pointer = "red";
            marker = "bright-red";
            border = "bright-black";
            info = "bright-yellow";
            header = "bright-black";
            spinner = "green";
          };

          # Bind.
          bind = {
            "ctrl-h" = "preview-up";
            "ctrl-l" = "preview-down";
          };
        };
      };
    };
  };
}
