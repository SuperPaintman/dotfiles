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

  mkNeovimEnv = { dependencies ? [ ] }: stdenv.mkDerivation {
    name = "neovim-env";

    dontUnpack = true;

    installPhase =
      let
        links = flatten (map
          (dep:
            if isDerivation dep
            then ''ln -s "${dep}/bin"/* "$out/bin"/''
            else
              map
                (bin: ''ln -s "${dep.package}/bin/${bin}" "$out/bin/${bin}"'')
                dep.bins
          )
          dependencies);
      in
      ''
        mkdir -p "$out/bin"

        ${concatStringsSep "\n" links}
      '';
  };

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

  formatPluginLuaLock =
    { plugin ? null
    , dir ? null
    , url ? null
    , name ? null
    , branch ? null
    , tag ? null
    , commit ? null
    , version ? null
    , pin ? true
    , submodules ? false
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
            (replaceStrings [ " " ] [ "_" ])
          ];

      spec = concatStringsSep "\n" ([ ]
        ++ lib.optional (plugin != null) "${toLua plugin},"
        ++ lib.optional (dir != null) "dir = ${toLua dir},"
        ++ lib.optional (url != null) "url = ${toLua url},"
        ++ lib.optional (name' != null) "name = ${toLua name'},"
        ++ lib.optional (branch != null) "branch = ${toLua branch},"
        ++ lib.optional (tag != null) "tag = ${toLua tag},"
        ++ lib.optional (commit != null) "commit = ${toLua commit},"
        ++ lib.optional (version != null) "version = ${toLua version},"
        ++ lib.optional (pin != null) "pin = ${toLua pin},"
        ++ lib.optional (submodules != null) "submodules = ${toLua submodules},"
      );
    in
    "  [${toLua plugin}] = {\n${indent "    " spec}\n  },";

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

  jsonschemas = pkgs.callPackage ./jsonschemas { };

  treesitterLanguages = [
    "bash"
    "c"
    "c_sharp"
    "css"
    "diff"
    "dockerfile"
    "gitignore"
    "gdscript"
    "go"
    "gomod"
    "gosum"
    "gowork"
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
      # Common libraries and utils.
      p.plenary-nvim.lazy
      p.neodev-nvim.lazy
      p.nvim-web-devicons.lazy

      # Telescope.
      p.telescope-nvim.lazy

      # TreeSitter.
      (nativePlugins.nvim-treesitter.withParsers
        (p:
          (map (lang: p."tree-sitter-${lang}") treesitterLanguages)
          ++ [
            p.tree-sitter-format_string
          ]
        )).lazy
      p.nvim-treesitter-playground.lazy
      p.nvim-treesitter-textobjects.lazy

      # LSP.
      p.nvim-lspconfig.lazy
      p.lspsaga-nvim.lazy
      p.lsp-signature-nvim.lazy
      p.omnisharp-extended-lsp-nvim.lazy
      p.null-ls-nvim.lazy

      # Completion.
      p.nvim-cmp.lazy
      p.cmp-nvim-lua.lazy
      p.cmp-nvim-lsp.lazy
      p.cmp-buffer.lazy
      p.cmp-path.lazy
      p.cmp_luasnip.lazy

      # Snippets.
      p.luasnip.lazy

      # Git.
      p.gitsigns-nvim.lazy
      p.neogit.lazy
      p.diffview-nvim.lazy

      # Editing.
      p.comment-nvim.lazy

      # Sessions.
      p.auto-session.lazy

      # UI.
      p.nvim-tree-lua.lazy
      p.which-key-nvim.lazy
      p.lualine-nvim.lazy
      p.bufferline-nvim.lazy
      p.trouble-nvim.lazy
      p.alpha-nvim.lazy # Dashboard.
    ];

  nixEnv = mkNeovimEnv {
    dependencies = with pkgs; [
      # Common.
      git

      # LSP-Config
      { package = clang-tools; bins = [ "clangd" ]; } # C / C++
      { package = omnisharp-roslyn; bins = [ "OmniSharp" ]; } # C#
      { package = nodePackages.vscode-langservers-extracted; bins = [ "vscode-css-language-server" ]; } # CSS
      { package = gopls; bins = [ "gopls" ]; } # Go
      { package = nodePackages.vscode-langservers-extracted; bins = [ "vscode-html-language-server" ]; } # HTML
      { package = nodePackages.vscode-langservers-extracted; bins = [ "vscode-json-language-server" ]; } # JSON
      { package = lua-language-server; bins = [ "lua-language-server" ]; } # Lua
      { package = rnix-lsp; bins = [ "rnix-lsp" ]; } # Nix
      { package = nixd; bins = [ "nixd" ]; } # Nix
      { package = rust-analyzer; bins = [ "rust-analyzer" ]; } # Rust
      { package = terraform-ls; bins = [ "terraform-ls" ]; } # Terraform
      { package = tflint; bins = [ "tflint" ]; } # Terraform
      { package = taplo; bins = [ "taplo" ]; } # TOML
      { package = nodePackages.yaml-language-server; bins = [ "yaml-language-server" ]; } # YAML

      # Null-ls
      { package = nodePackages.cspell; bins = [ "cspell" ]; }
      { package = gdtoolkit_4; bins = [ "gdlint" "gdformat" ]; }
      { package = go-tools; bins = [ "staticcheck" ]; }
      { package = gotools; bins = [ "goimports" ]; }
      { package = statix; bins = [ "statix" ]; }
      { package = nodePackages.prettier; bins = [ "prettier" ]; }
      { package = stylua; bins = [ "stylua" ]; }
    ];
  };
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
        "nvim/ftplugin" = {
          source = ./ftplugin;
          recursive = true;
        };
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
        "nvim/lua/lazylock.lua".source = formatLua "nvim-lua-lazylock.lua" ''
          --------------------------------------------------------------------------------
          -- Init
          --------------------------------------------------------------------------------
          vim.opt.path:prepend(${toLua "${nixEnv}/bin"})
          vim.env.PATH = ${toLua "${nixEnv}/bin"} .. ":" .. vim.env.PATH
          vim.opt.rtp:prepend(${toLua nativePlugins.lazy-nvim})

          local M = {
          ${concatMapStringsSep "\n" formatPluginLuaLock plugins}
          }


          --------------------------------------------------------------------------------
          -- Export
          --------------------------------------------------------------------------------
          return M
        '';
        "nvim/lua/lazyinit.lua".source = ./lua/lazyinit.lua;
        "nvim/queries" = {
          source = ./queries;
          recursive = true;
        };
      } // lib.optionalAttrs (!standalone) {
        "nvim/jsonschemas".source = jsonschemas;
      };
    };
  };
}
