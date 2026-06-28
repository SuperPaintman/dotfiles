{ pkgs, config, lib, ... }:

with lib;

let
  inherit (config.modules.home) standalone;
  cfg = config.modules.development.protobuf;

  mkBin = package: name: if standalone then name else "${package}/bin/${name}";

  mkGenOptions = name: pkg: pkgText: with types; {
    enable = mkOption {
      type = bool;
      default = false;
      description = ''
        Whenever to enable ${name}.
      '';
    };

    package = mkOption {
      type = package;
      default = pkg;
      defaultText = literalExpression pkgText;
      description = ''
        The ${name} package to use.
      '';
    };
  };

  optionalGen = c: optional c.enable c.package;
in

{
  # Options.
  options.modules.development.protobuf = with types; {
    enable = mkOption {
      type = bool;
      default = false;
      description = ''
        Whenever to enable Protobuf.
      '';
    };

    package = mkOption {
      type = package;
      default = pkgs.protobuf;
      defaultText = literalExpression "pkgs.protobuf";
      description = ''
        The Protobuf package to use.
      '';
    };

    gen.go = mkGenOptions "Protoc Gen Go" pkgs.protoc-gen-go "pkgs.protoc-gen-go";
    gen.go-grpc = mkGenOptions "Protoc Gen Go gRPC" pkgs.protoc-gen-go-grpc "pkgs.protoc-gen-go-grpc";
  };

  # Config.
  config = mkMerge [
    {
      modules.development.protobuf.gen = let
        dev = config.modules.development;
      in {
        go.enable = mkDefault dev.go.enable;
        go-grpc.enable = mkDefault dev.go.enable;
      };
    }

    (mkIf cfg.enable {
      modules = {
        users.packages = [ 
          cfg.package
        ]
        ++ optionalGen cfg.gen.go
        ++ optionalGen cfg.gen.go-grpc;
      };
    })
  ];
}
