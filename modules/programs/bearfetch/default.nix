{ config, lib, pkgs, ... }:

with lib;

let
  inherit (config.modules.home) standalone;
  cfg = config.modules.programs.bearfetch;

  mkBin = package: name: if standalone then name else "${package}/bin/${name}";
in

{
  # Options.
  options.modules.programs.bearfetch = with types; {
    enable = mkOption {
      type = bool;
      default = false;
      description = ''
        Whenever to configure `bearfetch`.
      '';
    };

    package = mkOption {
      type = package;
      default = pkgs.bearfetch;
      defaultText = literalExpression "pkgs.bearfetch";
      description = ''
        The bearfetch package to use.
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
          ${mkBin cfg.package "bearfetch"}
        fi
      '';
      shell.zsh.extras.config.after = modules.shell.bash.extras.config.after;
    };
  };
}
