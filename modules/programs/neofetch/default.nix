{ config, lib, pkgs, ... }:

with lib;

let
  inherit (config.modules.home) standalone;
  cfg = config.modules.programs.neofetch;

  mkBin = package: name: if standalone then name else "${package}/bin/${name}";
in

{
  # Options.
  options.modules.programs.neofetch = with types; {
    enable = mkOption {
      type = bool;
      default = false;
      description = ''
        Whenever to configure `neofetch`.
      '';
    };

    package = mkOption {
      type = package;
      default = pkgs.neofetch;
      defaultText = literalExpression "pkgs.neofetch";
      description = ''
        The neofetch package to use.
      '';
    };
  };

  # Config.
  config = mkIf cfg.enable rec {
    modules = {
      users.packages = [ cfg.package ];

      # TODO(SuperPaintman): make it configurable.
      shell.bash.extras.config.after = ''
        # Show system information.
        if [ "''${SHLVL:-0}" -le "1" ] && [ -z "''${IN_NIX_SHELL:-}" ] && [ -z "''${TMUX:-}" ]; then
          ${mkBin cfg.package "neofetch"} --no_config --config ~/.config/neofetch/config.conf
        fi
      '';
      shell.zsh.extras.config.after = modules.shell.bash.extras.config.after;

      home.configFiles = {
        "neofetch/config.conf".source = ./config.conf;
      };
    };
  };
}
