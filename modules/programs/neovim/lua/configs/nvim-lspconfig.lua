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
  if
      err == nil
      and result
      and result.contents
      and result.contents.kind == "markdown"
  then
    -- Patch the documentation.
    result.contents.value = patch_gdscript_documentation(result.contents.value)
  end

  return vim.lsp.handlers["textDocument/hover"](err, result, ctx, config)
end

local function yamlls_hover_handler(err, result, ctx, config)
  if
      err == nil
      and result
      and result.contents
      and result.contents.kind == "markdown"
  then
    result.contents.value = string.gsub(result.contents.value, "&emsp;", "")
  end

  return vim.lsp.handlers["textDocument/hover"](err, result, ctx, config)
end

---@param file string
---@return string
local function local_json_schema(file)
  return vim.fs.normalize(HOME .. "/.config/nvim/jsonschemas/" .. file)
end

--------------------------------------------------------------------------------
-- Modules
--------------------------------------------------------------------------------
M.dependencies = {
  "hrsh7th/cmp-nvim-lsp",
  "ray-x/lsp_signature.nvim",
  "Hoffs/omnisharp-extended-lsp.nvim",
}

M.config = function()
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

  -- Global defaults applied to every server.
  vim.lsp.config("*", {
    capabilities = capabilities,
  })

  -- C / C++
  vim.lsp.config("clangd", {
    cmd = { "clangd", "--background-index" },
    on_attach = create_on_attach({}),
  })
  vim.lsp.enable("clangd")

  -- C#
  vim.lsp.config("omnisharp", {
    on_attach = create_on_attach({ semantic = false }),
    handlers = {
      ["textDocument/definition"] = require("omnisharp_extended").handler,
    },
  })
  -- vim.lsp.enable("omnisharp")

  -- GDscript
  vim.lsp.config("gdscript", {
    on_attach = create_on_attach({}),
    handlers = {
      ["textDocument/hover"] = gdscript_hover_handler,
    },
  })
  -- vim.lsp.enable("gdscript")

  -- CSS
  vim.lsp.config("cssls", {
    on_attach = create_on_attach({}),
  })
  vim.lsp.enable("cssls")

  -- Dhall
  vim.lsp.config("dhall_lsp_server", {
    on_attach = create_on_attach({}),
  })
  vim.lsp.enable("dhall_lsp_server")

  -- Go
  vim.lsp.config("gopls", {
    on_attach = create_on_attach({ semantic = false }),

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
  vim.lsp.enable("gopls")

  -- HTML
  vim.lsp.config("html", {
    on_attach = create_on_attach({}),
  })
  vim.lsp.enable("html")

  -- JSON
  vim.lsp.config("jsonls", {
    on_attach = create_on_attach({}),
  })
  vim.lsp.enable("jsonls")

  -- Lua
  local lua_ls_blacklist_runtime_files = {
    -- Avoid duplicates with the dotfiles.
    [vim.fs.normalize(HOME .. "/.config/nvim")] = true,
  }

  vim.lsp.config("lua_ls", {
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
  vim.lsp.enable("lua_ls")

  -- Nickel
  vim.lsp.config("nickel_ls", {
    capabilities = capabilities,
    on_attach = create_on_attach({}),
  })
  vim.lsp.enable("nickel_ls")

  -- Rust
  vim.lsp.config("rust_analyzer", {
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
  vim.lsp.enable("rust_analyzer")

  -- Svelte.
  vim.lsp.config("svelte", {
    on_attach = create_on_attach({ semantic = false }),
  })
  vim.lsp.enable("svelte")

  -- TypeScript / JavaScript.
  vim.lsp.config("ts_ls", {
    on_attach = create_on_attach({}),
  })
  vim.lsp.enable("ts_ls")

  -- Terraform.
  vim.lsp.config("terraformls", {
    on_attach = create_on_attach({ semantic = false }),
  })
  vim.lsp.enable("terraformls")

  vim.lsp.config("tflint", {
    on_attach = create_on_attach({}),
  })
  vim.lsp.enable("tflint")

  -- TOML
  vim.lsp.config("taplo", {
    on_attach = create_on_attach({}),
  })
  vim.lsp.enable("taplo")

  -- YAML
  vim.lsp.config("yamlls", {
    on_attach = create_on_attach({}),
    handlers = {
      ["textDocument/hover"] = yamlls_hover_handler,
    },

    -- See: https://github.com/redhat-developer/yaml-language-server
    settings = {
      yaml = {
        format = { enabled = false },
        validate = true,
        completion = true,
        hover = true,
        keyOrdering = false,

        chemaStore = { enable = false },
        schemas = {
          -- See: https://www.schemastore.org/json/
          --- Canonical.
          [local_json_schema("json.schemastore.org/github-workflow.json")] = ".github/workflows/*.{yml,yaml}",
          [local_json_schema("json.schemastore.org/github-action.json")] = ".github/action.{yml,yaml}",
          [local_json_schema("json.schemastore.org/dependabot-2.0.json")] = ".github/dependabot.{yml,yaml}",
          [local_json_schema(
            "github.com/compose-spec/compose-spec/schema/compose-spec.json"
          )] = "docker-compose.{yml,yaml}",

          --- Custom.
          [local_json_schema(
            "github.com/OAI/OpenAPI-Specification/schemas/v3.1/schema.json"
          )] = "spec.{yml,yaml}",
        },
      },

      -- See: https://github.com/redhat-developer/vscode-redhat-telemetry#how-to-disable-telemetry-reporting
      redhat = { telemetry = { enabled = false } },
    },
  })
  vim.lsp.enable("yamlls")

  -- Zig
  vim.lsp.config("zls", {
    on_attach = create_on_attach({ semantic = false }),
  })
  vim.lsp.enable("zls")
end

--------------------------------------------------------------------------------
-- Export
--------------------------------------------------------------------------------
return M
