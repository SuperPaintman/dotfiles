#
# Osier.
#

{ config, pkgs, lib, ... }:

let
  mkDockerVolumeText = name: path: text: let
    file = pkgs.writeText name text;
  in
    "${file}:${path}:ro";

  mkDockerVolumeJSON = name: path: attrs: mkDockerVolumeText name path (builtins.toJSON attrs);

  mkDockerVolumeYAML = mkDockerVolumeJSON;

  mkDockerUser = user: group: "${builtins.toString user.uid}:${builtins.toString group.gid}";
in

{
  # Imports.
  imports = [
    ./hardware-configuration.nix
  ];

  # Boot.
  # Use the extlinux boot loader. (NixOS wants to enable GRUB by default)
  boot.loader.grub.enable = false;
  # Enables the generation of /boot/extlinux/extlinux.conf
  boot.loader.generic-extlinux-compatible.enable = true;
  boot.cleanTmpDir = true; # Delete all files in `/tmp` during boot.

  # Networking.
  networking.hostName = "osier";
  networking.networkmanager.enable = true;
  # networking.wireless.enable = true;

  # Firewall.
  networking.firewall = {
    enable = true;
    # allowedTCPPorts = [ ... ];
    # allowedUDPPorts = [ ... ];

    # See: https://github.com/NixOS/nixpkgs/blob/nixos-20.09/nixos/modules/services/networking/firewall.nix
    extraCommands = let
      localNetwork = {
        subnet = "192.168.1.0/24";
      };

      allowedTCPPorts = [
        # Extra accept SSH ports in local networks.
        22

        # Pi-hole.
        53
        8081

        # Prometheus.
        9090
      ];

      allowedUDPPorts = [
        # Extra accept SSH ports in local networks.
        22

        # Pi-hole.
        53
      ];

      mkRules = subnet: protocol: ports:
        lib.concatMapStringsSep
          "\n"
          (port: "iptables -A nixos-fw -s ${subnet} -p ${protocol} --dport ${builtins.toString port} -j nixos-fw-accept")
          ports;
    in ''
      ${mkRules localNetwork.subnet "tcp" allowedTCPPorts}
      ${mkRules localNetwork.subnet "udp" allowedUDPPorts}
    '';
  };

  # Set your time zone.
  time.timeZone = "Europe/London";

  # Users.
  users.users.root = {
    openssh.authorizedKeys.keyFiles = []
      ++ lib.optional (builtins.pathExists ./id_rsa.cashapona.pub) ./id_rsa.cashapona.pub;
  };

  users.users.superpaintman = {
    isNormalUser = true;
    uid = 1000;
    extraGroups = [ "wheel" ];
    openssh.authorizedKeys.keyFiles = []
      ++ lib.optional (builtins.pathExists ./id_rsa.cashapona.pub) ./id_rsa.cashapona.pub;
  };

  users.groups.prometheus.gid = config.ids.gids.prometheus;
  users.users.prometheus = {
    description = "Prometheus daemon user";
    uid = config.ids.uids.prometheus;
    group = "prometheus";
  };

  # Environment.
  environment.systemPackages = with pkgs; [
    vim
    wirelesstools
  ];

  # OpenSSH.
  services.openssh = {
    enable = true;
    openFirewall = false;
    passwordAuthentication = false;
  };

  # Virtualisation.
  virtualisation.docker.enable = true;

  virtualisation.oci-containers = {
    backend = "docker";

    containers = {
      pihole = {
        image = "pihole/pihole:latest";
        autoStart = true;
        environment = {
          TZ = config.time.timeZone;
        };
        ports = [
          "53:53/tcp"
          "53:53/udp"
          "8081:80/tcp"
        ];
        volumes = [
          "/var/lib/pihole:/etc/pihole"
          "/var/lib/pihole-dnsmasq.d:/etc/dnsmasq.d"
        ];
        extraOptions = [
          "--cpus=2"
          "--memory=512m"
        ];
      };

      prometheus = {
        image = "prom/prometheus:latest";
        autoStart = true;
        user = mkDockerUser config.users.users.prometheus config.users.groups.prometheus;
        ports = [
          "9090:9090/tcp"
        ];
        volumes = [
          "/var/lib/prometheus:/prometheus"
          (mkDockerVolumeYAML "prometheus.yml" "/etc/prometheus/prometheus.yml" {
            global = {
              scrape_interval = "15s";
              evaluation_interval = "15s";
            };
          })
        ];
        extraOptions = [
          "--cpus=2"
          "--memory=512m"
        ];
      };
    };
  };

  # Systemd.
  systemd.services = {
    docker-prometheus = {
      preStart = ''
        mkdir -p /var/lib/prometheus
        chown ${mkDockerUser config.users.users.prometheus config.users.groups.prometheus} /var/lib/prometheus
      '';
    };
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "22.11"; # Did you read the comment?
}
