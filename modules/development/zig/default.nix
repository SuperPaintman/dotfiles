{ pkgs, config, lib, libx, ... }:

with lib;

let
  cfg = config.modules.development.zig;

  log = libx.logger.makeLogger { domain = "modules.development.zig"; };
in

{
  # Options.
  options.modules.development.zig = with types; {
    enable = mkOption {
      type = bool;
      default = false;
      description = ''
        Whenever to enable Zig.
      '';
    };

    package = mkOption {
      type = package;
      default = pkgs.zig;
      defaultText = literalExpression "pkgs.zig";
      description = ''
        The Zig package to use.
      '';
    };
  };

  # Config.
  config = mkIf cfg.enable {
    modules = {
      users.packages = with pkgs; [ 
        cfg.package
      ]
      ++ optional (pkgs ? zig-zsh-completions) (
        (log.warnIf (pathExists "${cfg.package}/share/zsh/site-functions/_zig")
          "_zig ZSH completion exists, pkgs.zig-zsh-completions is redundant")
        pkgs.zig-zsh-completions
      );
    };
  };
}
