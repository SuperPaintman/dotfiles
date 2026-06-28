{ pkgs, config, lib, ... }:

with lib;

let
  cfg = config.modules.development.python;

  PYTHONSTARTUP = "$XDG_CONFIG_HOME/python/pythonrc";
  PYTHONHISTFILE = "$XDG_STATE_HOME/python/python_history";
  PYTHON_HISTORY = PYTHONHISTFILE;
  PYTHON_HISTORY_SIZE = 10000; # Non-standard ENV.
  # PYTHONPYCACHEPREFIX = "$XDG_CACHE_HOME/python"; # Write `.pyc. to XDG dir instead of local `__pycache__/`
in

{
  # Options.
  options.modules.development.python = with types; {
    enable = mkOption {
      type = bool;
      default = false;
      description = ''
        Whenever to enable Python 3.
      '';
    };

    package = mkOption {
      type = package;
      default = pkgs.python3;
      defaultText = literalExpression "pkgs.python3";
      description = ''
        The Python 3 package to use.
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
        inherit
          PYTHONSTARTUP
          PYTHONHISTFILE
          PYTHON_HISTORY
          PYTHON_HISTORY_SIZE
          # PYTHONPYCACHEPREFIX
          ;
      };

      home.configFiles = {
        "python/pythonrc".source = ./pythonrc.py;
      };
    };
  };
}
