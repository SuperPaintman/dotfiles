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

        # Loki.
        3100

        # Promtail.
        9080

        # Nginx.
        80
        443

        # Home Assistant.
        8123

        # Alertmanager.
        9093
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

  users.groups.loki.gid = 331;
  users.users.loki = {
    description = "Loki daemon user";
    uid = 331;
    group = "loki";
  };

  users.groups.promtail.gid = 332;
  users.users.promtail = {
    description = "Promtail daemon user";
    uid = 332;
    group = "promtail";
    extraGroups = [ "systemd-journal" ];
  };

  users.groups.alertmanager.gid = 333;
  users.users.alertmanager = {
    description = "Alertmanager daemon user";
    uid = 333;
    group = "alertmanager";
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

          (mkDockerVolumeText "pihole-custom.list" "/etc/pihole/custom.list" ''
            # Osier.
            192.168.1.16 local
            192.168.1.16 pihole.local
            192.168.1.16 prometheus.local
            192.168.1.16 grafana.local
            192.168.1.16 promtail.local
            192.168.1.16 home.local
            192.168.1.16 alertmanager.local

            # UniFi Dream Router.
            192.168.1.1 unifi.local
          '')
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
        cmd = [
          "--config.file=/etc/prometheus/prometheus.yml"
          "--storage.tsdb.path=/prometheus"
          "--storage.tsdb.retention.time=1y"
          "--storage.tsdb.retention.size=32GB"
          "--web.console.libraries=/usr/share/prometheus/console_libraries"
          "--web.console.templates=/usr/share/prometheus/consoles"
        ];
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
                job_name = "prometheus";
                static_configs = [
                  {
                    targets = [ "prometheus:9090" ];
                    labels.instance = "osier";
                  }
                ];
              }

              {
                job_name = "grafana";
                static_configs = [
                  {
                    targets = [ "grafana:3000" ];
                    labels.instance = "osier";
                  }
                ];
              }

              {
                job_name = "loki";
                static_configs = [
                  {
                    targets = [ "loki:3100" ];
                    labels.instance = "osier";
                  }
                ];
              }

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

            alerting = {
              alertmanagers = [
                {
                  static_configs = [
                    {
                      targets = [ "alertmanager:9093" ];
                      labels.instance = "osier";
                    }
                  ];
                }
              ];
            };

            rule_files = [
              "/etc/prometheus/rules.yml"
            ];
          })

          # See: https://prometheus.io/docs/prometheus/latest/configuration/alerting_rules/
          # See: https://awesome-prometheus-alerts.grep.to/rules.html
          (mkDockerVolumeYAML "alert-rules.yml" "/etc/prometheus/rules.yml" {
            # TODO(SuperPaintman): add a nice template.
            groups = [
              {
                name = "node";
                rules = with lib; let
                  threshold = 50; # TODO(SuperPaintman): add more thresholds.
                in [
                  {
                    alert = "HostOutOfDiskSpace";
                    expr = ''
                      (
                        100
                        -
                        (
                          (node_filesystem_avail_bytes{mountpoint="/",fstype!="rootfs"} * 100)
                          /
                          node_filesystem_size_bytes{mountpoint="/",fstype!="rootfs"}
                        )
                      )
                      > ${toString threshold}
                    '';
                    for = "5m";
                    labels = {
                      severity = "warning";
                    };
                    annotations = {
                      summary = "Host out of disk space (>${toString threshold}%)";
                      description = ''
                        Disk is almost full ({{ $value }}%)
                      '';
                    };
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

      loki = {
        image = "grafana/loki:latest";
        autoStart = true;
        user = mkDockerUser config.users.users.loki config.users.groups.loki;
        dependsOn = []
          ++ lib.optional (config.systemd.services ? "docker-network-${dockerNetworkName}") "network-${dockerNetworkName}";
        ports = [
          "3100:3100/tcp"
        ];
        volumes = [
          "/var/lib/loki:/loki"

          # See: https://grafana.com/docs/loki/latest/configuration/
          # See: https://raw.githubusercontent.com/grafana/loki/main/cmd/loki/loki-local-config.yaml
          # See: https://raw.githubusercontent.com/grafana/loki/blob/main/cmd/loki/loki-docker-config.yaml
          (mkDockerVolumeYAML "loki.yaml" "/etc/loki/local-config.yaml" {
            auth_enabled = false;

            server.http_listen_port = 3100;
            # server.grpc_listen_port = 9096;

            common = {
              path_prefix = "/loki";
              storage.filesystem = {
                chunks_directory = "/loki/chunks";
                rules_directory = "/loki/rules";
              };
              replication_factor = 1;
              ring.kvstore.store = "inmemory";
            };

            schema_config.configs = [
              {
                from = "2020-10-24";
                store = "boltdb-shipper";
                object_store = "filesystem";
                schema = "v11";
                index = {
                  prefix = "index_";
                  period = "24h";
                };
              }
            ];

            compactor = {
              shared_store = "filesystem";
              retention_enabled = true;
            };

            limits_config.retention_period = "1y";

            # ruler.alertmanager_url = "http://localhost:9093";

            # By default, Loki will send anonymous, but uniquely-identifiable usage and configuration
            # analytics to Grafana Labs. These statistics are sent to https://stats.grafana.org/
            #
            # Statistics help us better understand how Loki is used, and they show us performance
            # levels for most users. This helps us prioritize features and documentation.
            # For more information on what's sent, look at
            # https://github.com/grafana/loki/blob/main/pkg/usagestats/stats.go
            # Refer to the buildReport method to see what goes into a report.
            #
            # If you would like to disable reporting, uncomment the following lines:
            analytics.reporting_enabled = false;
          })
        ];
        extraOptions = [
          "--cpus=2"
          "--memory=512m"
        ]
          ++ lib.optional (config.systemd.services ? "docker-network-${dockerNetworkName}") "--network=${dockerNetworkName}";
      };

      promtail = {
        image = "grafana/promtail:latest";
        autoStart = true;
        user = mkDockerUser config.users.users.promtail config.users.groups.promtail;
        dependsOn = []
          ++ lib.optional (config.systemd.services ? "docker-network-${dockerNetworkName}") "network-${dockerNetworkName}";
        ports = [
          "9080:9080/tcp"
        ];
        volumes = [
          "/var/lib/promtail:/promtail"

          "/var/log/journal:/var/log/journal:ro"
          "/run/log/journal:/run/log/journal:ro"
          "/etc/machine-id:/etc/machine-id:ro"

          # See: https://grafana.com/docs/loki/latest/clients/promtail/configuration/
          # See: https://raw.githubusercontent.com/grafana/loki/main/clients/cmd/promtail/promtail-journal.yaml
          # See: https://raw.githubusercontent.com/grafana/loki/main/clients/cmd/promtail/promtail-docker-config.yaml
          (mkDockerVolumeYAML "promtail.yml" "/etc/promtail/config.yml" {
            server.http_listen_port = 9080;

            positions.filename = "/promtail/positions.yaml";

            clients = [
              {
                url = "http://loki:3100/loki/api/v1/push";
              }
            ];

            # See: https://grafana.com/docs/loki/latest/clients/promtail/scraping/
            scrape_configs = [
              {
                job_name = "journal";

                journal = {
                  max_age = "24h";
                  labels.job = "systemd-journal";
                };

                relabel_configs = [
                  {
                    source_labels = [ "__journal__systemd_unit" ];
                    target_label = "unit";
                  }
                  {
                    source_labels = [ "__journal__hostname" ];
                    target_label = "hostname";
                  }
                  {
                    source_labels = [ "__journal_container_name" ];
                    target_label = "container";
                  }
                ];

                # See: https://grafana.com/docs/loki/latest/clients/promtail/pipelines/
                # See: https://grafana.com/docs/loki/latest/clients/promtail/stages/
                pipeline_stages = let
                  containerNames = builtins.attrNames config.virtualisation.oci-containers.containers;
                  containerNamesRegex = "(${lib.concatStringsSep "|" containerNames})";
                in [
                  # Drop duplicate logs.
                  {
                    match = {
                      selector = "{unit=\"docker.service\"}";
                      stages = [
                        {
                          drop = {
                            source = "container";
                            expression = "^${containerNamesRegex}$";
                          };
                        }
                      ];
                    };
                  }

                  # Get container name from the Docker unit names.
                  {
                    match = {
                      selector = "{unit=~\"^docker-${containerNamesRegex}\\\\.service$\"}";
                      stages = [
                        {
                          regex = {
                            source = "unit";
                            expression = "^docker-(?P<container>.+)\\.service$";
                          };
                        }
                        {
                          labels.container = "container";
                        }
                      ];
                    };
                  }
                ];
              }
            ];
          })
        ];
        extraOptions = [
          "--cpus=2"
          "--memory=512m"
          "--group-add=${builtins.toString config.users.groups.systemd-journal.gid}"
        ]
          ++ lib.optional (config.systemd.services ? "docker-network-${dockerNetworkName}") "--network=${dockerNetworkName}";
      };

      nginx = {
        image = "nginx:latest";
        autoStart = true;
        dependsOn = []
          ++ lib.optional (config.systemd.services ? "docker-network-${dockerNetworkName}") "network-${dockerNetworkName}";
        ports = [
          "80:80/tcp"
          "443:443/tcp"
        ];
        volumes = let
          defaultConfig = ''
            server {
              listen 80;
              listen [::]:80;
              server_name _;

              location / {
                root /usr/share/nginx/html;
                index index.html index.htm;
              }

              # error_page 404 /404.html;

              error_page 500 502 503 504 /50x.html;
              location = /50x.html {
                root /usr/share/nginx/html;
              }
            }
          '';

          # See: https://github.com/NixOS/nixpkgs/blob/nixos-22.11/nixos/modules/services/web-servers/nginx/default.nix
          upstreams = {
            pihole.servers."pihole:80" = {};
            prometheus.servers."prometheus:9090" = {};
            grafana.servers."grafana:3000" = {};
            promtail.servers."promtail:9080" = {};
            home-assistant.servers."home-assistant:8123" = {};
            alertmanager.servers."alertmanager:9093" = {};
          };

          virtualHosts = {
            "pihole.local" = {
              locations."= /" = {
                priority = 500;
                return = "302 $scheme://$host/admin";
              };

              locations."/" = {
                proxyPass = "http://pihole";
              };
            };

            "prometheus.local" = {
              locations."/" = {
                proxyPass = "http://prometheus";
              };
            };

            "grafana.local" = {
              locations."/" = {
                proxyPass = "http://grafana";
              };
            };

            "promtail.local" = {
              locations."/" = {
                proxyPass = "http://promtail";
              };
            };

            "home.local" = {
              locations."/" = {
                proxyPass = "http://home-assistant";
              };
            };

            "alertmanager.local" = {
              locations."/" = {
                proxyPass = "http://alertmanager";
              };
            };
          };

          mkListen = { port, ... }: with lib; ''
            listen ${toString port};
          '';

          mkLocation = { location, return ? null, proxyPass ? null, ... }: with lib; ''
            location ${location} {
              ${optionalString (return != null) "return ${return};"}
              ${optionalString (proxyPass != null) "proxy_pass ${proxyPass};"}
            }
          '';

          mkLocations = locations: with lib; concatStringsSep "\n" (map mkLocation (sortProperties (mapAttrsToList (k: v: v // { location = k; }) locations)));

          upstreamConfig = with lib; concatStringsSep "\n" (flip mapAttrsToList upstreams (name: upstream: ''
            upstream ${name} {
              ${toString (flip mapAttrsToList upstream.servers (name: server: ''
                server ${name} ${optionalString (server.backup or false) "backup"};
              ''))}
              ${upstream.extraConfig or ""}
            }
          ''));

          virtualHostsConfig = with lib; concatStringsSep "\n" (flip mapAttrsToList virtualHosts (vhostName: vhost: ''
            # ${vhostName}
            server {
              ${concatMapStringsSep "\n" mkListen (vhost.listen or [{ port = 80; }])}
              server_name ${vhostName};

              ${mkLocations vhost.locations}
            }
          ''));

          # logFormat = lib.concatStringsSep "" [
          #   "$remote_addr - $remote_user [$time_local] \"$request\" "
          #   "$status $body_bytes_sent \"$http_referer\" "
          #   "\"$http_user_agent\" \"$http_x_forwarded_for\""
          # ];

          # See: https://stackoverflow.com/questions/25049667/how-to-generate-a-json-log-from-nginx
          # See: https://brandur.org/logfmt
          logFormat = lib.concatStringsSep " " (lib.mapAttrsToList
            (key: { alias ? null, escape ? false }: let
              value'' = if alias == null then key else alias;
              value' = "\$${value''}";
              value = if escape then builtins.toJSON value' else value';
            in "${key}=${value}")
            {
              host.escape = true;
              time_local.escape = true;
              remote_addr.escape = true;
              remote_user.escape = true;
              request_method.escape = true;
              server_protocol.escape = true;
              request_uri.escape = true;
              uri.escape = true;
              args.escape = true;
              status = {};
              body_bytes_sent = {};
              request_length = {};
              request_time.escape = true;
              http_referer.escape = true;
              http_user_agent.escape = true;
              http_x_forwarded_for.escape = true;
              request_id.escape = true;
            }
          );
        in [
          (mkDockerVolumeText "nginx.conf" "/etc/nginx/nginx.conf" ''
            user nginx;
            worker_processes auto;

            error_log /dev/stderr notice;
            pid /var/run/nginx.pid;

            events {
              worker_connections 1024;
            }

            http {
              # Basic Settings
              sendfile on;
              tcp_nopush on;
              tcp_nodelay on;
              keepalive_timeout 75 20;
              types_hash_max_size 2048;
              server_tokens off;
              ignore_invalid_headers on;

              # Defaults
              include /etc/nginx/mime.types;
              default_type application/octet-stream;

              # Logging
              log_format main ${builtins.toJSON logFormat};
              access_log /dev/stdout main;

              # Gzip
              gzip on;
              gzip_vary on;

              gzip_disable "MSIE [4-6]\.";
              gzip_types text/plain
                         text/css
                         application/json
                         application/x-javascript
                         text/xml
                         application/xml
                         application/xml+rss
                         text/javascript
                         application/javascript;

              # Proxy
              proxy_redirect off;
              proxy_connect_timeout 60s;
              proxy_send_timeout 60s;
              proxy_read_timeout 60s;
              proxy_http_version 1.1;

              # Proxy Headers
              proxy_set_header Host $host;
              proxy_set_header X-Real-IP $remote_addr;
              proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
              proxy_set_header X-Forwarded-Proto $scheme;
              proxy_set_header X-Forwarded-Host $host;
              proxy_set_header X-Forwarded-Server $host;

              # Request ID
              add_header X-Request-ID $request_id;
              proxy_set_header X-Request-ID $request_id;

              # Upstreams
              ${upstreamConfig}

              # Configs
              # Default Config
              ${defaultConfig}

              # Virtual Hosts
              ${virtualHostsConfig}
            }
          '')
        ];
        extraOptions = [
          "--cpus=2"
          "--memory=512m"
        ]
          ++ lib.optional (config.systemd.services ? "docker-network-${dockerNetworkName}") "--network=${dockerNetworkName}";
      };

      home-assistant = {
        image = "ghcr.io/home-assistant/home-assistant:stable";
        autoStart = true;
        environment = {
          TZ = config.time.timeZone;
        };
        dependsOn = []
          ++ lib.optional (config.systemd.services ? "docker-network-${dockerNetworkName}") "network-${dockerNetworkName}";
        ports = [
          "8123:8123/tcp"
        ];
        volumes = [
          # See: https://www.home-assistant.io/docs/configuration/
          # See: https://www.home-assistant.io/integrations/default_config/
          (mkDockerVolumeText "home-assistant-configuration.yaml" "/config/configuration.yaml" ''
            # Loads default set of integrations. Do not remove.
            default_config:

            # See: https://www.home-assistant.io/integrations/http/
            http:
              server_port: 8123
              use_x_forwarded_for: true
              trusted_proxies:
                - 10.0.0.0/16

            # Text to speech
            tts:
              - platform: google_translate
          '')
        ];
        extraOptions = [
          "--cpus=2"
          "--memory=512m"
        ]
          ++ lib.optional (config.systemd.services ? "docker-network-${dockerNetworkName}") "--network=${dockerNetworkName}";
      };

      alertmanager = {
        image = "prom/alertmanager:latest";
        autoStart = true;
        cmd = [
          "--config.file=/tmp/alertmanager-generated.yml"
          "--storage.path=/alertmanager"
        ];
        user = mkDockerUser config.users.users.alertmanager config.users.groups.alertmanager;
        dependsOn = []
          ++ lib.optional (config.systemd.services ? "docker-network-${dockerNetworkName}") "network-${dockerNetworkName}";
        entrypoint = "/custom-entry-point.sh";
        ports = [
          "9093:9093/tcp"
        ];
        environmentFiles = [
          "/secrets/alertmanager/env"
        ];
        volumes = [
          "/var/lib/alertmanager:/alertmanager"

          # Alertmanager do not support env variables in the config.
          (mkDockerEntryPoint "alertmanager-entry-point.sh" "/custom-entry-point.sh" ''
            #!/bin/sh

            set -euo pipefail

            eval "cat <<EOF
            $(cat /etc/alertmanager/alertmanager-template.yml)
            EOF
            " > /tmp/alertmanager-generated.yml

            exec /bin/alertmanager $@
          '')

          # See: https://raw.githubusercontent.com/prometheus/alertmanager/main/doc/examples/simple.yml
          # See: https://prometheus.io/docs/alerting/latest/configuration/
          # See: https://stackoverflow.com/questions/32423837/telegram-bot-how-to-get-a-group-chat-id
          (mkDockerVolumeText "alertmanager.yml" "/etc/alertmanager/alertmanager-template.yml" ''
            route:
              receiver: SuperPaintman

            receivers:
              - name: SuperPaintman
                telegram_configs:
                  - bot_token: $TELEGRAM_BOT_TOKEN
                    chat_id: $TELEGRAM_CHAT_ID
                    parse_mode: "Markdown"
                    message: '{{ template "telegram.custom.message" . }}'

            templates:
              - /etc/alertmanager/templates/telegram.tmpl
          '')

          # See: https://prometheus.io/docs/alerting/latest/notifications/
          # See: https://github.com/prometheus/alertmanager/blob/main/template/default.tmpl
          # See: https://hodovi.cc/blog/creating-awesome-alertmanager-templates-for-slack/
          (mkDockerVolumeText "alertmanager-telegram.tmpl" "/etc/alertmanager/templates/telegram.tmpl" (builtins.readFile ./alertmanager/telegram.tmpl))
        ];
        extraOptions = [
          "--cpus=2"
          "--memory=512m"
        ]
          ++ lib.optional (config.systemd.services ? "docker-network-${dockerNetworkName}") "--network=${dockerNetworkName}";
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

    docker-loki = {
      preStart = ''
        mkdir -p /var/lib/loki
        chown ${mkDockerUser config.users.users.loki config.users.groups.loki} /var/lib/loki
      '';
    };

    docker-promtail = {
      preStart = ''
        mkdir -p /var/lib/promtail
        chown ${mkDockerUser config.users.users.promtail config.users.groups.promtail} /var/lib/promtail
      '';
    };

    docker-alertmanager = {
      preStart = ''
        mkdir -p /var/lib/alertmanager
        chown ${mkDockerUser config.users.users.alertmanager config.users.groups.alertmanager} /var/lib/alertmanager

        (umask 077 && mkdir -p /secrets/alertmanager)
        chmod 700 /secrets/alertmanager
        chown ${mkDockerUser config.users.users.alertmanager config.users.groups.alertmanager} /secrets/alertmanager

        if [ ! -f /secrets/alertmanager/env ]; then
          (umask 077 && touch /secrets/alertmanager/env)
          echo "TELEGRAM_BOT_TOKEN=" > /secrets/alertmanager/env
          echo "TELEGRAM_CHAT_ID=" >> /secrets/alertmanager/env
        fi
        chmod 0400 /secrets/alertmanager/env
        chown ${mkDockerUser config.users.users.alertmanager config.users.groups.alertmanager} /secrets/alertmanager/env
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
