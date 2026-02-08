{ pkgs, config, lib, ... }:

with lib;

let
  cfg = config.modules.development.dart;
in

{
  # Options.
  options.modules.development.dart = with types; {
    enable = mkOption {
      type = bool;
      default = false;
      description = ''
        Whenever to enable Dart.
      '';
    };

    package = mkOption {
      type = package;
      default = pkgs.dart;
      defaultText = literalExpression "pkgs.dart";
      description = ''
        The Dart package to use.
      '';
    };

    flutter.enable = mkOption {
      type = bool;
      default = false;
      description = ''
        Whenever to enable Flutter.
      '';
    };

    flutter.package = mkOption {
      type = package;
      default = pkgs.flutter;
      defaultText = literalExpression "pkgs.flutter";
      description = ''
        The Flutter package to use.
      '';
    };
  };

  # Config.
  # TODO(SuperPaintman): 
  #     Move the following files / dirs from home to XDG:
  #     - .dart/
  #     - .dartServer/
  #     - .dart-tool/
  config = mkMerge [
    {
      # Enable Dart by default when Flutter is enabled.
      modules.development.dart.enable = mkDefault cfg.flutter.enable;
    }

    (mkIf cfg.enable {
      modules = {
        users.packages = with pkgs; [ 
          cfg.package
        ];
      };
    })

    (mkIf cfg.flutter.enable {
      modules = {
        users.packages = with pkgs; [ 
          cfg.flutter.package
        ];
      };
    })
  ];
}
