# See: https://k9scli.io/topics/config/
# See: https://k9scli.io/topics/aliases/
# See: https://k9scli.io/topics/hotkeys/
# See: https://k9scli.io/topics/plugins/
# See: https://k9scli.io/topics/columns/
# See: https://k9scli.io/topics/skins/
{ config, lib, libx, pkgs, ... }:

with lib;

let
  inherit (libx.colors) toHEXColor;
  inherit (config.modules.home) standalone;
  inherit (config.modules.themes) theme;
  cfg = config.modules.programs.kubernetes;

  mkBin = package: name: if standalone then name else "${package}/bin/${name}";

  yaml = pkgs.formats.yaml { };

  KUBECTL_EXTERNAL_DIFF = mkBin pkgs.difftastic "difft";
in

{
  # Options.
  options.modules.programs.kubernetes = with types; {
    kubectl = {
      enable = mkOption {
        type = bool;
        default = false;
        description = ''
          Whenever to enable kubectl.
        '';
      };

      package = mkOption {
        type = package;
        default = pkgs.kubectl;
        defaultText = literalExpression "pkgs.kubectl";
        description = ''
          The kubectl package to use.
        '';
      };
    };

    k9s = {
      enable = mkOption {
        type = bool;
        default = false;
        description = ''
          Whenever to enable k9s.
        '';
      };

      package = mkOption {
        type = package;
        default = pkgs.k9s;
        defaultText = literalExpression "pkgs.k9s";
        description = ''
          The k9s package to use.
        '';
      };
    };
  };

  # Config.
  config = mkMerge [
    (mkIf (cfg.kubectl.enable || cfg.k9s.enable) {
      modules = {
        shell.variables = {
          inherit KUBECTL_EXTERNAL_DIFF;
        };
      };
    })

    (mkIf cfg.kubectl.enable {
      modules = {
        users.packages = [ cfg.kubectl.package ];
      };
    })

    (mkIf cfg.k9s.enable {
      modules = {
        users.packages = [ 
          # See: https://github.com/derailed/k9s/issues/3722
          (libx.builders.mkForceEnvsWrapper { TERM = "screen-256color"; } cfg.k9s.package)
        ];

        home.configFiles = {
          "k9s/config.yaml".source = yaml.generate "k9s-config.yaml" {
            k9s = {
              # Enable periodic refresh of resource browser windows. Default false
              liveViewAutoRefresh = false;
              # Represents ui poll intervals in seconds. Default 2secs
              refreshRate = 2;
              # Overrides the default k8s api server requests timeout. Defaults 120s
              apiServerTimeout = "15s";
              # Number of retries once the connection to the api-server is lost. Default 15.
              maxConnRetry = 5;
              # Specifies if modification commands like delete/kill/edit are disabled. Default is false
              readOnly = false;
              # This setting allows users to specify the default view, but it is not set by default.
              defaultView = "";
              # Toggles whether k9s should exit when CTRL-C is pressed. When set to true, you will need to exist k9s via the :quit command. Default is false.
              noExitOnCtrlC = false;
              # Default port forward host
              portForwardAddress = "localhost";

              ui = {
                # Enable mouse support. Default false
                enableMouse = false;
                # Set to true to hide K9s header. Default false
                headless = false;
                # Set to true to hide K9s logo. Default false
                logoless = true;
                # Set to true to hide K9s crumbs. Default false
                crumbsless = false;
                # Toggles reactive UI. This option provide for watching on disk
                # artifacts changes and update the UI live  Defaults to false.
                reactive = false;
                # Toggles icons display as not all terminal support these
                # chars. Default: true
                noIcons = false;

                # skin = "superpaintman";
              };

              # Toggles whether k9s should check for the latest revision from
              # the Github repository releases. Default is false.
              skipLatestRevCheck = true;

              # Disable count pods while in node view. Default is false.
              disablePodCounting = false;

              # ShellPod configuration applies to all your clusters
              shellPod = {
                # The shell pod image to use.
                image = "busybox:1.35.0";
                # The namespace to launch to shell pod into.
                namespace = "default";
                # The resource limit to set on the shell pod.
                limits.cpu = "100m";
                limits.memory = "100Mi";
                # Enable TTY
                tty = true;
              };

              imageScans = {
                enable = false;
              };

              logger = {
                # Defines the number of lines to return. Default 100
                tail = 100;
                # Defines the total number of log lines to allow in the view.
                # Default 1000
                buffer = 5000;
                # Represents how far to go back in the log timeline in seconds.
                # Setting to -1 will tail logs. Default is -1.
                sinceSeconds = 10 * 60;
                # Go full screen while displaying logs. Default false
                fullScreen = false;
                # Toggles log line wrap. Default false
                textWrap = true;
                # Toggles log line timestamp info. Default false
                showTime = true;
              };

              # Global memory/cpu thresholds. When set will alert when thresholds are met.
              thresholds = {
                cpu.warn = 70;
                cpu.critical = 90;

                memory.warn = 70;
                memory.critical = 90;
              };
            };
          };

          "k9s/aliases.yaml".source = yaml.generate "k9s-aliases.yaml" {
            aliases = {
              # Default aliases.
              # dp = "deployments";
              # sec = "v1/secrets";
              # jo = "jobs";
              # cr = "clusterroles";
              # crb = "clusterrolebindings";
              # ro = "roles";
              # rb = "rolebindings";
              # np = "networkpolicies";
            };
          };

          "k9s/hotkeys.yaml".source = yaml.generate "k9s-hotkeys.yaml" {
            hotKeys = {
            };
          };

          "k9s/plugins.yaml".source = yaml.generate "k9s-plugins.yaml" {
            plugins = {
            };
          };

          "k9s/views.yaml".source = let
            mkColumn = name: { 
              field ? null,
              align ? null,
              hide ? false,
            }: let
              field' = if field != null then ":${field}" else "";

              attributes = []
                ++ optional hide "H"
                ++ optional (align == "left") "L"
                ++ optional (align == "right") "R"
                ;
              attributes' = concatStringsSep "" attributes;
              attributes'' = if stringLength attributes' > 0 then "|${attributes'}" else "";
            in "${name}${field'}${attributes''}";

            mkColumns = map (column: if isString column then column else mkColumn column.name (removeAttrs column ["name"]));

            label = l: ".metadata.labels.${escape ["." "/"] l}";
          in yaml.generate "k9s-views.yaml" {
            views = {
              "v1/pods" = {
                sortColumn = "AGE:asc";
                columns = mkColumns [
                  "NAMESPACE"
                  "NAME"
                  "PF"
                  { name = "VERSION"; field = label "app.kubernetes.io/version"; align = "right"; }
                  { name = "READY"; align = "right"; }
                  "STATUS"
                  "RESTARTS"
                  "CPU"
                  { name = "MEM"; align = "right"; }
                  { name = "%CPU/R"; align = "right"; }
                  { name = "%CPU/L"; align = "right"; }
                  { name = "%MEM/R"; align = "right"; }
                  { name = "%MEM/L"; align = "right"; }
                  { name = "IP"; hide = true; }
                  "NODE"
                  { name = "AGE"; align = "right"; }
                ];
              };

              "apps/v1/deployments" = {
                sortColumn = "NAME:asc";
                columns = mkColumns [
                  "NAMESPACE"
                  "NAME"
                  { name = "VERSION"; field = label "app.kubernetes.io/version"; align = "right"; }
                  { name = "READY"; align = "right"; }
                  { name = "UP-TO-DATE"; align = "right"; }
                  { name = "AVAILABLE"; align = "right"; }
                  { name = "AGE"; align = "right"; }
                ];
              };

              "apps/v1/statefulsets" = {
                sortColumn = "NAME:asc";
                columns = mkColumns [
                  "NAMESPACE"
                  "NAME"
                  { name = "VERSION"; field = label "app.kubernetes.io/version"; align = "right"; }
                  { name = "READY"; align = "right"; }
                  "SERVICE"
                  { name = "AGE"; align = "right"; }
                ];
              };

              "apps/v1/daemonsets" = {
                sortColumn = "NAME:asc";
                columns = mkColumns [
                  "NAMESPACE"
                  "NAME"
                  { name = "VERSION"; field = label "app.kubernetes.io/version"; align = "right"; }
                  { name = "DESIRED"; align = "right"; }
                  { name = "CURRENT"; align = "right"; }
                  { name = "READY"; align = "right"; }
                  { name = "UP-TO-DATE"; align = "right"; }
                  { name = "AVAILABLE"; align = "right"; }
                  { name = "AGE"; align = "right"; }
                ];
              };

              "v1/namespaces" = {
                sortColumn = "NAME:asc";
                columns = mkColumns [
                  "NAME"
                  "STATUS"
                  { name = "AGE"; align = "right"; }
                ];
              };
            };
          };

          # See: https://github.com/derailed/k9s/blob/master/skins/one-dark.yaml
          "k9s/skins/superpaintman.yaml".source = yaml.generate "k9s-skins-superpaintman.yaml" {
            k9s = {
              # General K9s styles.
              body = {
                fgColor = toHEXColor theme.colors.foreground.color;
                bgColor = toHEXColor theme.colors.base2.color;
                logoColor = toHEXColor theme.colors.blue.color;
              };

              prompt = {
                fgColor = toHEXColor theme.colors.foreground.color;
                bgColor = toHEXColor theme.colors.base2.color;
                suggestColor = toHEXColor theme.colors.base6.color;
              };

              # ClusterInfoView styles.
              info = {
                fgColor = toHEXColor theme.colors.blue.color;
                sectionColor = toHEXColor theme.colors.foreground.color;
              };

              help = {
                fgColor = toHEXColor theme.colors.foreground.color;
                bgColor = toHEXColor theme.colors.background.color;
                keyColor = toHEXColor theme.colors.blue.color;
                numKeyColor = toHEXColor theme.colors.magenta.color;
                sectionColor = toHEXColor theme.colors.magenta.color;
              };

              dialog = {
                fgColor = toHEXColor theme.colors.foreground.color;
                bgColor = toHEXColor theme.colors.base2.color;
                buttonFgColor = toHEXColor theme.colors.foreground.color;
                buttonBgColor = toHEXColor theme.colors.base3.color;
                buttonFocusFgColor = toHEXColor theme.colors.base2.color;
                buttonFocusBgColor = toHEXColor theme.colors.blue.color;
                labelFgColor = toHEXColor theme.colors.blue.color;
                fieldFgColor = toHEXColor theme.colors.foreground.color;
              };

              # Frame styles.
              frame = {
                # Borders styles.
                border = {
                  fgColor = toHEXColor theme.colors.base2.color;
                  focusColor = toHEXColor theme.colors.blue.color;
                };

                # MenuView attributes and styles.
                menu = {
                  fgColor = toHEXColor theme.colors.foreground.color;
                  keyColor = toHEXColor theme.colors.blue.color;
                  # Used for favorite namespaces
                  numKeyColor = toHEXColor theme.colors.magenta.color;
                };

                # CrumbView attributes for history navigation.
                crumbs = {
                  fgColor = toHEXColor theme.colors.foreground.color;
                  bgColor = toHEXColor theme.colors.base3.color;
                  activeColor = toHEXColor theme.colors.base4.color;
                };

                # Resource status and update styles.
                status = {
                  # newColor = "#00ff00";
                  # modifyColor = "powderblue";
                  # addColor = "lightskyblue";
                  # errorColor = "indianred";
                  # highlightcolor = "royalblue";
                  # killColor = "slategray";
                  # completedColor = "gray";
                };

                # Border title styles.
                title = {
                  fgColor = toHEXColor theme.colors.blue.color;
                  bgColor = toHEXColor theme.colors.background.color;
                  highlightColor = toHEXColor theme.colors.foreground.color;
                  counterColor = toHEXColor theme.colors.foreground.color;
                  filterColor = toHEXColor theme.colors.foreground.color;
                };
              };

              # Specific views styles.
              views = {
                # TableView attributes.
                table = {
                  fgColor = toHEXColor theme.colors.foreground.color;
                  bgColor = toHEXColor theme.colors.background.color;
                  cursorFgColor = toHEXColor theme.colors.base2.color;
                  cursorBgColor = toHEXColor theme.colors.base5.color;

                  # Header row styles.
                  header = {
                    fgColor = toHEXColor theme.colors.magenta.color;
                    bgColor = toHEXColor theme.colors.background.color;
                    sorterColor = toHEXColor theme.colors.foreground.color;
                  };
                };

                # YAML info styles.
                yaml = {
                  keyColor = toHEXColor theme.colors.magenta.color;
                  colonColor = toHEXColor theme.colors.foreground.color;
                  valueColor = toHEXColor theme.colors.green.color;
                };

                # Logs styles.
                logs = {
                  # fgColor = "white";
                  # bgColor = "black";
                };
              };
            };
          };
        };
      };
    })
  ];
}
