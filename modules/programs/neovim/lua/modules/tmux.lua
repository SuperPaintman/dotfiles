--------------------------------------------------------------------------------
-- Init
--------------------------------------------------------------------------------
---@class modules.tmux.Module
local M = {
  _initialized = false,

  _is_tmux = false,
  _tmux_socket = "",
  _tmux_pane = "",
}

local DIRECTIONS = {
  h = { "L", "left" },
  j = { "D", "bottom" },
  k = { "U", "top" },
  l = { "R", "right" },
}

--------------------------------------------------------------------------------
-- Helpers
--------------------------------------------------------------------------------
local function get_tmux()
  return os.getenv("TMUX") or ""
end

local function get_tmux_pane()
  return os.getenv("TMUX_PANE") or ""
end

local function get_tmux_socket()
  return vim.split(get_tmux(), ",")[1] or ""
end

local function is_vim_border(direction)
  return vim.api.nvim_call_function("winnr", {}) == vim.api.nvim_call_function("winnr", { direction })
end

--------------------------------------------------------------------------------
-- Modules
--------------------------------------------------------------------------------

---@class modules.tmux.Config
M.options = {
}

---@type modules.tmux.Config
M.defaults = vim.deepcopy(M.options)

---@param arg string
---@return string
M._execute = function(arg)
  assert(M._initialized, "modules.tmux: is not initialized")
  assert(M._tmux_socket ~= "", "modules.tmux: tmux socket is empty")

  local command = string.format("tmux -S %s %s", M._tmux_socket, arg)

  local handle, err = io.popen(command)
  if handle == nil then
    error(err, 0)
  end

  local result = handle:read("*a")
  handle:close()

  return vim.trim(result or "")
end

---@param direction "h"|"j"|"k"|"l"
---@return boolean
M._has_tmux_pane_at = function(direction)
  local dir = DIRECTIONS[direction]
  assert(dir ~= nil, "modules.tmux: unknown direction")

  if not M._initialized or M._tmux_socket == "" then
    return false
  end

  return M._execute("display-message -p '#{pane_at_" .. dir[2] .. "}'") == "0"
end


---@param direction "h"|"j"|"k"|"l"
M._move_vim = function(direction)
  if vim.fn.getcmdwintype() == "" then
    vim.cmd("wincmd " .. direction)
  end
end

---@param direction "h"|"j"|"k"|"l"
M.move = function(direction)
  local dir = DIRECTIONS[direction]
  assert(dir ~= nil, "modules.tmux: unknown direction")

  if not M._is_tmux then
    M._move_vim(direction)
    return
  end

  if is_vim_border(direction) then
    if M._has_tmux_pane_at(direction) then
      M._execute(string.format("select-pane -t '%s' -%s", M._tmux_pane, dir[1]))
    end
  else
    M._move_vim(direction)
  end
end

---@param opts modules.tmux.Config?
M.setup = function(opts)
  M.options = vim.tbl_deep_extend("force", M.defaults, opts or {})

  M._is_tmux = get_tmux() ~= ""
  M._tmux_socket = get_tmux_socket()
  M._tmux_pane = get_tmux_pane()

  for k, dir in pairs(DIRECTIONS) do
    vim.keymap.set("n", "<C-" .. k .. ">", function()
      M.move(k)
    end, {
      desc = "Select window (" .. dir[2] .. ")",
      remap = false,
      silent = true,
    })
  end

  M._initialized = true
end

--------------------------------------------------------------------------------
-- Export
--------------------------------------------------------------------------------
return M
