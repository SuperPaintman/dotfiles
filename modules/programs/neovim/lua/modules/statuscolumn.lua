-- See: https://www.reddit.com/r/neovim/comments/10fpqbp/comment/j50be6b
-- See: https://neovim.io/doc/user/diagnostic.html
-- TODO(SuperPaintman): try https://github.com/rebelot/heirline.nvim
--------------------------------------------------------------------------------
-- Imports
--------------------------------------------------------------------------------
local utils = require("utils.utils")

--------------------------------------------------------------------------------
-- Init
--------------------------------------------------------------------------------
local autocmd = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup

---@class modules.statuscolumn.Module
local M = {
  _initialized = false,
}

--------------------------------------------------------------------------------
-- Types
--------------------------------------------------------------------------------
---@alias modules.statuscolumn.Sign {name: string, text: string, texthl?: string, numhl?: string, priority?: integer}

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

---@param name string
---@return number
local function get_debugger_level(name)
  if name == "DapStopped" then
    return 5
  end

  if name == "DapBreakpointRejected" then
    return 4
  end

  if name == "DapBreakpointCondition" then
    return 3
  end

  if name == "DapBreakpoint" then
    return 2
  end

  if name == "DapLogPoint" then
    return 1
  end

  return 0
end

---@param name string
---@return boolean
local function is_debugger_sign(name)
  return (
    name == "DapStopped"
    or name == "DapBreakpointRejected"
    or name == "DapBreakpointCondition"
    or name == "DapBreakpoint"
    or name == "DapLogPoint"
  )
end

---@return modules.statuscolumn.Sign[]
local function get_signs()
  local win = vim.g.statusline_winid
  if win == nil then
    return {}
  end

  local buf = vim.api.nvim_win_get_buf(win)
  local lnum = vim.v.lnum
  local signs = {}

  local placed = vim.fn.sign_getplaced(buf, { group = "*", lnum = lnum })[1]
  if placed and placed.signs then
    for _, s in ipairs(placed.signs) do
      local def = vim.fn.sign_getdefined(s.name)[1]
      if def then
        table.insert(signs, {
          name = s.name,
          text = def.text,
          texthl = def.texthl,
          numhl = def.numhl,
          priority = s.priority,
        })
      end
    end
  end

  local extmarks = vim.api.nvim_buf_get_extmarks(
    buf,
    -1,
    { lnum - 1, 0 },
    { lnum - 1, -1 },
    { details = true, type = "sign" }
  )
  for _, ext in ipairs(extmarks) do
    local d = ext[4]
    if d and d.sign_text then
      table.insert(signs, {
        name = d.sign_name or d.sign_hl_group or "",
        text = d.sign_text or "",
        texthl = d.sign_hl_group,
        numhl = d.number_hl_group,
        priority = d.priority or 0,
      })
    end
  end

  return signs
end

---@param buf number
---@param lnum number
---@return modules.statuscolumn.Sign?
local function get_mark_sign(buf, lnum)
  for _, m in ipairs(vim.fn.getmarklist(buf)) do
    if m.pos[2] == lnum then
      local letter = m.mark:sub(2)
      if letter:match("^%l$") then
        return { name = "Mark", text = letter, texthl = "StatusColumnMark", numhl = "StatusColumnMarkLineNr" }
      end
    end
  end

  local name = vim.api.nvim_buf_get_name(buf)
  for _, m in ipairs(vim.fn.getmarklist()) do
    if m.pos[2] == lnum then
      local letter = m.mark:sub(2)
      if letter:match("^%u$") and vim.fn.fnamemodify(m.file, ":p") == name then
        return { name = "Mark", text = letter, texthl = "StatusColumnMark", numhl = "StatusColumnMarkLineNr" }
      end
    end
  end

  return nil
end

--------------------------------------------------------------------------------
-- Modules
--------------------------------------------------------------------------------
---@param opts table?
M.setup = function(opts)
  if not M._initialized then
    vim.api.nvim_set_hl(0, "StatusColumnMark", { link = "Special", default = true })
    vim.api.nvim_set_hl(0, "StatusColumnMarkLineNr", { link = "StatusColumnMark", default = true })
  end

  if vim.fn.has("nvim-0.9") == 1 then
    -- Debug
    -- require("utils.modules").unload("core.statuscolumn")

    vim.opt.statuscolumn = [[%!v:lua.require("modules.statuscolumn").statuscolumn()]]
  end

  -- Debounced refresh.
  ---@type { [integer]: { [1]: (fun(): nil), [2]: (fun(): nil) } }
  local debounced_refresh = {}

  ---@param buf integer
  local refresh = function(buf)
    if buf == nil or buf == 0 then
      M.refresh()
      return
    end

    local debounced = debounced_refresh[buf]
    if debounced == nil then
      local fn, cancel = utils.debounce(function()
        M.refresh(buf)
      end, 50)
      debounced = { fn, cancel }
      debounced_refresh[buf] = debounced
    end

    local fn = debounced[1]
    fn()
  end

  refresh(0)

  if vim.fn.exists("##MarkSet") == 1 then
    autocmd("MarkSet", {
      group = augroup("StatusColumnMarks", { clear = true }),
      desc = "Refresh statuscolumn when a mark is set or deleted",
      callback = function(ev) refresh(ev.buf) end,
    })
  end

  autocmd("User", {
    group = augroup("StatusColumnUserMarks", { clear = true }),
    pattern = { "MarksSet", "MarksDelete" },
    callback = function(ev) refresh((ev.data or {}).buf or 0) end,
  })

  M._initialized = true
end

---@param buf number?
M.refresh = function(buf)
  buf = buf or 0

  pcall(vim.api.nvim__redraw, { buf = buf, statuscolumn = true })
end

M.reload = function()
  M.setup({})
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

  ---@param sign modules.statuscolumn.Sign
  local function insert_sign(sign)
    if sign.texthl ~= nil then
      insert("%#" .. sign.texthl .. "#" .. sign.text .. "%*")
    else
      insert(sign.text)
    end
  end

  -- Marks.
  ---@type modules.statuscolumn.Sign?
  local mark_sign = nil
  if vim.g.statusline_winid ~= nil then
    local buf = vim.api.nvim_win_get_buf(vim.g.statusline_winid)
    mark_sign = get_mark_sign(buf, vim.v.lnum)
  end

  -- Find signs.
  ---@type modules.statuscolumn.Sign?
  local diagnostic_sign = nil
  local diagnostic_level = 0

  ---@type modules.statuscolumn.Sign?
  local code_action_sign = nil

  ---@type modules.statuscolumn.Sign?
  local debugger_sign = nil
  local debugger_level = 0

  ---@type modules.statuscolumn.Sign?
  local git_sign = nil

  ---@type modules.statuscolumn.Sign?
  local context_sign = nil

  for _, sign in ipairs(signs) do
    if sign.name:find("^DiagnosticSign") then
      local level = get_diagnostic_level(sign.name)
      if diagnostic_sign == nil or level > diagnostic_level then
        diagnostic_sign = sign
        diagnostic_level = level
      end
    elseif sign.name == "SagaLightBulb" then
      if code_action_sign == nil then
        code_action_sign = sign
      end
    elseif is_debugger_sign(sign.name) then
      local level = get_debugger_level(sign.name)
      if debugger_sign == nil or level > debugger_level then
        debugger_sign = sign
        debugger_level = level
      end
    elseif sign.name:find("^GitSign") then
      if git_sign == nil then
        git_sign = sign
      end
    elseif sign.name == "ContextSign" then
      if context_sign == nil then
        context_sign = sign
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
  elseif code_action_sign ~= nil then
    insert_sign(code_action_sign)
  elseif mark_sign ~= nil then
    insert_sign(mark_sign)
  else
    insert_padding("   ")
  end

  --- Debugger.
  if debugger_sign then
    insert_sign(debugger_sign)
    insert_padding(" ")
  end

  -- Right side.
  insert("%=")

  --- Line number.
  local cur_line = unpack(vim.api.nvim_win_get_cursor(0))
  local close_line_color = false
  if vim.o.number and vim.v.lnum ~= cur_line then
    if mark_sign ~= nil and mark_sign.numhl then
      insert("%#" .. mark_sign.numhl .. "#")
      close_line_color = true
    elseif context_sign ~= nil and context_sign.texthl ~= nil then
      insert("%#" .. context_sign.texthl .. "#")
      close_line_color = true
    end
  end

  insert("%{&number ? (&relativenumber && v:relnum ? v:relnum : v:lnum) : ''}")

  if close_line_color then
    insert("%*")
  end

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
