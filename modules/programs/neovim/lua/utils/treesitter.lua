---@see https://neovim.io/doc/user/treesitter.html
---@see https://github.com/nvim-treesitter/nvim-treesitter
--------------------------------------------------------------------------------
-- Imports
--------------------------------------------------------------------------------
local utils = require("utils.utils")

--------------------------------------------------------------------------------
-- Types
--------------------------------------------------------------------------------
if false then
  vim.treesitter = require("vim.treesitter")
end

---@class utils.treesitter.TreesitterUtils
if false then
  ---@class utils.treesitter.TreesitterUtils
  local TreesitterUtils = {}

  ---@param winnr integer
  ---@param ignore_injected_langs boolean
  ---@return TSNode?
  ---@diagnostic disable-next-line
  function TreesitterUtils.get_node_at_cursor(winnr, ignore_injected_langs)
    error("unimplemented")
  end
end

---@class utils.treesitter.TreesitterLocals
if false then
  ---@class utils.treesitter.TreesitterLocals
  local TreesitterLocals = {}

  ---@param node TSNode
  ---@param bufnr integer
  ---@return TSNode[]
  ---@diagnostic disable-next-line
  function TreesitterLocals.get_scope_tree(node, bufnr)
    error("unimplemented")
  end

  ---@param node TSNode
  ---@param bufnr integer
  ---@return fun(): TSNode?
  ---@diagnostic disable-next-line
  function TreesitterLocals.iter_scope_tree(node, bufnr)
    error("unimplemented")
  end
end

--------------------------------------------------------------------------------
-- Init
--------------------------------------------------------------------------------
local M = {}

--------------------------------------------------------------------------------
-- Helpers
--------------------------------------------------------------------------------

---@return nil
local function noop()
  return nil
end

---@generic T
---@param modname string
---@return fun(): T?
local function optional_require(modname)
  return utils.lazy(function()
    local ok, pkg = pcall(require, modname)
    if not ok then
      return noop
    end

    return function()
      return pkg
    end
  end)
end

--------------------------------------------------------------------------------
-- Functions
--------------------------------------------------------------------------------
---@type fun(): TreesitterModule?
local _treesitter = utils.lazy(function()
  if vim.treesitter ~= nil then
    return function()
      return vim.treesitter
    end
  end

  local ok, pkg = pcall(require, "vim.treesitter")
  if not ok then
    return noop
  end

  return function()
    return pkg
  end
end)
M.treesitter = _treesitter

---@type fun(): utils.treesitter.TreesitterUtils?
local _get_ts_utils = optional_require("nvim-treesitter.ts_utils")
M.utils = _get_ts_utils

---@type fun(): utils.treesitter.TreesitterLocals?
local _get_ts_locals = optional_require("nvim-treesitter.locals")
M.locals = _get_ts_locals

---@param lang string
---@param query string
---@return fun(): Query?
function M.lazy_query_parse(lang, query)
  local ts = M.treesitter()
  if ts == nil then
    return noop
  end

  return utils.once(function()
    return ts.query.parse(lang, query)
  end)
end

---@param winnr integer? Window handle, or 0 for current window.
---@param ignore_injected_langs boolean?
---@return fun(): TSNode?
function M.iter_scope_tree_at_cursor(winnr, ignore_injected_langs)
  local tslocals = M.locals()
  local tsutils = M.utils()
  if tslocals == nil or tsutils == nil then
    return noop
  end

  winnr = winnr or 0
  if ignore_injected_langs == nil then
    ignore_injected_langs = true
  end

  local current = tsutils.get_node_at_cursor(winnr, ignore_injected_langs)
  if current == nil then
    return noop
  end

  local bufnr = vim.api.nvim_win_get_buf(winnr)
  return tslocals.iter_scope_tree(current, bufnr)
end

--------------------------------------------------------------------------------
-- Export
--------------------------------------------------------------------------------
return M
