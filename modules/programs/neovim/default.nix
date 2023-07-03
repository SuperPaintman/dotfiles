# See: https://github.com/nix-community/home-manager/blob/master/modules/programs/neovim.nix

{ config, lib, pkgs, ... }:

with lib;

let
  inherit (builtins) toJSON;
  inherit (pkgs) stdenv;

  cfg = config.modules.programs.neovim;
  standalone = config.modules.home.standalone;

  trimNewlines = content:
    let
      lines = splitString "\n" content;

      trim = lines:
        if length lines > 0 && head lines == "" then trim (tail lines)
        else lines;
    in
    concatStringsSep "\n" (reverseList (trim (reverseList (trim lines))));

  indent' = ind: lines:
    map
      (line: "${ind}${line}")
      lines;

  indent = ind: content:
    let
      lines = indent' ind (splitString "\n" content);
    in
    concatStringsSep "\n" lines;

  mkRawLua = content: { _type = "rawLua"; inherit content; };

  toLua = v:
    let
      formatTable = fields:
        "{\n" + (concatStringsSep "\n" fields) + "\n}";

      attrsToLuaValue = attrs:
        let
          fields = mapAttrsToList
            (key: value: indent "  " "${key} = ${toLuaValue value},")
            attrs;
        in
        formatTable fields;

      listToLuaValue = list:
        let
          fields = map
            (value: indent "  " "${toLuaValue value},")
            list;
        in
        formatTable fields;

      toLuaValue = v:
        if v ? _type && v._type == "rawLua" then trimNewlines v.content
        else if v == null then "nil"
        else if isDerivation v then toJSON v
        else if isPath v then toJSON v
        else if isAttrs v then attrsToLuaValue v
        else if isList v then listToLuaValue v
        else toJSON v;
    in
    toLuaValue v;

  # See: https://github.com/folke/lazy.nvim#-plugin-spec
  isPluginEnabled = { enabled ? null, ... }: enabled != false;

  filterPlugins = filter isPluginEnabled;

  formatPlugin =
    { plugin ? null
    , dir ? null
    , url ? null
    , name ? null
    , dev ? null
    , lazy ? null
    , enabled ? null
    , cond ? null
    , dependencies ? null
    , init ? null
    , opts ? null
    , config ? null
    , main ? null
    , build ? null
    , branch ? null
    , tag ? null
    , commit ? null
    , version ? null
    , pin ? true
    , submodules ? null
    , event ? null
    , cmd ? null
    , ft ? null
    , keys ? null
    , module ? null
    , priority ? null
    , optional ? null
    , ...
    }:
    let
      name' =
        if name != null
        then name
        else replaceStrings [ "." ] [ "-" ] (last (splitString "/" plugin));

      configWrapper = mkRawLua ''
        require_optional_config(${toLua name'}, ${toLua config})
      '';

      spec = concatStringsSep "\n" ([ ]
        ++ lib.optional (plugin != null) "${toLua plugin},"
        ++ lib.optional (dir != null) "dir = ${toLua dir},"
        ++ lib.optional (url != null) "url = ${toLua url},"
        ++ lib.optional (name != null) "name = ${toLua name},"
        ++ lib.optional (dev != null) "dev = ${toLua dev},"
        ++ lib.optional (lazy != null) "lazy = ${toLua lazy},"
        ++ lib.optional (enabled != null) "enabled = ${toLua enabled},"
        ++ lib.optional (cond != null) "cond = ${toLua cond},"
        ++ lib.optional (dependencies != null) "dependencies = ${toLua dependencies},"
        ++ lib.optional (init != null) "init = ${toLua init},"
        ++ lib.optional (opts != null) "opts = ${toLua opts},"
        ++ [ "config = ${toLua (if isBool config then config else configWrapper)}," ]
        ++ lib.optional (main != null) "main = ${toLua main},"
        ++ lib.optional (build != null) "build = ${toLua build},"
        ++ lib.optional (branch != null) "branch = ${toLua branch},"
        ++ lib.optional (tag != null) "tag = ${toLua tag},"
        ++ lib.optional (commit != null) "commit = ${toLua commit},"
        ++ lib.optional (version != null) "version = ${toLua version},"
        ++ lib.optional (pin != null) "pin = ${toLua pin},"
        ++ lib.optional (submodules != null) "submodules = ${toLua submodules},"
        ++ lib.optional (event != null) "event = ${toLua event},"
        ++ lib.optional (cmd != null) "cmd = ${toLua cmd},"
        ++ lib.optional (ft != null) "ft = ${toLua ft},"
        ++ lib.optional (keys != null) "keys = ${toLua keys},"
        ++ lib.optional (module != null) "module = ${toLua module},"
        ++ lib.optional (priority != null) "priority = ${toLua priority},"
        ++ lib.optional (optional != null) "optional = ${toLua optional},"
      );
    in
    "  {\n${indent "    " spec}\n  },";

  nativePlugins = pkgs.callPackage ./plugins {
    neovim = cfg.package;
  };

  plugins = [
    {
      plugin = "catppuccin/nvim";
      name = "catppuccin";
      branch = "main";
      commit = "8338b02e9a8ffcb999520de7f15943712618760f";
      version = "1.2.0";
      lazy = false;
      priority = 1000;
      config = mkRawLua ''
        function()
          vim.cmd [[ colorscheme catppuccin ]]
        end
      '';
    }

    {
      plugin = "nvim-lua/plenary.nvim";
      branch = "master";
      commit = "253d34830709d690f013daf2853a9d21ad7accab";
      version = "0.1.3";
    }

    {
      plugin = "nvim-telescope/telescope.nvim";
      branch = "master";
      commit = "776b509f80dd49d8205b9b0d94485568236d1192";
      version = "0.1.2";
      dependencies = [ "nvim-lua/plenary.nvim" ];
    }

    ((nativePlugins.nvim-treesitter.withParsers (p: with p; [
      tree-sitter-go
      tree-sitter-lua
      tree-sitter-nix
    ])).lazy.override {
      config = mkRawLua ''
        function()
        ${optionalString (!standalone) (indent "  " ''
          -- Disable compiling languages from source code.
          require("nvim-treesitter.install").compilers = {
            -- Alternatively, you can enable the compilers here.
            -- ${toLua "${stdenv.cc}/bin/cc"}
          }
        '')}

        ${optionalString standalone (indent "  " ''
          -- Configure the plugin.
          require("nvim-treesitter.configs").setup {
            ensure_installed = {
              "go",
              "lua",
              "nix",
            },
          }
        '')}
        end
      '';
    })
  ];
in

{
  # Options.
  options.modules.programs.neovim = with types; {
    enable = mkOption {
      type = bool;
      default = false;
      description = mdDoc ''
        Whenever to configure `neovim`.
      '';
    };

    package = mkOption {
      type = package;
      default = pkgs.neovim;
      defaultText = literalExpression "pkgs.neovim";
      description = mdDoc ''
        The neovim package to use.
      '';
    };
  };

  # Config.
  config = mkIf cfg.enable {
    modules = {
      users.packages = [ cfg.package ];

      home.configFiles = {
        "nvim/init.lua".source = ./init.lua;
        "nvim/lua/options.lua".source = ./lua/options.lua;
        "nvim/lua/mappings.lua".source = ./lua/mappings.lua;
        "nvim/lua/configs" = {
          source = ./lua/configs;
          recursive = true;
        };
        "nvim/lua/utils" = {
          source = ./lua/utils;
          recursive = true;
        };
        "nvim/lua/lazyinit.lua".text = ''
          --------------------------------------------------------------------------------
          -- Imports
          --------------------------------------------------------------------------------
          local is_available = require("utils.modules").is_available


          --------------------------------------------------------------------------------
          -- Init
          --------------------------------------------------------------------------------
          vim.opt.rtp:prepend(${toLua nativePlugins.lazy-nvim})


          --------------------------------------------------------------------------------
          -- Helpers
          --------------------------------------------------------------------------------
          local require_optional_config = function(name, config)
            return function(plugin, opts)
              opts = opts or {}

              -- Run the inline configuration.
              if config ~= nil then
                config(plugin, opts)
              end

              -- Run the configuration from file.
              if is_available("configs." .. name) then
                local mod = require("configs." .. name)
                if mod and type(mod.config) == "function" then
                  mod.config(plugin, opts)
                end
                return
              end

              -- Run the default configuration.
              local main = require("lazy.core.loader").get_main(plugin)
              if main and is_available(main) then
                local mod = require(main)
                if mod and type(mod.config) == "function" then
                  mod.setup(opts)
                end
              end
            end
          end


          --------------------------------------------------------------------------------
          -- Setup
          --------------------------------------------------------------------------------
          require("lazy").setup({
          ${concatMapStringsSep "\n" formatPlugin (filterPlugins plugins)}
          }, {})
        '';
      };
    };
  };
}
