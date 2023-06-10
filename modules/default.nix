{ config, options, lib, ... }:

with lib;

let
  cfg = config.modules;
in

{
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
        description = mdDoc ''
          Additional user accounts to be created automatically by the system.
        '';
      };

      packages = mkOption {
        type = listOf package;
        default = [ ];
        description = mdDoc ''
          The set of packages that should be made available to each user.
        '';
      };
    };

    # Home.
    #
    # Options and aliases for managing dotfiles (via Home Manager).
    home = {
      files = mkOption {
        type = attrs;
        default = { };
        description = mdDoc ''
          The set of files to link into the user home.
        '';
      };

      configFiles = mkOption {
        type = attrs;
        default = { };
        description = mdDoc ''
          The set of files to link into the user's XDG configuration home.
        '';
      };

      dataFiles = mkOption {
        type = attrs;
        default = { };
        description = mdDoc ''
          The set of files to link into the user's XDG data home.
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
            stateVersion = config.system.stateVersion;
          };
          xdg = {
            configFile = mkAliasDefinitions options.modules.home.configFiles;
            dataFile = mkAliasDefinitions options.modules.home.dataFiles;
          };
        })
        cfg.users.users;
    };
  };
}
