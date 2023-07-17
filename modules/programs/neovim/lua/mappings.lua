--------------------------------------------------------------------------------
-- Imports
--------------------------------------------------------------------------------
local neogit = require("configs.neogit").mappings
local telescope = require("configs.telescope-nvim").mappings

--------------------------------------------------------------------------------
-- Init
--------------------------------------------------------------------------------
local M = {
  mappings = {},
  groups = {},
}

--------------------------------------------------------------------------------
-- Helpers
--------------------------------------------------------------------------------
local safe_add_mapping

---@param mode string|string[]
---@param lhs string
---@param rhs string|function
---@param desc? string
---@param opts? table
local function add_mapping(mode, lhs, rhs, desc, opts)
  opts = vim.tbl_deep_extend("force", {
    desc = desc,
    remap = false,
    silent = true,
  }, opts or {})

  vim.keymap.set(mode, lhs, rhs, opts)
end

---@param mode string|string[]
---@param lhs string
---@param rhs string|function
---@param desc? string
---@param opts? table
safe_add_mapping = function(mode, lhs, rhs, desc, opts)
  local ok, err = pcall(add_mapping, mode, lhs, rhs, desc, opts)
  if not ok then
    vim.api.nvim_notify(
      "mappings: failed to add mapping: " .. (err or ""),
      vim.log.levels.ERROR,
      {}
    )
  end
end

local safe_add_mappings

---@param prefix string
---@param group table
---@param safe? boolean
local function add_mappings(prefix, group, safe)
  safe = safe or false

  if group.mappings ~= nil then
    for key, mappings in pairs(group.mappings) do
      -- Ckeck if mappings has different modes.
      mappings = mappings

      local multiple = true
      for _, mapping in ipairs(mappings) do
        multiple = type(mapping) == "table"

        if not multiple then
          break
        end
      end

      -- Normalize.
      if not multiple then
        mappings = { mappings }
      end

      for _, mapping in ipairs(mappings) do
        if safe then
          safe_add_mapping(
            mapping[1],
            prefix .. key,
            mapping[2],
            mapping[3],
            mapping[4]
          )
        else
          add_mapping(
            mapping[1],
            prefix .. key,
            mapping[2],
            mapping[3],
            mapping[4]
          )
        end
      end
    end
  end

  if group.groups ~= nil then
    for _, g in pairs(group.groups) do
      local p = prefix .. (g.prefix or "")

      if safe then
        safe_add_mappings(p, g)
      else
        add_mappings(p, g)
      end
    end
  end
end

---@param prefix string
---@param group table
safe_add_mappings = function(prefix, group)
  local ok, err = pcall(add_mappings, prefix, group)
  if not ok then
    vim.api.nvim_notify(
      "mappings: failed to add mappings: " .. (err or ""),
      vim.log.levels.ERROR,
      {}
    )
  end
end

---@param prefix string
---@param name string?
---@param group table?
local function which_key_register(prefix, name, group)
  if group == nil then
    return
  end

  name = group.name or name

  local p = prefix .. (group.prefix or "")

  if name ~= nil then
    local wk = require("which-key")
    wk.register({ name = name }, { prefix = p })
  end

  if group.groups ~= nil then
    for n, g in pairs(group.groups) do
      which_key_register(p, n, g)
    end
  end
end

--------------------------------------------------------------------------------
-- Leaders
--------------------------------------------------------------------------------
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

--------------------------------------------------------------------------------
-- Mappings
--------------------------------------------------------------------------------
-- Go to.
M.mappings["gd"] = { "n", vim.lsp.buf.definition, "Go to the definition" }
M.mappings["gD"] =
  { "n", vim.lsp.buf.type_definition, "Go to the type definition" }
M.mappings["gI"] =
  { "n", vim.lsp.buf.implementation, "Go to the implementation" }
M.mappings["gr"] = { "n", vim.lsp.buf.references, "Go to references" }

-- Hover.
M.mappings["H"] = { "n", vim.lsp.buf.hover, "Hover" }

-- Move lines.
M.mappings["<M-j>"] = {
  { "n", [[:move +1<CR>]] },
  { "v", [[:move '>+1<CR>gv=gv]] },
}
M.mappings["<M-k>"] = {
  { "n", [[:move -2<CR>]] },
  { "v", [[:move -2<CR>gv=gv]] },
}

-- Leader
--- Find
M.groups.f = {
  name = "find",
  prefix = "<leader>f",
  mappings = {
    b = { "n", telescope.find_buffers(), "Find buffers" },
    f = { "n", telescope.find_files(), "Find files" },
    h = { "n", telescope.find_help_tags(), "Find help tags" },
    r = { "n", telescope.find_recent_files(), "Find recent files" },
    w = { "n", telescope.find_words(), "Find words" },
  },
}

--- Git
M.groups.g = {
  name = "git",
  prefix = "<leader>g",
  mappings = {
    g = { "n", neogit.open(), "Open Neogit" },
  },
}

-- Refactoring.
M.groups.r = {
  name = "refactoring",
  prefix = "<leader>r",
  mappings = {
    r = { "n", vim.lsp.buf.rename, "Rename" },
  },
}

--- Yank
M.mappings["<leader>y"] = { { "n", "v" }, [["+y]], "Yank to clipboard" }

--- Put
M.mappings["<leader>p"] =
  { { "n", "v" }, [["+p]], "Put from clipboard after cursor" }
M.mappings["<leader>P"] =
  { { "n", "v" }, [["+P]], "Put from clipboard before cursot" }

--------------------------------------------------------------------------------
-- Register
--------------------------------------------------------------------------------
M.which_key_register = function()
  which_key_register("", "", M)
end

safe_add_mappings("", M)

--------------------------------------------------------------------------------
-- Export
--------------------------------------------------------------------------------
return M
