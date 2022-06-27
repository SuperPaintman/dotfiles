# See: https://github.com/NixOS/nixpkgs/blob/master/nixos/modules/services/network-filesystems/glusterfs.nix
# See: https://github.com/NixOS/nixpkgs/blob/master/nixos/modules/services/networking/ghostunnel.nix.

{ config, lib, pkgs, ... }:

with lib;
let
  cfg = config.services.rclone;

  escapePath = path:
    if lib.hasPrefix "~" path
    then "\"$HOME\"" + (lib.escapeShellArg (lib.substring (lib.stringLength "~") (lib.stringLength path) path))
    else lib.escapeShellArg path;

  userModule = { config, name, ... }: {
    options = {
      mounts = mkOption {
        type = types.attrsOf (types.submodule mountModule);
        default = { };
      };
    };
  };

  mountModule = { config, name, ... }: {
    options = {
      logLevel = mkOption {
        type = types.nullOr types.str;
        default = "INFO";
      };

      umask = mkOption {
        type = types.nullOr types.str;
        default = "077";
      };

      remote = mkOption {
        type = types.str;
        default = name;
      };

      path = mkOption {
        type = types.str;
        default = "";
      };

      mountPoint = mkOption {
        type = types.str;
      };
    };
  };

  service = username: name: cfg: {
    enable = true;

    description = "Rclone Mount: ${username}: ${name}";

    after = [ "network.target" ];

    wantedBy = [ "multi-user.target" ];

    path = [
      pkgs.utillinux # mountpoint
      "/run/wrappers"
    ];

    # See: https://gist.github.com/kabili207/2cd2d637e5c7617411a666d8d7e97101
    # See: https://forum.rclone.org/t/rclone-mount-doesnt-work-as-a-systemd-service/19349
    serviceConfig = {
      # Type = "notify";
      User = username;
      WorkingDirectory = "~";
      ExecStart =
        let
          flags = optional (cfg.logLevel != null) "--log-level=${lib.escapeShellArg cfg.logLevel}"
            ++ optional (cfg.umask != null) "--umask=${lib.escapeShellArg cfg.umask}";

          args = flags
            ++ [
            "${lib.escapeShellArg cfg.remote}:${builtins.toJSON cfg.path}"
            (escapePath cfg.mountPoint)
          ];

          wrapUmask = script:
            if cfg.umask == null
            then script
            else ''(umask ${cfg.umask} && ${script})'';
        in
        pkgs.writeShellScript "rclone-mount-${username}-${name}-start" ''
          set -e
          set -u
          set -o pipefail

          if mountpoint -q ${escapePath cfg.mountPoint}; then
            {
              echo "${lib.escapeShellArg cfg.mountPoint} is already in use."
              echo ""
              echo "Check if this path is already used by another program:"
              echo ""
              echo "    ${lib.escapeShellArg ("mountpoint " + cfg.mountPoint)}"
              echo ""
              echo "    Or"
              echo ""
              echo "    mount | grep rclone"
              echo ""
              echo "Otherwise you can try to fix it with ${lib.escapeShellArg ("fusermount -u " + cfg.mountPoint)}"
            } >&2
            exit 1
          fi

          ${wrapUmask "mkdir -p ${escapePath cfg.mountPoint}"}

          ${cfg.package}/bin/rclone mount ${lib.concatStringsSep " " args}
        '';
      ExecStop = pkgs.writeShellScript "rclone-mount-${username}-${name}-stop" ''
        set -e
        set -u
        set -o pipefail

        if mountpoint -q ${escapePath cfg.mountPoint}; then
          fusermount -u ${escapePath cfg.mountPoint}
        fi

        # if [ -d ${escapePath cfg.mountPoint} ]; then
        #   rm -r ${escapePath cfg.mountPoint}
        # fi
      '';
      Restart = "on-failure";
      RestartSec = 60;
    };
  };
in
{
  options.services.rclone = {
    enable = mkEnableOption "Rclone Mount Daemon";

    package = mkOption {
      type = types.package;
      default = pkgs.rclone;
      defaultText = literalExpression "pkgs.rclone";
      example = literalExpression "pkgs.rclone";
      description = ''
        rclone package to use.
      '';
    };

    users = mkOption {
      type = types.attrsOf (types.submodule userModule);
      default = { };
    };
  };

  config = mkIf cfg.enable {
    users.users = lib.mapAttrs (name: _: { packages = [ cfg.package ]; }) cfg.users;

    systemd.services = lib.listToAttrs (lib.flatten (
      lib.mapAttrsToList
        (username: userCfg:
          lib.mapAttrsToList
            (name: subCfg: {
              name = "rclone-mount-${username}-${name}";
              value = service username name (cfg // userCfg // subCfg);
            })
            userCfg.mounts
        )
        cfg.users
    ));
  };
}
