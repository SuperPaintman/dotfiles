--------------------------------------------------------------------------------
-- Init
--------------------------------------------------------------------------------
local vim = _G.vim

local command = vim.api.nvim_create_user_command
local f = string.format

local reload = require("utils.modules").reload
local unload = require("utils.modules").unload

-- local RELOADABLE = {
--   "configs.indent-blankline-nvim",
--   "configs.lsp_signature-nvim",
--   "configs.luasnip",
--   "configs.nvim-cmp",
--   "configs.bufferline-nvim",
--   "configs.nvim-tree-lua",
--   "configs.nvim-treesitter",
--   "configs.telescope-nvim",
--
--   "modules.tmux",
--   "modules.statuscolumn",
--   "modules.quickfix",
--   "modules.marks",
--   "modules.lsp",
--   "modules.contextsigns",
--
--   "theme",
-- }

--------------------------------------------------------------------------------
-- Helpers
--------------------------------------------------------------------------------

---@param msg string
local function vimerror(msg)
  vim.notify(msg, vim.log.levels.ERROR)
end

---@param root string
---@return fun(): string?
local function iter_modules(root)
  local depth = 30 -- math.huge
  local lua_dir = vim.fs.normalize(root .. "/lua")

  return coroutine.wrap(function()
    for name, type in vim.fs.dir(lua_dir, { depth = depth, follow = true }) do
      if type == "file" and name:match("%.lua$") then
        coroutine.yield((name:gsub("%.lua$", ""):gsub("/init$", ""):gsub("/", ".")))
      end
    end
  end)
end

--------------------------------------------------------------------------------
-- Modules
--------------------------------------------------------------------------------
local M = {}

---@class modules.reload.Config
M.config = {}

---@class modules.reload.Config
M.defaults = vim.deepcopy(M.config)

---@param opts? modules.reload.Config
M.setup = function(opts)
  M.options = vim.tbl_deep_extend("force", M.defaults, opts or {})

  local always_reload = {
    "core.ui",
  }

  -- Find all reloadable files.
  local reloadable_map = {
    ["core.autocmds"] = true,
    ["core.mappings"] = true, -- Already applied mappings won't be undo.
    -- ["core.options"] = true,  -- Unstable.
    ["core.ui"] = true,

    ["theme"] = true,
  }

  for m in iter_modules(vim.fn.stdpath("config")) do
    if m:match("^configs%.") or m:match("^modules%.") then
      reloadable_map[m] = true
    end
  end

  local reloadable = {} ---@type string[]
  for m in pairs(reloadable_map) do
    table.insert(reloadable, m)
  end

  command("Reload", function(opts)
    local modname = opts.fargs[1]
    if not vim.tbl_contains(reloadable, modname) then
      vimerror(f("Unknown module: %s", modname))
      return
    end

    local ok, err = pcall(function()
      -- Unload common packages.
      for _, m in ipairs(always_reload) do
        unload(m)
      end

      -- Try to grab the already applied options.
      local loaded = package.loaded[modname]
      local prev_config = nil
      if loaded ~= nil and type(loaded) == "table" then
        if type(loaded.options) == "table" then
          prev_config = loaded.options
        end
      end

      -- Reload the module.
      local module = reload(modname)

      if type(module) == "table" then
        if module.reload ~= nil then
          module.reload(prev_config)
        elseif module.config ~= nil then
          module.config(prev_config)
        else
          -- vimerror(f("Module %s cannot be reloaded", modname))
        end
      end
    end)
    if not ok then
      vimerror(f("Failed to reload %s module: %s", modname, err))
      return
    end
  end, {
    desc = "Reload a neovim module",
    nargs = 1,
    ---@param arglead string
    ---@return string[]
    complete = function(arglead)
      ---@param m string
      return vim.tbl_filter(function(m)
        return m:find(arglead, 1, true) == 1
      end, reloadable)
    end,
    -- complete = function(arglead)
    --   local seen = {}
    --   local out = {}
    --
    --   for _, m in ipairs(reloadable) do
    --     if m:find(arglead, 1, true) == 1 then
    --       local rest = m:sub(#arglead + 1)
    --       local dot = rest:find(".", 1, true)
    --       local cand = dot and (m:sub(1, #arglead + dot - 1)) or m
    --       if not seen[cand] then
    --         seen[cand] = true
    --         out[#out + 1] = cand
    --       end
    --     end
    --   end
    --
    --   return out
    -- end,
  })
end

--------------------------------------------------------------------------------
-- Export
--------------------------------------------------------------------------------
return M
