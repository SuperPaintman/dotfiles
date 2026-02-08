{ config, options, lib, ... }:

with lib;

let
  cfg = config.modules;
in

{
  # Imports.
  imports = [
    ./themes
    ./programs/alacritty
    ./programs/bat
    ./programs/essential
    ./programs/fzf
    ./programs/git
    ./programs/lf
    ./programs/neovim
    ./programs/tmux
    ./shell
    ./shell/bash
    ./shell/zsh
  ];

  # Options.
  options.modules = with types; {
    # User.
    #
    # Options and aliases for users and user-level packages.
    users = {
      users = mkOption {
        type = attrs;
        default = { };
        apply = v: mapAttrs
          (name: value: { inherit name; } // value)
          v;
        description = ''
          Additional user accounts to be created automatically by the system.
        '';
      };

      packages = mkOption {
        type = listOf package;
        default = [ ];
        description = ''
          The set of packages that should be made available to each user.
        '';
      };
    };

    # Home.
    #
    # Options and aliases for managing dotfiles (via Home Manager).
    home = {
      standalone = mkOption {
        type = bool;
        default = false;
        description = ''
          Whenever to generate all dotfiles in the standalone (portable) mode.
        '';
      };

      files = mkOption {
        type = attrs;
        default = { };
        description = ''
          The set of files to link into the user home.
        '';
      };

      configFiles = mkOption {
        type = attrs;
        default = { };
        description = ''
          The set of files to link into the user's XDG configuration home.
        '';
      };

      dataFiles = mkOption {
        type = attrs;
        default = { };
        description = ''
          The set of files to link into the user's XDG data home.
        '';
      };

      activation = mkOption {
        type = attrsOf lines;
        default = { };
        description = ''
          The activation scripts blocks to run when activating a Home Manager
          generation.
        '';
      };
    };

    # Environment.
    #
    # Options and aliases for environment.
    environment = {
      variables = mkOption {
        type = attrs;
        default = { };
        description = ''
          The set of environment variables used in the global environment.
        '';
      };
    };
  };

  # Config.
  config = {
    # Users.
    users.users = mapAttrs
      (name: user: mkMerge [
        {
          isNormalUser = true;
          uid = 1000;
          group = "users";
          extraGroups = [ "wheel" ];
          home = "/home/${user.name}";
          packages = cfg.users.packages;
        }
        user
      ])
      cfg.users.users;

    # Home.
    home-manager = {
      useUserPackages = true;

      users = mapAttrs'
        (name: _: nameValuePair cfg.users.users.${name}.name {
          home = {
            file = mkAliasDefinitions options.modules.home.files;
            activation = mkAliasDefinitions options.modules.home.activation;
            stateVersion = config.system.stateVersion;
          };
          xdg = {
            configFile = mkAliasDefinitions options.modules.home.configFiles;
            dataFile = mkAliasDefinitions options.modules.home.dataFiles;
          };
        })
        cfg.users.users;
    };

    # Environment.
    environment.variables = mkAliasDefinitions options.modules.environment.variables;

    # Global environment variables.
    environment.sessionVariables = {
      XDG_CACHE_HOME = "$HOME/.cache";
      XDG_CONFIG_HOME = "$HOME/.config";
      XDG_DATA_HOME = "$HOME/.local/share";
      XDG_STATE_HOME = "$HOME/.local/state";

      # See: https://github.com/Homebrew/brew/blob/master/docs/Analytics.md#opting-out
      HOMEBREW_NO_ANALYTICS = "1";
    };
  };
}
