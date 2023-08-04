-- See: https://www.reddit.com/r/neovim/comments/10fpqbp/comment/j50be6b
-- See: https://neovim.io/doc/user/diagnostic.html
-- TODO(SuperPaintman): try https://github.com/rebelot/heirline.nvim
--------------------------------------------------------------------------------
-- Init
--------------------------------------------------------------------------------
---@class core.statuscolumn.Module
local M = {}

--------------------------------------------------------------------------------
-- Types
--------------------------------------------------------------------------------
---@alias core.statuscolumn.Sign {name: string, text: string, texthl: string}

--------------------------------------------------------------------------------
-- Helpers
--------------------------------------------------------------------------------
---@param name string
---@return number
local function get_diagnostic_level(name)
  if name == "DiagnosticSignError" then
    return 5
  end

  if name == "DiagnosticSignWarn" then
    return 4
  end

  if name == "DiagnosticSignInfo" then
    return 3
  end

  if name == "DiagnosticSignHint" then
    return 2
  end

  if name == "DiagnosticSignOk" then
    return 1
  end

  return 0
end

---@return core.statuscolumn.Sign[]
local function get_signs()
  if vim.g.statusline_winid == nil then
    return {}
  end

  local buf = vim.api.nvim_win_get_buf(vim.g.statusline_winid)
  local buf_signs =
    vim.fn.sign_getplaced(buf, { group = "*", lnum = vim.v.lnum })[1]
  if buf_signs == nil then
    return {}
  end

  local signs = vim.tbl_map(function(sign)
    return vim.fn.sign_getdefined(sign.name)[1]
  end, buf_signs.signs or {})

  return signs
end

--------------------------------------------------------------------------------
-- Modules
--------------------------------------------------------------------------------
---@param opts table?
M.setup = function(opts)
  if vim.fn.has("nvim-0.9") == 1 then
    -- Debug
    -- require("utils.modules").unload("core.statuscolumn")

    vim.opt.statuscolumn =
      [[%!v:lua.require("modules.statuscolumn").statuscolumn()]]
  end
end

M.statuscolumn = function()
  local signs = get_signs()

  ---@type string[]
  local components = {}

  ---@param component string
  local function insert(component)
    table.insert(components, component)
  end

  ---@param padding string
  local function insert_padding(padding)
    insert(
      "%{(&filetype == 'NvimTree' || &filetype == 'help') ? '' : '"
        .. padding
        .. "'}"
    )
  end

  ---@param sign core.statuscolumn.Sign
  local function insert_sign(sign)
    insert("%#" .. sign.texthl .. "#" .. sign.text .. "%*")
  end

  -- Find signs.
  ---@type core.statuscolumn.Sign?
  local diagnostic_sign = nil
  local diagnostic_level = 0

  ---@type core.statuscolumn.Sign?
  local git_sign = nil

  for _, sign in ipairs(signs) do
    if sign.name:find("^DiagnosticSign") then
      local level = get_diagnostic_level(sign.name)
      if diagnostic_sign == nil or level > diagnostic_level then
        diagnostic_sign = sign
        diagnostic_level = level
      end
    elseif sign.name:find("^GitSign") then
      if git_sign == nil then
        git_sign = sign
      end
    else
      -- Debug.
      -- insert_sign(sign)
      -- insert("(" .. sign.name .. ")")
    end
  end

  -- Left side.
  --- Padding.
  insert_padding("  ")

  --- Diagnostic signs.
  if diagnostic_sign ~= nil then
    insert_sign(diagnostic_sign)
  else
    insert_padding("   ")
  end

  -- Right side.
  insert("%=")

  --- Line number.
  insert("%{&number ? (&relativenumber && v:relnum ? v:relnum : v:lnum) : ''}")

  --- Padding.
  insert_padding("  ")

  --- Git signs.
  if git_sign ~= nil then
    insert_sign(git_sign)
  else
    insert_padding("   ")
  end

  return table.concat(components, "")
end

--------------------------------------------------------------------------------
-- Export
--------------------------------------------------------------------------------
return M
