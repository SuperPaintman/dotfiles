--------------------------------------------------------------------------------
-- Init
--------------------------------------------------------------------------------
local M = {}

local HOME = vim.env.HOME or ""

--------------------------------------------------------------------------------
-- Helpers
--------------------------------------------------------------------------------
---@return table
local function get_default_client_capabilities()
  -- Default vim capabilities.
  local capabilities = vim.lsp.protocol.make_client_capabilities()

  -- Completion capabilities.
  local ok, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
  if ok then
    capabilities = vim.tbl_deep_extend(
      "force",
      capabilities,
      cmp_nvim_lsp.default_capabilities()
    )
  end

  return capabilities
end

local function patch_gdscript_documentation(content)
  local result = {}
  local lines = vim.split(content, "\n")

  local last_empty_line = false
  local in_codeblock = false

  local process = function(line)
    -- Ignore codeblocks.
    if line == "`codeblocks`" or line == "`/codeblocks`" then
      return
    end

    -- GDScript
    if line == "`gdscript`" then
      table.insert(result, "```gdscript")
      return
    end
    if line == "`/gdscript`" then
      table.insert(result, "```")
      return
    end

    -- C#
    if line == "`csharp`" then
      table.insert(result, "```csharp")
      return
    end
    if line == "`/csharp`" then
      table.insert(result, "```")
      return
    end

    -- Detect code blocks.
    if string.match(line, "^\t") then
      if not in_codeblock then
        table.insert(result, "```gdscript")
      end
      line = string.gsub(line, "^\t", "")
      table.insert(result, line)
      in_codeblock = true
      return
    elseif in_codeblock then
      table.insert(result, "```")
      in_codeblock = false
    end

    -- Trim extra newlines.
    if not in_codeblock and line == "" then
      if last_empty_line then
        return
      end

      last_empty_line = true
      table.insert(result, line)
      return
    end

    last_empty_line = false
    table.insert(result, line)
  end

  for _, line in ipairs(lines) do
    process(line)
  end

  -- Close the final code block.
  if in_codeblock then
    table.insert(result, "```")
  end

  return table.concat(result, "\n")
end

local function gdscript_hover_handler(err, result, ctx, config)
  if err == nil and result.contents and result.contents.kind == "markdown" then
    -- Patch the documentation.
    result.contents.value = patch_gdscript_documentation(result.contents.value)
  end

  return vim.lsp.handlers["textDocument/hover"](err, result, ctx, config)
end

--------------------------------------------------------------------------------
-- Modules
--------------------------------------------------------------------------------
M.config = function()
  local lspconfig = require("lspconfig")

  local capabilities = get_default_client_capabilities()
  local function create_on_attach(opts)
    opts = vim.tbl_deep_extend("force", {
      semantic = true,
    }, opts or {})

    local function create_on_attach_lsp_signature()
      local ok, lsp_signature = pcall(require, "lsp_signature")
      if not ok then
        return function(_client, bufnr) end
      end

      return function(_client, bufnr)
        lsp_signature.on_attach({}, bufnr)
      end
    end

    local on_attach_lsp_signature = create_on_attach_lsp_signature()

    local function on_attach(client, bufnr)
      -- Disable semantic tokents.
      if not opts.semantic then
        client.server_capabilities.semanticTokensProvider = {}
      end

      -- Enable LSP signatures. We don't need to check the capabilities,
      -- lsp_signature does it for us.
      on_attach_lsp_signature(client, bufnr)
    end

    return on_attach
  end

  -- C / C++
  local clangd_default_cmd =
    require("lspconfig.server_configurations.clangd").default_config.cmd[1]
  lspconfig.clangd.setup({
    cmd = { clangd_default_cmd, "--background-index" },
    capabilities = capabilities,
    on_attach = create_on_attach({}),
  })

  -- C#
  lspconfig.omnisharp.setup({
    capabilities = capabilities,
    on_attach = create_on_attach({ semantic = false }),
    handlers = {
      ["textDocument/definition"] = require("omnisharp_extended").handler,
    },
  })

  -- GDscript
  lspconfig.gdscript.setup({
    capabilities = capabilities,
    on_attach = create_on_attach({}),
    handlers = {
      ["textDocument/hover"] = gdscript_hover_handler,
    },
  })

  -- CSS
  lspconfig.cssls.setup({
    capabilities = capabilities,
    on_attach = create_on_attach({}),
  })

  -- Go
  lspconfig.gopls.setup({
    capabilities = capabilities,
    on_attach = create_on_attach({}),

    -- See: https://github.com/golang/tools/blob/master/gopls/doc/settings.md
    settings = {
      gopls = {
        -- See: https://github.com/golang/tools/blob/master/gopls/doc/analyzers.md
        analyses = {
          unusedparams = true,
          unusedwrite = true,
        },
      },
    },
  })

  -- HTML
  lspconfig.html.setup({
    capabilities = capabilities,
    on_attach = create_on_attach({}),
  })

  -- JSON
  lspconfig.jsonls.setup({
    capabilities = capabilities,
    on_attach = create_on_attach({}),
  })

  -- Lua
  local lua_ls_blacklist_runtime_files = {
    -- Avoid duplicates with the dotfiles.
    [vim.fs.normalize(HOME .. "/.config/nvim")] = true,
  }

  lspconfig.lua_ls.setup({
    capabilities = capabilities,
    on_attach = create_on_attach({ semantic = false }),

    -- See: https://github.com/LuaLS/lua-language-server/wiki/Settings
    settings = {
      Lua = {
        runtime = {
          version = "LuaJIT",
        },
        diagnostics = {
          globals = { "vim" },
        },
        workspace = {
          -- Disable "Do you need to configure your work environment as".
          checkThirdParty = false,
          library = vim.tbl_filter(function(file)
            return not lua_ls_blacklist_runtime_files[file]
          end, vim.api.nvim_get_runtime_file("", true)),
        },
        semantic = {
          enable = false,

          -- Disable highlightning for type annotations.
          annotation = false,

          -- Disable highlightning for variables, fields, and parameters.
          variable = false,
        },
        telemetry = {
          enable = false,
        },
      },
    },
  })

  -- Nix
  lspconfig.rnix.setup({
    capabilities = capabilities,
    on_attach = create_on_attach({}),
  })

  -- Rust
  lspconfig.rust_analyzer.setup({
    capabilities = capabilities,
    on_attach = create_on_attach({}),

    -- See: https://rust-analyzer.github.io/manual.html#configuration
    settings = {
      ["rust-analyzer"] = {
        check = {
          command = "clippy",
        },
      },
    },
  })

  -- TOML
  lspconfig.taplo.setup({
    capabilities = capabilities,
    on_attach = create_on_attach({}),
  })
end

--------------------------------------------------------------------------------
-- Export
--------------------------------------------------------------------------------
return M
