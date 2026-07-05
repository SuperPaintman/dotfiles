{ pkgs, config, lib, ... }:

with lib;

let
  cfg = config.modules.development.go;

  warn = msg: lib.warn "[modules.development.go]: ${msg}";

  GOPATH = "$XDG_DATA_HOME/go";
  GOBIN = "${GOPATH}/bin";
  GOCACHE = "$XDG_CACHE_HOME/go-build";
  GOENV = "$XDG_CONFIG_HOME/go/env";
  GOMODCACHE = "${GOPATH}/pkg/mod";
  GOTELEMETRY = "off"; # local
  GOTELEMETRYDIR = "$XDG_CONFIG_HOME/go/telemetry"; # NOTE(SuperPaitnman): this is the default path, but why it isn't in $$XDG_CACHE_HOME?
in

{
  # Options.
  options.modules.development.go = with types; {
    enable = mkOption {
      type = bool;
      default = false;
      description = ''
        Whenever to enable Go.
      '';
    };

    package = mkOption {
      type = package;
      default = pkgs.go;
      defaultText = literalExpression "pkgs.go";
      description = ''
        The Go package to use.
      '';
    };

    gopls = {
      package = mkOption {
        type = package;
        default = pkgs.gopls;
        defaultText = literalExpression "pkgs.gopls";
        description = ''
          The gopls package to use.
        '';
      };
    };
  };

  # Config.
  config = mkIf cfg.enable {
    modules = {
      users.packages = with pkgs; [ 
        cfg.package
        cfg.gopls.package

        # TODO(SuperPaitnamn): add completions for go.

        gotools # goimports
        go-tools # staticcheck
        godef
        go-outline
        gomodifytags
        impl
        delve
      ]
      ++ optionals (pkgs ? go-zsh-completions) (
        if !(pathExists "${cfg.package}/share/zsh/site-functions/_golang") then
          [ pkgs.go-zsh-completions ]
        else
          warn "_golang ZSH completion exists, pkgs.go-zsh-completions is redundant"
          [ ]
      );

      shell.variables = {
        inherit 
          GOPATH
          GOBIN
          GOCACHE
          GOENV
          GOMODCACHE
          GOTELEMETRY
          GOTELEMETRYDIR
          ;
        PATH = [ GOBIN ];
      };
    };
  };
}
