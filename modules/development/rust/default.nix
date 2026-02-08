{ pkgs, config, lib, ... }:

with lib;

let
  inherit (config.modules.home) standalone;
  cfg = config.modules.development.rust;

  mkBin = package: name: if standalone then name else "${package}/bin/${name}";

  toml = pkgs.formats.toml { };

  CARGO_HOME = "$XDG_DATA_HOME/cargo";
  RUSTUP_HOME = "$XDG_DATA_HOME/rustup";
in

{
  # Options.
  options.modules.development.rust = with types; {
    enable = mkOption {
      type = bool;
      default = false;
      description = ''
        Whenever to enable Rust.
      '';
    };

    rustup.package = mkOption {
      type = package;
      default = pkgs.rustup;
      defaultText = literalExpression "pkgs.rustup";
      description = ''
        The rustup package to use.
      '';
    };

    cargo.config = mkOption {
      type = attrsOf (attrsOf anything);
      default = {};
    };
  };

  # Config.
  config = mkMerge [
    {
      modules.development.rust = let 
        mkDefaultAll = attrs: mapAttrs
          (name: value: if isAttrs value then mkDefaultAll value else mkDefault value)
          attrs;
      in {
        cargo.config = mkDefaultAll {
          cargo-new = {
            vcs = "git";
          };

          net = {
            git-fetch-with-cli = true;
          };
        };
      };
    }

    (mkIf cfg.enable {
      modules = {
        users.packages = with pkgs; [ 
          cfg.rustup.package

          rust-analyzer
        ];

        shell.variables = {
          inherit
            CARGO_HOME
            RUSTUP_HOME
            ;

          PATH = [ "${CARGO_HOME}/bin" ];
        };

        home.dataFiles = {
          "cargo/config.toml".source = toml.generate "cargo-config.toml" cfg.cargo.config;
        };
      };
    })
  ];
}
