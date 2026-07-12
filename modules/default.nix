{ config, options, lib, ... }:

with lib;

let
  cfg = config.modules;

  replaceHomeEnv' = replacement: str:
    if hasPrefix "$HOME/" str then replacement + removePrefix "$HOME/" str
    else if hasPrefix "\${HOME}/" str then replacement + removePrefix "\${HOME}/" str
    else str;

  replaceHomeEnv = replacement: replaceHomeEnv' (replacement + "/");

  removeHomeEnv = replaceHomeEnv' "";

  normalizeHome = name: replaceHomeEnv config.home-manager.users.${name}.home.homeDirectory;
in

{
  # Imports.
  imports = [
    ./lib.nix

    ./themes

    ./xsession.nix

    ./programs/alacritty
    ./programs/ansible
    ./programs/bat
    ./programs/discord
    ./programs/essential
    ./programs/firefox
    ./programs/fzf
    ./programs/git
    ./programs/kubernetes
    ./programs/lf
    ./programs/neofetch
    ./programs/neovim
    ./programs/rofi
    ./programs/tmux

    ./development/cc
    ./development/dart
    ./development/essential
    ./development/go
    ./development/javascript
    ./development/lua
    ./development/protobuf
    ./development/python
    ./development/ruby
    ./development/rust
    ./development/zig

    ./shell
    ./shell/bash
    ./shell/zsh
  ];

  # Options.
  options.modules = with types; {
    xdg = {
      cacheHome = mkOption {
        type = str;
        defaultText = "~/.cache";
        default = "$HOME/.cache";
        apply = toString;
        description = ''
          Absolute path to directory holding application caches.

          Sets `XDG_CACHE_HOME` for the user.
        '';
      };

      configHome = mkOption {
        type = str;
        defaultText = "~/.config";
        default = "$HOME/.config";
        apply = toString;
        description = ''
          Absolute path to directory holding application configurations.

          Sets `XDG_CONFIG_HOME` for the user.
        '';
      };

      dataHome = mkOption {
        type = str;
        defaultText = "~/.local/share";
        default = "$HOME/.local/share";
        apply = toString;
        description = ''
          Absolute path to directory holding application data.

          Sets `XDG_DATA_HOME` for the user.
        '';
      };

      stateHome = mkOption {
        type = str;
        defaultText = "~/.local/state";
        default = "$HOME/.local/state";
        apply = toString;
        description = ''
          Absolute path to directory holding application states.

          Sets `XDG_STATE_HOME` for the user.
        '';
      };

      # Non-standard XDG dirs.
      fakeHome = mkOption {
        type = str;
        defaultText = "~/.local/user";
        default = "$HOME/.local/user";
        apply = toString;
        description = ''
          Absolute path to directory holding fake user home.

          Sets `XDG_FAKE_HOME` for the user.
        '';
      };
    };

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

      fakeFiles = mkOption {
        type = attrs;
        default = { };
        description = ''
          The set of files to link into the user's XDG fake home.
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

      users = let 
        isFile = v:
          isFunction v
          || (isAttrs v
          && (
            (v ? text && (isFunction v.text || isString v.text))
            || (v ? source && (isFunction v.source || isPath v.source || isDerivation v.source))
          ));

        filterMapFiles = path: pred: f: v: let
          walk = filterMapFiles;
          fullPred = _: e: (!(isFile e)) || (pred e);
        in
          if isAttrs v then
            if v ? _type then
              if v._type == "merge" then
                v // { contents = filterMapFiles "${path}.contents" pred f v.contents; }
              else
                assert assertMsg false "${path} unexpected _type in attrs: ${v._type}";
                v
            else if isFile v then
              f v
            else
              mapAttrs (n: filterMapFiles "${path}.${builtins.toJSON n}" pred f) (filterAttrs fullPred v)
          else if isList v then
            imap0 (i: filterMapFiles "${path}[${toString i}]" pred f) (ifilter0 fullPred v)
          else if isFunction v then
            f v
          else
            assert assertMsg false "${path} unexpected type of value: ${typeOf v}";
            v;

        mapFiles = path: f: filterMapFiles path (_: true) f;

        # filterFiles = path: pred: filterMapFiles path pred id;

        applyFiles = path: username: let 
          args = { 
            inherit username;
            home = config.home-manager.users.${username}.home.homeDirectory;
            xdg = {
              cacheHome = normalizeHome username cfg.xdg.cacheHome;
              configHome = normalizeHome username cfg.xdg.configHome;
              dataHome = normalizeHome username cfg.xdg.dataHome;
              stateHome = normalizeHome username cfg.xdg.stateHome;
              fakeHome = normalizeHome username cfg.xdg.fakeHome;
            };
          };
          apply = f: f (intersectAttrs (functionArgs f) args);
        in mapFiles
          path
          (f:
            if isFunction f then
              apply f
            else
              f
              // optionalAttrs (f ? source && isFunction f.source) { source = apply f.source; }
              // optionalAttrs (f ? text && isFunction f.text) { text = apply f.text; }
          );
      in mkMerge [
        # XDG.
        (mapAttrs'
          (name: _: nameValuePair cfg.users.users.${name}.name {
            xdg = {
              enable = true;
              cacheHome = normalizeHome name cfg.xdg.cacheHome;
              configHome = normalizeHome name cfg.xdg.configHome;
              dataHome = normalizeHome name cfg.xdg.dataHome;
              stateHome = normalizeHome name cfg.xdg.stateHome;
            };
          })
          cfg.users.users)

        # Files and XDG files.
        (mapAttrs'
          (name: _: nameValuePair cfg.users.users.${name}.name {
            home = {
              file = mkAliasAndWrapDefinitions (applyFiles "modules.home.files" name) options.modules.home.files;
              activation = mkAliasDefinitions options.modules.home.activation;
              stateVersion = config.system.stateVersion;
            };
            xdg = {
              configFile = mkAliasAndWrapDefinitions (applyFiles "modules.home.configFiles" name) options.modules.home.configFiles;
              # cacheFile = mkAliasAndWrapDefinitions (applyFiles "modules.home.cacheFiles" name) options.modules.home.cacheFiles;
              dataFile = mkAliasAndWrapDefinitions (applyFiles "modules.home.dataFiles" name) options.modules.home.dataFiles;
              # stateFile = mkAliasAndWrapDefinitions (applyFiles "modules.home.stateFiles" name) options.modules.home.stateFiles;
            };
          })
          cfg.users.users)

        # Non-standard XDG files: XDG_FAKE_HOME
        (mapAttrs'
          (name: _: nameValuePair cfg.users.users.${name}.name {
            home = {
              file = mapAttrs'
                (k: v: nameValuePair "${removeHomeEnv cfg.xdg.fakeHome}/${k}" v)
                ((applyFiles "modules.home.fakeFiles" name) cfg.home.fakeFiles);
            };
          })
          cfg.users.users)
      ];
    };

    # Environment.
    environment.variables = mkAliasDefinitions options.modules.environment.variables;

    # Global environment variables.
    environment.sessionVariables = {
      XDG_CACHE_HOME = cfg.xdg.cacheHome;
      XDG_CONFIG_HOME = cfg.xdg.configHome;
      XDG_DATA_HOME = cfg.xdg.dataHome;
      XDG_STATE_HOME = cfg.xdg.stateHome;

      # Non-standard XDG dirs.
      XDG_FAKE_HOME = cfg.xdg.fakeHome;

      # See: https://github.com/Homebrew/brew/blob/master/docs/Analytics.md#opting-out
      HOMEBREW_NO_ANALYTICS = "1";
    };
  };
}
