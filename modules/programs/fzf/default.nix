# See: https://github.com/junegunn/fzf
# See: https://github.com/junegunn/fzf/wiki
# See: https://github.com/nix-community/home-manager/blob/master/modules/programs/fzf.nix

# TODO(SuperPaintman):
#     Add custom fuzzy completion:
#       - [ ] Docker
#       - [ ] Go
#       - [ ] Git
#
#     See: https://github.com/junegunn/fzf#custom-fuzzy-completion
#     See: https://github.com/pierpo/fzf-docker/blob/master/fzf-docker.plugin.zsh

# TODO(SuperPaintman):
#     Add FZF completions and key bindings.

{ config, lib, pkgs, ... }:

with lib;

let
  inherit (config.modules.home) standalone;
  cfg = config.modules.programs.fzf;

  mkBin = package: name: if standalone then name else "${package}/bin/${name}";

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
      description = ''
        Whenever to configure `fzf`.
      '';
    };

    package = mkOption {
      type = package;
      default = pkgs.fzf;
      defaultText = literalExpression "pkgs.fzf";
      description = ''
        The fzf package to use.
      '';
    };
  };

  # Config.
  config = mkIf cfg.enable {
    modules = {
      users.packages = [ cfg.package ];

      shell.variables = {
        FZF_DEFAULT_COMMAND = "${mkBin pkgs.fd "fd"} --type f";

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

      # TODO(SuperPaintman): delete this block, once migrated to shell.variables. 
      environment.variables = {
        FZF_DEFAULT_COMMAND = "${mkBin pkgs.fd "fd"} --type f";

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
