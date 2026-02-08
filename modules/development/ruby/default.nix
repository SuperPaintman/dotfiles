{ pkgs, config, lib, ... }:

with lib;

let
  cfg = config.modules.development.ruby;

  IRBRC = "$XDG_CONFIG_HOME/irb/irbrc";
in

{
  # Options.
  options.modules.development.ruby = with types; {
    enable = mkOption {
      type = bool;
      default = false;
      description = ''
        Whenever to enable Ruby.
      '';
    };

    package = mkOption {
      type = package;
      default = pkgs.ruby;
      defaultText = literalExpression "pkgs.ruby";
      description = ''
        The Ruby package to use.
      '';
    };
  };

  # Config.
  config = mkIf cfg.enable {
    modules = {
      users.packages = with pkgs; [ 
        cfg.package
      ];

      shell.variables = {
        inherit IRBRC;
      };

      home.configFiles = {
        "irb/irbrc".text = ''
          IRB.conf[:HISTORY_FILE] = File.join(
            ENV['XDG_STATE_HOME'] || File.join(ENV['HOME'], '.local', 'state'),
            'irb',
            'history'
          )
          IRB.conf[:SAVE_HISTORY] = 2000

          require 'fileutils'
          FileUtils.mkdir_p(File.dirname(IRB.conf[:HISTORY_FILE]))
        '';
      };
    };
  };
}
