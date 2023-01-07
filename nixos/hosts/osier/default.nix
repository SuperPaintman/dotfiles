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

  mkDockerVolumeINI = name: path: options: attrs: mkDockerVolumeText name path (lib.generators.toINI options attrs);

  mkDockerUser = user: group: "${builtins.toString user.uid}:${builtins.toString group.gid}";

  mkDockerEntryPoint = name: path: text: let
    file = pkgs.writeScript name text;
  in
    "${file}:${path}:ro";

  dockerNetworkName = "trusted";
in

{
  # Imports.
  imports = [
    ./hardware-configuration.nix
  ];

  # Swap.
  swapDevices = []
    ++ lib.optional (builtins.pathExists /swapfile) ({
      device = "/swapfile";
    });

  system.activationScripts.create-swapfile.text = let
    swapSize = 2 * 1024 * 1024 * 1024; # 2G
    bs = 1024;
  in ''
    if ${pkgs.procps}/bin/free | ${pkgs.gawk}/bin/awk '/^Swap:/ {exit !!$2}'; then
      if [ ! -f /swapfile ]; then
        rm -f /swapfile
        fallocate -l ${builtins.toString swapSize} /swapfile
        dd if=/dev/zero of=/swapfile bs=${builtins.toString bs} count=${builtins.toString (swapSize / bs)}
        chmod 600 /swapfile
        mkswap /swapfile
      fi

      swapon /swapfile
    fi
  '';

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
      dockerNetwork = {
        subnet = "10.0.0.0/16";
      };

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

        # Grafana.
        3000

        # Unpoller
        9130 # Prometheus.
        # 37288 # Web server.

        # Node Exporter.
        9100
      ];

      allowedUDPPorts = [
        # Extra accept SSH ports in local networks.
        22

        # Pi-hole.
        53
      ];


      allowedDockerHostTCPPorts = [
        # Node Exporter.
        9100
      ];

      allowedDockerHostUDPPorts = [];

      mkRules = subnet: protocol: ports:
        lib.concatMapStringsSep
          "\n"
          (port: "iptables -A nixos-fw -s ${subnet} -p ${protocol} --dport ${builtins.toString port} -j nixos-fw-accept")
          ports;
    in ''
      # Local Network.
      ${mkRules localNetwork.subnet "tcp" allowedTCPPorts}
      ${mkRules localNetwork.subnet "udp" allowedUDPPorts}

      # Docker Network.
      ${mkRules dockerNetwork.subnet "tcp" allowedDockerHostTCPPorts}
      ${mkRules dockerNetwork.subnet "udp" allowedDockerHostUDPPorts}
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

  # https://github.com/NixOS/nixpkgs/blob/master/nixos/modules/misc/ids.nix.
  users.groups.prometheus.gid = config.ids.gids.prometheus;
  users.users.prometheus = {
    description = "Prometheus daemon user";
    uid = config.ids.uids.prometheus;
    group = "prometheus";
  };

  users.groups.grafana.gid = 196;
  users.users.grafana = {
    description = "Grafana daemon user";
    uid = 196;
    group = "grafana";
  };

  users.groups.unpoller.gid = 330;
  users.users.unpoller = {
    description = "Unpoller daemon user";
    uid = 330;
    group = "unpoller";
  };

  # Environment.
  environment.systemPackages = with pkgs; [
    vim
    wirelesstools
    htop
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
        dependsOn = []
          ++ lib.optional (config.systemd.services ? "docker-network-${dockerNetworkName}") "network-${dockerNetworkName}";
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
        ]
          ++ lib.optional (config.systemd.services ? "docker-network-${dockerNetworkName}") "--network=${dockerNetworkName}";
      };

      prometheus = {
        image = "prom/prometheus:latest";
        autoStart = true;
        user = mkDockerUser config.users.users.prometheus config.users.groups.prometheus;
        dependsOn = []
          ++ lib.optional (config.systemd.services ? "docker-network-${dockerNetworkName}") "network-${dockerNetworkName}";
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

            scrape_configs = [
              {
                job_name = "node";
                static_configs = [
                  {
                    targets = [ "10.0.0.1:9100" ];
                    labels.instance = "osier";
                  }

                  {
                    targets = [ "192.168.1.1:9100" ];
                    labels.instance = "unifi-dream-router";
                  }
                ];
              }

              {
                job_name = "unpoller";
                scrape_interval = "30s";
                static_configs = [
                  {
                    targets = [ "unpoller:9130" ];
                    labels.instance = "osier";
                  }
                ];
              }
            ];
          })
        ];
        extraOptions = [
          "--cpus=2"
          "--memory=512m"
        ]
          ++ lib.optional (config.systemd.services ? "docker-network-${dockerNetworkName}") "--network=${dockerNetworkName}";
      };

      grafana = {
        image = "grafana/grafana:latest";
        autoStart = true;
        user = mkDockerUser config.users.users.grafana config.users.groups.grafana;
        dependsOn = []
          ++ lib.optional (config.systemd.services ? "docker-network-${dockerNetworkName}") "network-${dockerNetworkName}";
        ports = [
          "3000:3000/tcp"
        ];
        volumes = [
          "/var/lib/grafana:/var/lib/grafana"
          # See: https://raw.githubusercontent.com/grafana/grafana/v6.7.x/conf/sample.ini
          (mkDockerVolumeINI "grafana.ini" "/etc/grafana/grafana.ini" {} {
            server = {
              protocol = "http";
            };

            analytics = {
              # Server reporting, sends usage counters to stats.grafana.org every 24 hours.
              # No ip addresses are being tracked, only simple counters to track
              # running instances, dashboard and error counts. It is very helpful to us.
              # Change this option to false to disable reporting.
              reporting_enabled = false;

              # Set to false to disable all checks to https://grafana.net
              # for new vesions (grafana itself and plugins), check is used
              # in some UI views to notify that grafana or plugin update exists
              # This option does not cause any auto updates, nor send any information
              # only a GET request to http://grafana.com to get latest versions
              check_for_updates = false;
            };

            users = {
              # disable user signup / registration
              allow_sign_up = false;

              # Allow non admin users to create organizations
              allow_org_create = false;

              # Set to true to automatically assign new users to the default organization (id 1)
              auto_assign_org = false;
            };

            explore = {
              # Enable the Explore section
              enabled = true;
            };
          })
        ];
        extraOptions = [
          "--cpus=2"
          "--memory=512m"
        ]
          ++ lib.optional (config.systemd.services ? "docker-network-${dockerNetworkName}") "--network=${dockerNetworkName}";
      };

      unpoller = {
        image = "ghcr.io/unpoller/unpoller:latest";
        autoStart = true;
        cmd = [ "--config" "/etc/unpoller/up.json" ];
        user = mkDockerUser config.users.users.unpoller config.users.groups.unpoller;
        dependsOn = []
          ++ lib.optional (config.systemd.services ? "docker-network-${dockerNetworkName}") "network-${dockerNetworkName}";
        ports = [
          "9130:9130/tcp"
          # "37288:37288/tcp"
        ];
        environmentFiles = [
          "/secrets/unpoller/env"
        ];
        volumes = [
          # "/secrets/unpoller:/secrets/unpoller:ro"

          # https://raw.githubusercontent.com/unpoller/unpoller/master/examples/up.conf.example
          (mkDockerVolumeJSON "up.json" "/etc/unpoller/up.json" {
            poller = {
              debug = false;
              quiet = false;
            };

            prometheus = {
              disable = false;
            };

            influxdb = {
              disable = true;
            };

            loki = {
              disable = true;
            };

            datadog = {
              enable = false;
            };

            webserver = {
              enable = false;
            };

            unifi.dynamic = false;
            unifi.defaults = {
              url = "https://192.168.1.1";
              # pass = "file:///secrets/unpoller/pass";
              sites = [ "all" ];
              save_sites = true;
              save_dpi = true;
              save_rogue = true;
            };
          })
        ];
        extraOptions = [
          "--cpus=2"
          "--memory=512m"
        ]
          ++ lib.optional (config.systemd.services ? "docker-network-${dockerNetworkName}") "--network=${dockerNetworkName}";
      };

      node-exporter = {
        image = "prom/node-exporter:latest";
        autoStart = true;
        cmd = [ "--path.rootfs=/host" ];
        volumes = [
          "/:/host:ro,rslave"
        ];
        extraOptions = [
          "--cpus=2"
          "--memory=512m"
          "--pid=host"
          "--network=host"
        ];
      };
    };
  };

  # Secrets.
  system.activationScripts.create-secrets-dir.text = ''
    (umask 077 && mkdir -p /secrets)
    chmod 700 /secrets
    chown root:root /secrets
  '';

  # Systemd.
  systemd.services = {
    docker-prometheus = {
      preStart = ''
        mkdir -p /var/lib/prometheus
        chown ${mkDockerUser config.users.users.prometheus config.users.groups.prometheus} /var/lib/prometheus
      '';
    };

    docker-grafana = {
      preStart = ''
        mkdir -p /var/lib/grafana
        chown ${mkDockerUser config.users.users.grafana config.users.groups.grafana} /var/lib/grafana
      '';
    };

    docker-unpoller = {
      preStart = ''
        (umask 077 && mkdir -p /secrets/unpoller)
        chmod 700 /secrets/unpoller
        chown ${mkDockerUser config.users.users.unpoller config.users.groups.unpoller} /secrets/unpoller

        if [ ! -f /secrets/unpoller/env ]; then
          (umask 077 && touch /secrets/unpoller/env)
          echo "UP_UNIFI_DEFAULT_USER=unifipoller" > /secrets/unpoller/env
          echo "UP_UNIFI_DEFAULT_PASS=unifipoller" >> /secrets/unpoller/env
        fi
        chmod 0400 /secrets/unpoller/env
        chown ${mkDockerUser config.users.users.unpoller config.users.groups.unpoller} /secrets/unpoller/env
      '';
    };
  }
    // lib.optionalAttrs (config.virtualisation.docker.enable) {
      "docker-network-${dockerNetworkName}" = {
        wantedBy = [ "multi-user.target" ];
        after = [ "docker.service" "docker.socket" ];
        path = [ pkgs.docker ];
        preStart = ''
          docker network rm ${dockerNetworkName} || true
        '';
        script = ''
          docker network create \
            --driver=bridge \
            --subnet=10.0.0.0/16 \
            ${dockerNetworkName}
        '';
        postStop = ''
          docker network rm ${dockerNetworkName} || true
        '';
        serviceConfig = {
          Type = "oneshot";
          RemainAfterExit = true;
        };
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
