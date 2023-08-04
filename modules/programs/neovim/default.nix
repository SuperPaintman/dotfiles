# See: https://github.com/nix-community/home-manager/blob/master/modules/programs/neovim.nix

{ config, lib, pkgs, ... }:

with lib;

let
  inherit (builtins) toJSON;
  inherit (pkgs) stdenv;
  inherit (pkgs.lib.x.colors) toHEXColor;

  inherit (config.modules.home) standalone;
  inherit (config.modules.themes) theme;
  cfg = config.modules.programs.neovim;

  trimNewlines = content:
    let
      lines = splitString "\n" content;

      trim = lines:
        if length lines > 0 && head lines == "" then trim (tail lines)
        else lines;
    in
    concatStringsSep "\n" (reverseList (trim (reverseList (trim lines))));

  indent' = ind: map (line: "${ind}${line}");

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

  toLuaPalette = theme:
    let
      toLuaPaletteColor = color: toHEXColor color.color;
      toLuaPaletteColors = mapAttrs (_: toLuaPaletteColor);
    in
    {
      colors = toLuaPaletteColors theme.colors;
    };

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
        else
          pipe plugin [
            (splitString "/")
            last
            (replaceStrings [ "." ] [ "-" ])
            toLower
          ];

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

  formatLua = name: source: pkgs.runCommand name
    {
      inherit source;
      nativeBuildInputs = with pkgs; [ stylua ];
      passAsFile = [ "source" ];
      allowSubstitutes = false;
      preferLocalBuild = true;
    }
    ''
      mv "$sourcePath" "$out"
      stylua --config-path ${../../../.stylua.toml} "$out"
    '';

  nativePlugins = pkgs.callPackage ./plugins {
    neovim = cfg.package;
  };

  treesitterLanguages = [
    "bash"
    "c"
    "css"
    "diff"
    "dockerfile"
    "gitignore"
    "go"
    "html"
    "http"
    "javascript"
    "json"
    "lua"
    "luadoc"
    "make"
    "nix"
    "proto"
    "python"
    "query"
    "regex"
    "rust"
    "sql"
    "svelte"
    "terraform"
    "vim"
    "yaml"
  ];

  plugins =
    let
      p = nativePlugins;
    in
    [
      # (p.catppuccin.lazy.override {
      #   lazy = false;
      #   priority = 1000;
      #   config = mkRawLua ''
      #     function()
      #       vim.cmd([[colorscheme catppuccin]])
      #     end
      #   '';
      # })

      p.plenary-nvim.lazy

      (p.telescope-nvim.lazy.override {
        dependencies =
          if standalone
          then [
            p.plenary-nvim.lazy.plugin
          ]
          else null;
      })

      ((nativePlugins.nvim-treesitter.withParsers
        (p:
          (map (lang: p."tree-sitter-${lang}") treesitterLanguages)
          ++ [
            p.tree-sitter-format_string
          ]
        )).lazy.override {
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
            require("nvim-treesitter.configs").setup({
              ensure_installed = {
            ${concatMapStringsSep "\n" (lang: "    ${toLua lang},") treesitterLanguages}
              },
            })
          '')}
          end
        '';
      })

      p.nvim-treesitter-playground.lazy

      (p.nvim-lspconfig.lazy.override {
        init = mkRawLua ''
          function()
            vim.schedule(function()
              vim.cmd([[silent! do FileType]])
            end, 0)
          end
        '';
        config = mkRawLua ''
          function()
          ${optionalString (!standalone) (indent "  " ''
            local lspconfig = require("lspconfig")

            -- Helpers
            local patch = function(name, patch)
              local cfg = require("lspconfig.server_configurations." .. name)

              cfg.default_config = vim.tbl_extend("force", cfg.default_config, patch)
            end

            -- Go
            patch("gopls", {
              cmd = { ${toLua "${pkgs.gopls}/bin/gopls"} },
            })

            -- Lua
            patch("lua_ls", {
              cmd = { ${toLua "${pkgs.lua-language-server}/bin/lua-language-server"} },
            })

            -- Nix
            patch("rnix", {
              cmd = { ${toLua "${pkgs.rnix-lsp}/bin/rnix-lsp"} },
            })
          '')}
          end
        '';
      })

      (p.nvim-cmp.lazy.override {
        event = "InsertEnter";
        dependencies =
          if standalone
          then [
            p.cmp-nvim-lua.lazy.plugin
            p.cmp-nvim-lsp.lazy.plugin
            p.cmp-buffer.lazy.plugin
            p.cmp-path.lazy.plugin
            p.cmp_luasnip.lazy.plugin
            p.luasnip.lazy.plugin
          ]
          else null;
      })

      p.cmp-nvim-lua.lazy
      p.cmp-nvim-lsp.lazy
      p.cmp-buffer.lazy
      p.cmp-path.lazy
      p.cmp_luasnip.lazy

      p.gitsigns-nvim.lazy

      p.comment-nvim.lazy

      (p.nvim-tree-lua.lazy.override {
        dependencies =
          if standalone
          then [
            p.nvim-web-devicons.lazy.plugin
          ]
          else null;
      })

      p.which-key-nvim.lazy

      p.lualine-nvim.lazy

      p.bufferline-nvim.lazy

      (p.null-ls-nvim.lazy.override {
        config = mkRawLua ''
          function()
          ${optionalString (!standalone) (indent "  " ''
            local null_ls = require("null-ls")

            -- Helpers
            local patch = function(kind, name, patch)
              null_ls.builtins[kind][name] = null_ls.builtins[kind][name].with(patch)
            end

            -- Diagnostics
            --- cspell
            patch("diagnostics", "cspell", {
              command = ${toLua "${pkgs.nodePackages.cspell}/bin/cspell"},
            })

            --- staticcheck
            patch("diagnostics", "staticcheck", {
              command = ${toLua "${pkgs.go-tools}/bin/staticcheck"},
            })

            --- statix
            patch("diagnostics", "statix", {
              command = ${toLua "${pkgs.statix}/bin/statix"},
            })

            -- Formatting
            --- goimports
            patch("formatting", "goimports", {
              command = ${toLua "${pkgs.gotools}/bin/goimports"},
            })

            --- prettier
            patch("formatting", "prettier", {
              command = ${toLua "${pkgs.nodePackages.prettier}/bin/prettier"},
            })

            --- stylua
            patch("formatting", "stylua", {
              command = ${toLua "${pkgs.stylua}/bin/stylua"},
            })
          '')}
          end
        '';
      })

      (p.trouble-nvim.lazy.override {
        dependencies =
          if standalone
          then [
            p.nvim-web-devicons.lazy.plugin
          ]
          else null;
      })

      p.luasnip.lazy

      p.alpha-nvim.lazy

      p.nvim-web-devicons.lazy

      (p.neogit.lazy.override {
        dependencies =
          if standalone
          then [
            p.plenary-nvim.lazy.plugin
            p.diffview-nvim.lazy.plugin
          ]
          else null;
      })

      p.auto-session.lazy

      p.diffview-nvim.lazy
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
        "nvim/lua/configs" = {
          source = ./lua/configs;
          recursive = true;
        };
        "nvim/lua/core" = {
          source = ./lua/core;
          recursive = true;
        };
        "nvim/lua/modules" = {
          source = ./lua/modules;
          recursive = true;
        };
        "nvim/lua/snippets" = {
          source = ./lua/snippets;
          recursive = true;
        };
        "nvim/lua/theme/init.lua".source = ./lua/theme/init.lua;
        "nvim/lua/theme/palette.lua".source = formatLua "nvim-lua-theme-colors.lua" ''
          --------------------------------------------------------------------------------
          -- Init
          --------------------------------------------------------------------------------
          ---@class theme.palette.Module
          local M = ${toLua (toLuaPalette theme)}

          --------------------------------------------------------------------------------
          -- Export
          --------------------------------------------------------------------------------
          return M
        '';
        "nvim/lua/utils" = {
          source = ./lua/utils;
          recursive = true;
        };
        "nvim/lua/lazyinit.lua".source = formatLua "nvim-lua-lazyinit.lua" ''
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

              local run_default = true

              -- Run the inline configuration.
              if config ~= nil then
                config(plugin, opts)
                run_default = false
              end

              -- Run the configuration from file.
              if is_available("configs." .. name) then
                local mod = require("configs." .. name)
                if mod and type(mod.config) == "function" then
                  mod.config(plugin, opts)
                  run_default = false
                end
              end

              -- Run the default configuration.
              if run_default then
                local main = require("lazy.core.loader").get_main(plugin)
                if main and is_available(main) then
                  local mod = require(main)
                  if mod and type(mod.setup) == "function" then
                    mod.setup(opts)
                  end
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
        "nvim/queries" = {
          source = ./queries;
          recursive = true;
        };
      };
    };
  };
}
