{ pkgs, config, lib, libx, ... }:

with lib;

let
  inherit (config.modules.home) standalone;
  cfg = config.modules.development.javascript;

  mkBin = package: name: if standalone then name else "${package}/bin/${name}";

  # See: https://nodejs.org/download/release/v4.7.1/docs/api/repl.html#repl_environment_variable_options
  NODE_REPL_HISTORY = "$XDG_STATE_HOME/node/repl_history"; # Default: ~/.node_repl_history
  NODE_REPL_HISTORY_SIZE = 2000; # Default: 1000

  # See: https://docs.npmjs.com/cli/v8/using-npm/config#npmrc-files
  NPM_CONFIG_USERCONFIG = "$XDG_CONFIG_HOME/npm/npmrc";

  # See: https://classic.yarnpkg.com/lang/en/docs/cli/cache/
  YARN_CACHE_FOLDER = "$XDG_CACHE_HOME/yarn";
in

{
  # Options.
  options.modules.development.javascript = with types; {
    enable = mkOption {
      type = bool;
      default = false;
      description = ''
        Whenever to enable JavaScript.
      '';
    };

    nodejs.package = mkOption {
      type = package;
      default = pkgs.nodejs;
      defaultText = literalExpression "pkgs.nodejs";
      description = ''
        The Node.js package to use.
      '';
    };

    # See: https://docs.npmjs.com/cli/v9/using-npm/config
    npm.config = mkOption {
      type = attrsOf anything;
      default = {};
    };

    yarn.package = mkOption {
      type = package;
      default = pkgs.yarn;
      defaultText = literalExpression "pkgs.yarn";
      description = ''
        The Yarn package to use.
      '';
    };

    yarn.config = mkOption {
      type = attrsOf anything;
      default = {};
    };

    prettier.package = mkOption {
      type = package;
      default = pkgs.nodePackages.prettier;
      defaultText = literalExpression "pkgs.nodePackages.prettier";
      description = ''
        The Prettier package to use.
      '';
    };

    # See: https://prettier.io/docs/en/options.html
    # See: https://prettier.io/docs/en/configuration.html
    prettier.config = mkOption {
      type = attrsOf anything;
      default = {};
    };
  };

  # Config.
  config = mkMerge [
    {
      modules.development.javascript = let 
        mkDefaultAll = attrs: mapAttrs
          (name: value: if isAttrs value then mkDefaultAll value else mkDefault value)
          attrs;
      in {
        npm.config = mkDefaultAll {
          # The location of npm's cache directory.
          "cache" = "\${XDG_CACHE_HOME}/npm";

          # The location to install global items. If set on the command line,
          # then it forces non-global commands to run in the specified folder.
          "prefix" = "\${XDG_DATA_HOME}/npm";

          # Configure how versions of packages installed to a package.json file
          # via --save or --save-dev get prefixed.
          "save-prefix" = ""; # Default: "^"

          # TODO(SuperPaintman): maybe move it into global config?
          "init.author.name" = "SuperPaintman";
          "init.author.email" = "SuperPaintmanDeveloper@gmail.com";
          "init.version" = "0.1.0";
          "init.license" = "MIT";

          # When set to true, npm will display a progress bar during time
          # intensive operations, if process.stderr is a TTY.
          "progress" = false;

          # Save installed packages to a package.json file as dependencies.
          "save" = true;
        };

        yarn.config = mkDefaultAll {
          # "cache-folder" = "\${XDG_CACHE_HOME}/yarn";
          # "cache-folder" = "~/.cache/yarn";

          # "global-folder" = "\${XDG_DATA_HOME}/yarn/global";
          # "global-folder" = "~/.local/share/yarn/global";

          "save-prefix" = cfg.npm.config."save-prefix";

          "init-author-name" = cfg.npm.config."init.author.name";
          "init-author-email" = cfg.npm.config."init.author.email";
          "init-version" = cfg.npm.config."init.version";
          "init-license" = cfg.npm.config."init.license";

          "no-progress" = !cfg.npm.config."progress";
          "strict-semver" = true;
          "ignore-scripts" = true;
        };

        prettier.config = mkDefaultAll {
          printWidth = 80;
          tabWidth = 2;
          useTabs = false;
          semi = true;
          singleQuote = true;
          quoteProps = "as-needed";
          jsxSingleQuote = true;
          trailingComma = "none";
          bracketSpacing = true;
          jsxBracketSameLine = true;
          arrowParens = "always";
          overrides = [
            # YAML
            {
              files = flatten [
                (pipe {
                  mainExt = [ ".yml" ".yaml" ];
                  templateExt = [ "" ".j2" ".hbs" ];
                } [
                  cartesianProduct
                  (map ({ mainExt, templateExt }: [
                    "*${mainExt}${templateExt}"
                    ".*${mainExt}${templateExt}"
                  ]))
                ])
              ];
              options = {
                tabWidth = 4;
                singleQuote = false;
              };
            }
          ];
        };
      };
    }

    (mkIf cfg.enable {
      modules = {
        users.packages = with pkgs; [ 
          cfg.nodejs.package
          cfg.yarn.package

          cfg.prettier.package
        ];

        shell.variables = {
          inherit 
            NODE_REPL_HISTORY
            NODE_REPL_HISTORY_SIZE
            NPM_CONFIG_USERCONFIG
            YARN_CACHE_FOLDER
            ;

          PATH = mkAfter [ "${cfg.npm.config.prefix}/bin" ];
        };

        shell.aliases = {
          npx = "${mkBin cfg.nodejs.package "npx"} --no-install";

          yarn = concatStringsSep " " [
            (mkBin cfg.yarn.package "yarn")
            "--use-yarnrc" "\"\${XDG_CONFIG_HOME}/yarn/config\""
            "--cache-folder" "\"${YARN_CACHE_FOLDER}\""
          ];
        };

        home.configFiles = {
          "npm/npmrc".text = generators.toKeyValue { } cfg.npm.config;

          "yarn/config".text = generators.toKeyValue {
            mkKeyValue = k: v: let
              mkValueString = v:
                if isString v then
                  ''"${replaceStrings [ "\n" "	" ''"'' "\\" ] [ "\\n" "\\t" ''\"'' "\\\\" ] v}"''
                else if v == true then
                  "true"
                else if v == false then
                  "false"
                else if v == null then
                  "null"
                else
                  toString v;
            in ''${k} ${mkValueString v}'';
          } cfg.yarn.config;
        };

        home.files = {
          # TODO(SuperPaintman): remove this once migrated to new Bash / ZSH.
          ".npmrc" = config.modules.home.configFiles."npm/npmrc";
          ".yarnrc" = config.modules.home.configFiles."yarn/config";

          # NOTE(SuperPaintman): 
          #     Unfortunately Prettier don't respect XDG paths.
          #     Prettier just goes up the path until it finds a config.
          ".prettierrc.yaml".text = generators.toYAML { } cfg.prettier.config;
        };

        home.activation.nodeXDGDirs = ''
          if [ ! -d "$XDG_STATE_HOME/node" ]; then
            mkdir "$XDG_STATE_HOME/node"
          fi
        '';
      };
    })
  ];
}
