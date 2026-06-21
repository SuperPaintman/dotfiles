--------------------------------------------------------------------------------
-- Init
--------------------------------------------------------------------------------
local command = vim.api.nvim_create_user_command

local M = {
  _initialized = false,

  -- Prevents prevent log truncations.
  _log_truncate_running = false,
}

--------------------------------------------------------------------------------
-- Helpers
--------------------------------------------------------------------------------
---@param path string
---@param keep integer
---@return integer kept
local function truncate_file(path, keep)
  -- Keep only the last `keep` lines using a ring buffer
  local lines, n, head = {}, 0, 1
  for line in io.lines(path) do
    if n < keep then
      n = n + 1
      lines[n] = line
    else
      lines[head] = line
      head = head % keep + 1
    end
  end

  local fd = assert(io.open(path, "w"))
  for i = 0, n - 1 do
    fd:write(lines[(head + i - 1) % n + 1], "\n")
  end
  fd:close()

  return n
end

--------------------------------------------------------------------------------
-- Modules
--------------------------------------------------------------------------------
---@class LspLogConfig
M.defaults = {
  -- Truncate the log on setup if it exceeds `max_size`.
  auto = true,
  -- Maximum log size in bytes before automatic truncation kicks in.
  max_size = 1 * 1024 * 1024, -- 1MiB
  -- Number of trailing lines to keep when truncating.
  keep_lines = 10000,
}

---@type LspLogConfig
M.options = {}

---@param opts? {force?:boolean, keep_lines?:integer}
---@return integer? kept
M.log_truncate = function(opts)
  if M._log_truncate_running then
    vim.notify("LspLogTruncate: already running", vim.log.levels.WARN)
    return -1
  end

  M._log_truncate_running = true
  local ok, kept = xpcall(M._log_truncate, debug.traceback, opts)
  M._log_truncate_running = false
  if not ok then
    error(kept, 0)
  end

  return kept
end

---@param opts? {force?:boolean, keep_lines?:integer}
---@return integer? kept
M._log_truncate = function(opts)
  local force = opts and opts.force or false
  local keep = opts and opts.keep_lines or M.options.keep_lines

  local path = vim.lsp.get_log_path()
  local stat = vim.uv.fs_stat(path)
  if stat == nil then
    return nil
  end

  if not force and stat.size <= M.options.max_size then
    return nil
  end

  return truncate_file(path, keep)
end


---@param opts? LspLogConfig
M.setup = function(opts)
  M.options = vim.tbl_deep_extend("force", M.defaults, opts or {})

  command("LspLogTruncate", function(event)
    local kept = M.log_truncate({
      force = event.bang,
      keep_lines = tonumber(event.fargs[1]),
    })

    if kept == -1 then
      -- Noop
    elseif kept == nil then
      vim.notify("LspLogTruncate: nothing to truncate", vim.log.levels.INFO)
    else
      vim.notify(
        string.format("LspLogTruncate: truncated to %d lines", kept),
        vim.log.levels.INFO
      )
    end
  end, {
    desc = "Truncate the LSP log (! to truncate when not oversized)",
    bang = true,
    nargs = "?",
  })

  if M.options.auto and not M._initialized then
    vim.schedule(function()
      M.log_truncate()
    end)
  end

  M._initialized = true
end

M.reload = function()
  M.setup(M.options)
end

--------------------------------------------------------------------------------
-- Export
--------------------------------------------------------------------------------
return M
