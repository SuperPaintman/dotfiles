---
--- logger.lua provides a logger and patches all built-in Neovim logging
--- functions (e.g. print, vim.print, vim.notify, etc.).
---

--------------------------------------------------------------------------------
-- Init
--------------------------------------------------------------------------------
local vim = _G.vim

local LEVEL_TRACE = vim.log.levels.TRACE
local LEVEL_DEBUG = vim.log.levels.DEBUG
local LEVEL_INFO = vim.log.levels.INFO
local LEVEL_WARN = vim.log.levels.WARN
local LEVEL_ERROR = vim.log.levels.ERROR
local LEVEL_OFF = vim.log.levels.OFF

local EVENT_LOG = "LoggerLog"

--------------------------------------------------------------------------------
-- Helpers
--------------------------------------------------------------------------------

--- Emmits an user event.
---@param event string
---@param data table?
local function emit(event, data)
  vim.api.nvim_exec_autocmds("User", {
    pattern = event,
    modeline = false,
    data = data or {},
  })
end

--------------------------------------------------------------------------------
-- Modules
--------------------------------------------------------------------------------
---@class modules.logger.Module
local M = {}

M._orig = {
  print = _G.print,

  -- See: https://github.com/neovim/neovim/blob/4d9e5acfb5ee081b5b0761205c8a8c36ed7e49e5/runtime/lua/vim/inspect.lua#L358
  vim_inspect = vim.inspect,

  -- See: https://github.com/neovim/neovim/blob/4d9e5acfb5ee081b5b0761205c8a8c36ed7e49e5/runtime/lua/vim/_core/editor.lua#L1259
  vim_print = vim.print,

  -- See: https://github.com/neovim/neovim/blob/4d9e5acfb5ee081b5b0761205c8a8c36ed7e49e5/runtime/lua/vim/_core/editor.lua#L683
  vim_notify = vim.notify,

  -- See: https://github.com/neovim/neovim/blob/4d9e5acfb5ee081b5b0761205c8a8c36ed7e49e5/runtime/lua/vim/_core/editor.lua#L704
  vim_notify_once = vim.notify_once,

  -- See: https://github.com/neovim/neovim/blob/4d9e5acfb5ee081b5b0761205c8a8c36ed7e49e5/runtime/lua/vim/_core/editor.lua#L683
  vim_api_nvim_echo = vim.api.nvim_echo,
}
for k in pairs(M._orig) do
  M._orig[k] = nil
end

---@class modules.logger.Config
M.config = {
}

---@type modules.logger.Config
M.defaults = vim.deepcopy(M.config)

---@param level vim.log.levels
---@param msg string
---@param ... any[]
M.log = function(level, msg, ...)
  M._log(level, msg, { ... }, "Logger.log")
end

---@param msg string
---@param ... any[]
M.trace = function(msg, ...) M.log(LEVEL_TRACE, msg, ...) end

---@param msg string
---@param ... any[]
M.debug = function(msg, ...) M.log(LEVEL_DEBUG, msg, ...) end

---@param msg string
---@param ... any[]
M.info = function(msg, ...) M.log(LEVEL_INFO, msg, ...) end

---@param msg string
---@param ... any[]
M.warn = function(msg, ...) M.log(LEVEL_WARN, msg, ...) end

---@param msg string
---@param ... any[]
M.error = function(msg, ...) M.log(LEVEL_ERROR, msg, ...) end

---@param level vim.log.levels
---@param fmt string
---@param ... any[]
M.logf = function(level, fmt, ...)
  M._log(level, string.format(fmt, ...), nil, "Logger.log")
end

---@param fmt string
---@param ... any[]
M.tracef = function(fmt, ...) M.logf(LEVEL_TRACE, fmt, ...) end

---@param fmt string
---@param ... any[]
M.debugf = function(fmt, ...) M.logf(LEVEL_DEBUG, fmt, ...) end

---@param fmt string
---@param ... any[]
M.infof = function(fmt, ...) M.logf(LEVEL_INFO, fmt, ...) end

---@param fmt string
---@param ... any[]
M.warnf = function(fmt, ...) M.logf(LEVEL_WARN, fmt, ...) end

---@param fmt string
---@param ... any[]
M.errorf = function(fmt, ...) M.logf(LEVEL_ERROR, fmt, ...) end

local log_level_map = {
  [LEVEL_TRACE] = { label = 'TRACE', short_label = 'T', hl = 'LoggerTrace' },
  [LEVEL_DEBUG] = { label = 'DEBUG', short_label = 'D', hl = 'LoggerDebug' },
  [LEVEL_INFO] = { label = 'INFO', short_label = 'I', hl = 'LoggerInfo' },
  [LEVEL_WARN] = { label = 'WARN', short_label = 'W', hl = 'LoggerWarn' },
  [LEVEL_ERROR] = { label = 'ERROR', short_label = 'E', hl = 'LoggerError' },
  -- [OFF] = { label = 'OFF', short_label = 'X', hl = 'LoggerOff' },
}

---@private
---
---@param level vim.log.levels
---@param chunks any[]
---@return any[]
M._normalize_chunks = function(level, chunks)
  local mapping = log_level_map[level]
  if mapping == nil then
    error("modules.logger: unknown log level: " .. tostring(level))
  end

  local updated_chunks = {
    -- { ' ', nil },
    -- { ' ' .. mapping.label .. ' ', mapping.hl },
    { ' ' .. mapping.short_label .. ' ', mapping.hl },
    { ' ',                               nil },
  }

  for _, chunk in ipairs(chunks) do
    table.insert(updated_chunks, chunk)
  end

  return updated_chunks
end

---@private
---
---@param level vim.log.levels
---@param msg string
---@param args any[]?
---@return any[]
M._msg_to_chunks = function(level, msg, args)
  local chunks = M._normalize_chunks(level, {
    { msg, nil },
  })

  if args ~= nil then
    table.insert(chunks, { '\n', nil })
    for _, a in ipairs(args) do
      table.insert(chunks, {
        M._orig.vim_inspect(a, { newline = '\n' }),
        nil,
      })
    end
  end

  return chunks
end

---@private
---
---@param level vim.log.levels
---@param msg string
---@param args any[]?
---@param source string
M._log = function(level, msg, args, source)
  if level < 0 or level >= LEVEL_OFF then
    return
  end

  M._echo(
    M._msg_to_chunks(level, msg, args),
    true, -- add to `message-history.
    { err = level >= LEVEL_ERROR },
    { level = level, msg = msg, args = args, source = source }
  )
end

---@alias modules.logger.EchoContext { level: vim.log.levels, msg: string, args?: any[], source: string }

---@private
---
---@param chunks any[]
---@param history boolean
---@param opts vim.api.keyset.echo_opts
---@param ctx modules.logger.EchoContext
M._echo = function(chunks, history, opts, ctx)
  emit(EVENT_LOG, {
    level = ctx.level,
    message = ctx.msg,
    args = ctx.args,
    source = ctx.source or "Logger._echo",
  })

  -- Debug.
  -- table.insert(chunks, { " ::: " })
  -- table.insert(chunks, { M._orig.vim_inspect(ctx, { newline = " " }) })

  M._orig.vim_api_nvim_echo(
    chunks,
    history, -- add to `message-history.
    opts
  )
end

---@private
M._reset_patch = function()
  if M._orig.print ~= nil then
    _G.print = M._orig.print
    M._orig.print = nil
  end
  if M._orig.vim_inspect ~= nil then
    vim.api.inspect = M._orig.vim_inspect
    M._orig.vim_inspect = nil
  end
  if M._orig.vim_print ~= nil then
    vim.print = M._orig.vim_print
    M._orig.vim_print = nil
  end
  if M._orig.vim_notify ~= nil then
    vim.notify = M._orig.vim_notify
    M._orig.vim_notify = nil
  end
  if M._orig.vim_notify_once ~= nil then
    vim.notify_once = M._orig.vim_notify_once
    M._orig.notify_once = nil
  end
  if M._orig.vim_api_nvim_echo ~= nil then
    vim.api.nvim_echo = M._orig.vim_api_nvim_echo
    M._orig.vim_api_nvim_echo = nil
  end

  M._orig.print = _G.print
  M._orig.vim_inspect = vim.inspect
  M._orig.vim_print = vim.print
  M._orig.vim_notify = vim.notify
  M._orig.vim_notify_once = vim.notify_once
  M._orig.vim_api_nvim_echo = vim.api.nvim_echo
end

---@private
M._apply_patch = function()
  M._reset_patch()

  _G.print = M._patched_print
  vim.notify = M._patched_vim_notify
  vim.api.nvim_echo = M._patched_vim_api_nvim_echo
end

---@private
M._patched_print = function(...)
  local msg = {}
  for i = 1, select('#', ...) do
    local o = select(i, ...)
    table.insert(msg, tostring(o))
  end

  M._log(LEVEL_INFO, table.concat(msg, ' '), nil, "_G.print")
end

---@param msg string
---@param level vim.log.levels?
---@param opts table?
M._patched_vim_notify = function(msg, level, opts)
  -- local chunks = { { msg, level == vim.log.levels.WARN and 'WarningMsg' or nil } }
  -- vim.api.nvim_echo(
  --   chunks,
  --   true,
  --   { err = level == vim.log.levels.ERROR, _truncate = opts and opts._truncate }
  -- )

  if level == nil then
    level = LEVEL_INFO
  end

  M._echo(
    M._msg_to_chunks(level, msg, nil),
    true, -- add to `message-history.
    { err = level >= LEVEL_ERROR, _truncate = opts and opts._truncate },
    { level = level, msg = msg, args = nil, source = "vim.notify" }
  )
end

---@private
---
---@param chunks any[]
---@param history boolean
---@param opts vim.api.keyset.echo_opts
M._patched_vim_api_nvim_echo = function(chunks, history, opts)
  local msg = {}
  for _, chunk in ipairs(chunks) do
    if type(chunk) == "table" and #chunks >= 1 and type(chunk[1]) == "string" then
      table.insert(msg, chunk[1])
    end
  end

  local level = LEVEL_INFO
  if #chunks >= 1 and #chunks[1] >= 2 and chunks[1][2] == "WarningMsg" then
    -- Handle vim._truncated_echo_once
    -- See: https://github.com/neovim/neovim/blob/4d9e5acfb5ee081b5b0761205c8a8c36ed7e49e5/runtime/lua/vim/_core/editor.lua#L1355
    level = LEVEL_WARN
  elseif #chunks >= 1 and #chunks[1] >= 2 and chunks[1][2] == "ErrorMsg" then
    level = LEVEL_ERROR
  elseif opts and opts.err then
    level = LEVEL_ERROR
  end

  M._echo(
    M._normalize_chunks(level, chunks),
    history,
    opts,
    { level = level, msg = table.concat(msg, "\n"), args = nil, source = "vim.api.nvim_echo" }
  )
end

---@param opts modules.logger.Config?
M.setup = function(opts)
  M.reset()

  M.options = vim.tbl_deep_extend("force", M.defaults, opts or {})

  M._apply_patch()
end

M.reset = function()
  M._reset_patch()

  M.options = vim.deepcopy(M.defaults)
end

-- TODO(SuperPaintman):
--     Experiment with custom interceptors later.
--     Right now if we attach this handler, it completely removes the cmdline
--     See: https://github.com/neovim/neovim/issues/20454
-- local ns = vim.api.nvim_create_namespace('messagelog')
-- vim.ui_attach(ns, { ext_messages = true }, function(event, ...)
--   ---
-- end)

--------------------------------------------------------------------------------
-- Export
--------------------------------------------------------------------------------
return M
