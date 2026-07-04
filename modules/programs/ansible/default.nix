#
#     ansible-config view
#     ansible-config dump
#
# See: https://docs.ansible.com/projects/ansible/latest/reference_appendices/config.html

{ config, lib, pkgs, ... }:

with lib;

let
  inherit (config.modules.home) standalone;
  cfg = config.modules.programs.ansible;

  mkBin = package: name: if standalone then name else "${package}/bin/${name}";

  toAnsibleINI = generators.toINI {
    mkKeyValue = let
      mkValueString' = generators.mkValueStringDefault { };
    in generators.mkKeyValueDefault {
      mkValueString = v:
        if v == true then "True"
        else if v == false then "False"
        else mkValueString' v;
    } " = ";
  };

  ANSIBLE_CONFIG = "$XDG_CONFIG_HOME/ansible.cfg";
  ANSIBLE_HOME = "$XDG_STATE_HOME/ansible";
  ANSIBLE_INVENTORY = "$XDG_CONFIG_HOME/ansible/hosts";
in

{
  # Options.
  options.modules.programs.ansible = with types; {
    enable = mkOption {
      type = bool;
      default = false;
      description = ''
        Whenever to configure `ansible`.
      '';
    };

    package = mkOption {
      type = package;
      default = pkgs.ansible;
      defaultText = literalExpression "pkgs.ansible";
      description = ''
        The ansible package to use.
      '';
    };

    config = mkOption {
      type = attrsOf (attrsOf anything);
      default = {};
    };
  };

  # Config.
  config = mkMerge [
    {
      modules.programs.ansible.config = let
        mkDefaultAll = attrs: mapAttrs
          (name: value: if isAttrs value then mkDefaultAll value else mkDefault value)
          attrs;
      in mkDefaultAll rec {
        defaults = {
          # The default root path for Ansible config files on the controller.
          # Default: ~/.ansible
          home = ANSIBLE_HOME;

          collections_path = "$XDG_DATA_HOME/ansible/collections"; # "${defaults.home}/collections";
          roles_path = "$XDG_DATA_HOME/ansible/roles"; # "${defaults.home}/roles";

          local_tmp = "$XDG_CACHE_HOME/ansible/tmp"; # "${defaults.home}/tmp";

          become_plugins = "$XDG_DATA_HOME/ansible/plugins/become"; # "${defaults.home}/plugins/become";
          action_plugins = "$XDG_DATA_HOME/ansible/plugins/action"; # "${defaults.home}/plugins/action";
          cache_plugins = "$XDG_DATA_HOME/ansible/plugins/cache"; # "${defaults.home}/plugins/cache";
          callback_plugins = "$XDG_DATA_HOME/ansible/plugins/callback"; # "${defaults.home}/plugins/callback";
          cliconf_plugins = "$XDG_DATA_HOME/ansible/plugins/cliconf"; # "${defaults.home}/plugins/cliconf";
          connection_plugins = "$XDG_DATA_HOME/ansible/plugins/connection"; # "${defaults.home}/plugins/connection";
          filter_plugins = "$XDG_DATA_HOME/ansible/plugins/filter"; # "${defaults.home}/plugins/filter";
          httpapi_plugins = "$XDG_DATA_HOME/ansible/plugins/httpapi"; # "${defaults.home}/plugins/httpapi";
          inventory_plugins = "$XDG_DATA_HOME/ansible/plugins/inventory"; # "${defaults.home}/plugins/inventory";
          lookup_plugins = "$XDG_DATA_HOME/ansible/plugins/lookup"; # "${defaults.home}/plugins/lookup";
          library = "$XDG_DATA_HOME/ansible/plugins/modules"; # "${defaults.home}/plugins/modules";
          module_utils = "$XDG_DATA_HOME/ansible/plugins/module_utils"; # "${defaults.home}/plugins/module_utils";
          netconf_plugins = "$XDG_DATA_HOME/ansible/plugins/netconf"; # "${defaults.home}/plugins/netconf";
          strategy_plugins = "$XDG_DATA_HOME/ansible/plugins/strategy"; # "${defaults.home}/plugins/strategy";
          terminal_plugins = "$XDG_DATA_HOME/ansible/plugins/terminal"; # "${defaults.home}/plugins/terminal";
          test_plugins = "$XDG_DATA_HOME/ansible/plugins/test"; # "${defaults.home}/plugins/test";
          vars_plugins = "$XDG_DATA_HOME/ansible/plugins/vars"; # "${defaults.home}/plugins/vars";
          doc_fragment_plugins = "$XDG_DATA_HOME/ansible/plugins/doc_fragments"; # "${defaults.home}/plugins/doc_fragments";

          # File to which Ansible will log on the controller. When not set the 
          # logging is disabled.
          log_path = "${defaults.home}/ansible.log";

          # Comma-separated list of Ansible inventory sources
          inventory = ANSIBLE_INVENTORY;

          # Defines connection or path information for the fact cache plugin.
          fact_caching_connection = "$XDG_CACHE_HOME/ansible/facts";

          # Chooses which fact cache plugin to use. By default, no cache is
          # used and facts do not persist between runs.
          # Default: memory
          # See: https://docs.ansible.com/projects/ansible/latest/plugins/cache.html
          fact_caching = "jsonfile";

          # Maximum number of forks Ansible will use to execute tasks on target
          # hosts.
          # Default: 5
          forks = 10;

          # This setting controls the default policy of fact gathering (facts
          # discovered about remote systems). This option can be useful for
          # those wishing to save fact gathering time.
          # Both ‘smart’ and ‘explicit’ will use the cache plugin.
          #
          # smart: each new host that has no facts discovered will be scanned,
          # but if the same host is addressed in multiple plays it will not 
          # be contacted again in the run.
          gathering = "smart";

          # Set the main callback used to display Ansible output. You can only 
          # have one at a time. You can have many other callbacks, but just one
          # can be in charge of stdout.
          #
          # $ ansible-doc -t callback -l
          stdout_callback = "community.general.yaml"; # "yaml";

          # Controls whether callback plugins are loaded when running
          # /usr/bin/ansible. This may be used to log activity from the command
          # line, send notifications, and so on. Callback plugins are always 
          # loaded for ansible-playbook.
          bin_ansible_callbacks = true;

          # This is a global option, each connection plugin can override either
          # by having more specific options or not supporting pipelining at all.
          # Pipelining, if supported by the connection plugin, reduces the 
          # number of network operations required to execute a module on the
          # remote server, by executing many Ansible modules without actual
          # file transfer.
          #
          # It can result in a very significant performance improvement when
          # enabled.
          pipelining = true;
        };

        galaxy = {
          cache_dir = "$XDG_CACHE_HOME/ansible/galaxy_cache"; # "${defaults.home}/galaxy_cache";
          # token_path = "${defaults.home}/galaxy_token";
        };

        persistent_connection = {
          control_path_dir = "$XDG_CACHE_HOME/ansible/cp"; # "${defaults.home}/cp";
        };

        ssh_connection = {
          inherit (defaults) pipelining;
        };
      };
    }

    (mkIf cfg.enable rec {
      modules = {
        users.packages = [ cfg.package ];

        shell.variables = {
          inherit
            ANSIBLE_CONFIG
            ANSIBLE_HOME
            ANSIBLE_INVENTORY;
        };

        home.files = {
          ".ansible.cfg".source = { xdg }: pkgs.runCommandLocal ".ansible.cfg" { } ''ln -s ${xdg.configHome}/ansible.cfg $out'';
        };
        home.configFiles = {
          "ansible.cfg".text = toAnsibleINI cfg.config;
        };
      };
    })
  ];
}
