--------------------------------------------------------------------------------
-- Imports
--------------------------------------------------------------------------------
local lazylock = require("lazylock")
local lazy = require("lazy")
local utils = require("utils.utils")

--------------------------------------------------------------------------------
-- Helpers
--------------------------------------------------------------------------------
---@param s string
---@param ... any
---@return string
local function f(s, ...)
  return string.format(s, ...)
end

---@param msg string
---@param ... any
---@return nil
local function log_error(msg, ...)
  vim.notify(f(msg, ...), vim.log.levels.ERROR)
end

---@generic T
---@param v T[]?
---@return T[]
---@overload fun(v?: string): string[]
local function normalize(v)
  if v == nil then
    return {}
  end
  if type(v) == "table" then
    return v
  else
    return { v }
  end
end

---@param spec string|LazyPluginSpec
---@return LazyPluginSpec?
local function normalize_dependency(spec)
  ---@type string?
  local url = nil
  if type(spec) == "string" then
    url = spec
    spec = { spec }
  else
    url = spec[1]
  end

  ---@type string?
  local name = spec.name

  if url == nil then
    log_error("LazyPluginSpec does not have a url")
    return nil
  end

  ---@type LazyPluginSpec?
  local lock = lazylock[url]
  if lock == nil then
    log_error("%s does not have a lock file", url)
    return nil
  end

  return vim.tbl_deep_extend("force", lock, {
    url,
    name = name,
  })
end

---@param spec string|LazyPluginSpec
---@return LazyPluginSpec?
local function normalize_spec(spec)
  ---@type string?
  local url = nil
  if type(spec) == "string" then
    url = spec
    spec = { spec }
  else
    url = spec[1]
  end

  ---@type string?
  local name = spec.name

  if url == nil then
    log_error("LazyPluginSpec does not have a url")
    return nil
  end

  ---@type LazyPluginSpec?
  local lock = lazylock[url]
  if lock == nil then
    log_error("%s does not have a lock file", url)
    return nil
  end

  name = name or lock.name
  if name == nil then
    log_error("%s does not have a name", url)
    return nil
  end

  local config_name = string.lower(string.gsub(name, "%.", "-"))
  local ok, config = pcall(require, "configs." .. config_name)
  if not ok then
    config = {}
  end
  ---@cast config LazyPluginSpec

  ---@type LazyPluginSpec
  local updates = {}

  -- Name.
  updates.name = name

  -- Lazy.
  if spec.lazy ~= nil then
    updates.lazy = spec.lazy
  end
  if config.lazy ~= nil then
    updates.lazy = config.lazy
  end

  -- Dependencies.
  if spec.dependencies ~= nil or config.dependencies ~= nil then
    local left = normalize(spec.dependencies)
    local right = normalize(config.dependencies)
    local dependencies = utils.uniq(utils.concat(left, right))

    -- Normalize dependencies.
    local norm_dependencies = {}
    for _, dependency in ipairs(dependencies) do
      local norm_dependency = normalize_dependency(dependency)
      if norm_dependency ~= nil then
        table.insert(norm_dependencies, norm_dependency)
      end
    end

    updates.dependencies = norm_dependencies
  end

  -- Init.
  if spec.init ~= nil or config.init ~= nil then
    updates.init = function(plugin)
      if spec.init ~= nil then
        spec.init(plugin)
      end

      if config.init ~= nil then
        config.init(plugin)
      end
    end
  end

  -- Opts.
  if spec.opts ~= nil or config.opts ~= nil then
    if
      spec.opts
      and config.opts
      and type(spec.opts) == "table"
      and type(config.opts) == "table"
    then
      local left = spec.opts
      ---@cast left table
      local right = config.opts
      ---@cast right table
      updates.opts = utils.uniq(utils.concat(left, right))
    else
      updates.opts = config.opts or spec.opts
    end
  end

  -- Config.
  if spec.config ~= nil or config.config ~= nil then
    if type(spec.config) == "function" or type(config.config) == "function" then
      updates.config = function(plugin, opts)
        if spec.config ~= nil then
          spec.config(plugin, opts)
        end

        if config.config ~= nil then
          config.config(plugin, opts)
        end
      end
    else
      updates.config = spec.config or config.config
    end
  end

  -- Event.
  if spec.event ~= nil or config.event ~= nil then
    if spec.event ~= nil and config.event ~= nil then
      log_error("%s has conflicting 'event' options", url)
    end
    updates.event = config.event or spec.event
  end

  -- Cmd.
  if spec.cmd ~= nil or config.cmd ~= nil then
    if spec.cmd ~= nil and config.cmd ~= nil then
      log_error("%s has conflicting 'cmd' options", url)
    end
    updates.cmd = config.cmd or spec.cmd
  end

  -- Ft.
  if spec.ft ~= nil or config.ft ~= nil then
    if spec.ft ~= nil and config.ft ~= nil then
      log_error("%s has conflicting 'ft' options", url)
    end
    updates.ft = config.ft or spec.ft
  end

  -- Ft.
  if spec.keys ~= nil or config.keys ~= nil then
    if spec.keys ~= nil and config.keys ~= nil then
      log_error("%s has conflicting 'keys' options", url)
    end
    updates.keys = config.keys or spec.keys
  end

  return vim.tbl_deep_extend("force", lock, updates)
end

---@param specs (string|LazyPluginSpec)[]
---@param opts LazyConfig?
---@return nil
local function setup(specs, opts)
  opts = opts or {}

  -- Normalize specs.
  ---@type LazyPluginSpec[]
  local norm_specs = {}
  for _, spec in ipairs(specs) do
    local norm_spec = normalize_spec(spec)
    if norm_spec ~= nil then
      table.insert(norm_specs, norm_spec)
    end
  end

  -- Setup Lazy.nvim.
  lazy.setup(norm_specs, opts)
end

--------------------------------------------------------------------------------
-- Init
--------------------------------------------------------------------------------
setup({
  -- Common libraries and utils.
  { "nvim-lua/plenary.nvim", lazy = true },
  "folke/neodev.nvim",
  { "nvim-tree/nvim-web-devicons", opts = {}, lazy = true },

  -- Telescope.
  "nvim-telescope/telescope.nvim",

  -- TreeSitter.
  {
    "nvim-treesitter/nvim-treesitter",
    config = function()
      -- Disable compiling languages from source code.
      require("nvim-treesitter.install").compilers = {}
    end,
  },
  {
    "nvim-treesitter/playground",
    name = "nvim-treesitter-playground",
    lazy = true,
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
    },
    cmd = "TSPlaygroundToggle",
  },
  { "nvim-treesitter/nvim-treesitter-textobjects", lazy = true },

  -- LSP.
  {
    "neovim/nvim-lspconfig",
    init = function()
      vim.schedule(function()
        vim.cmd([[silent! do FileType]])
      end)
    end,
  },
  "ray-x/lsp_signature.nvim",
  { "Hoffs/omnisharp-extended-lsp.nvim", lazy = true }, -- Patches for C# LSP.
  "jose-elias-alvarez/null-ls.nvim",

  -- Completion.
  "hrsh7th/nvim-cmp",
  { "hrsh7th/cmp-nvim-lua", lazy = true },
  { "hrsh7th/cmp-nvim-lsp", lazy = true },
  { "hrsh7th/cmp-buffer", lazy = true },
  { "hrsh7th/cmp-path", lazy = true },
  { "saadparwaiz1/cmp_luasnip", lazy = true },

  -- Snippets.
  "L3MON4D3/LuaSnip",

  -- Git.
  { "lewis6991/gitsigns.nvim", opts = {}, event = "VeryLazy" },
  "NeogitOrg/neogit",
  { "sindrets/diffview.nvim", opts = {}, lazy = true },

  -- Editing.
  { "numToStr/Comment.nvim", opts = {} },

  -- Sessions.
  "rmagatti/auto-session",

  -- UI.
  "nvim-tree/nvim-tree.lua",
  "folke/which-key.nvim",
  "nvim-lualine/lualine.nvim",
  "akinsho/bufferline.nvim",
  "folke/trouble.nvim",
  "goolord/alpha-nvim", -- Dashboard.
})
