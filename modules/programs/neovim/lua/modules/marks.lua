-- Better marks.
--
-- The module uses built-in tags and shada. Unlike the native marks,
-- this module makes all marks project-bounded and slightly modifies their
-- behavior (e.g., lowercase marks are “global”).

--------------------------------------------------------------------------------
-- Init
--------------------------------------------------------------------------------
local autocmd = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup
local command = vim.api.nvim_create_user_command

---@class modules.marks.Module
local M = {}

--------------------------------------------------------------------------------
-- Types
--------------------------------------------------------------------------------
---@alias modules.marks.Entry {bufnr: integer, lnum: integer, col: integer}

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

---@param path string|nil
---@return string|nil
local function normalize(path)
  if path == nil then
    return nil
  end
  if path == "" then
    return ""
  end

  return vim.fs.normalize(vim.fn.fnamemodify(path, ":p"))
end

---@param name string
---@return boolean
local function is_lower(name)
  return name:match("^%l$") ~= nil
end

---@param name string
---@return boolean
local function is_upper(name)
  return name:match("^%u$") ~= nil
end

-- Stable per-project key, matching the shada naming scheme.
---@param root string
---@return string
local function project_key(root)
  return vim.fn.fnamemodify(root, ":t") .. "-" .. vim.fn.sha256(root):sub(1, 8)
end

--------------------------------------------------------------------------------
-- Modules
--------------------------------------------------------------------------------
---@class modules.marks.Config
M.defaults = {
  root_dir = function()
    local root = vim.fs.root(0, { ".git" })
    if not root then
      return nil
    end
    return root
  end,

  shada_projects_dir = vim.fn.stdpath("state") .. "/shada-projects",
}

---@type modules.marks.Config
M.options = vim.tbl_deep_extend("force", M.defaults, {})

M._active = false
M._root = nil ---@type string?

--- Resolves a mark to a position.
---@param name string
---@return modules.marks.Entry?
local function resolve(name)
  if is_upper(name) then
    local m = vim.api.nvim_get_mark(name, {})
    if m[1] == 0 then
      return nil
    end
    return {
      bufnr = m[3] ~= 0,
      lnum = m[1],
      col = m[2],
    }
  elseif is_lower(name) then
    for _, buf in ipairs(vim.api.nvim_list_bufs()) do
      if vim.api.nvim_buf_is_loaded(buf) then
        local pos = vim.api.nvim_buf_get_mark(buf, name)
        if pos[1] > 0 then
          return {
            bufnr = buf,
            lnum = pos[1],
            col = pos[2],
          }
        end
      end
    end
  end

  return nil
end

---@param name string
M.set = function(name)
  vim.cmd("normal! m" .. name)

  if not M._active then
    return
  end

  -- Keep the mark unique across loaded buffers.
  local cur = vim.api.nvim_get_current_buf()

  if is_upper(name) then
    emit("MarksDelete", {
      name = name,
      buf = nil,
    })
  elseif is_lower(name) then
    for _, buf in ipairs(vim.api.nvim_list_bufs()) do
      local pos = vim.api.nvim_buf_get_mark(buf, name)
      if pos[1] > 0 then
        if buf ~= cur then
          vim.api.nvim_buf_del_mark(buf, name)
        end

        emit("MarksDelete", {
          name = name,
          buf = buf,
        })
      end
    end
  end

  emit("MarksSet", {
    name = name,
    buf = cur,
  })
end

--- Find a window in the current tabpage for the bufnr.
---@param bufnr integer
---@return integer|nil
local function buf_window(bufnr)
  for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
    if vim.api.nvim_win_get_buf(win) == bufnr then
      return win
    end
  end

  return nil
end

---@param entry modules.marks.Entry
---@param exact boolean
local function goto_mark(entry, exact)
  -- Remember the jump origin.
  vim.cmd("normal! m'")

  local win = buf_window(entry.bufnr)
  if win ~= nil then
    vim.api.nvim_set_current_win(win)
  elseif entry.bufnr ~= nil and vim.api.nvim_buf_is_loaded(entry.bufnr) then
    vim.api.nvim_set_current_buf(entry.bufnr)
  end

  local lnum = entry.lnum or 0
  local col = exact and entry.col or 0

  vim.api.nvim_win_set_cursor(0, { lnum, col })

  if not exact then
    vim.cmd("normal! ^")
  end
end

---@param name string
---@param exact boolean
M.jump = function(name, exact)
  local entry = M._active and resolve(name) or nil
  if entry == nil then
    -- Fall back to native marks.
    local key = exact and "`" or "'"
    vim.cmd("normal! " .. key .. name)
    return
  end

  goto_mark(entry, exact)

  -- emit("MarksJump", {
  --   name = name,
  --   buf = entry.bufnr,
  -- })
end

---@param name string
M.delete = function(name)
  if name == nil or name == "" then
    return
  end

  if is_upper(name) then
    vim.api.nvim_del_mark(name)

    emit("MarksDelete", {
      name = name,
      buf = nil,
    })
  elseif is_lower(name) then
    for _, buf in ipairs(vim.api.nvim_list_bufs()) do
      local pos = vim.api.nvim_buf_get_mark(buf, name)
      if pos[1] > 0 then
        vim.api.nvim_buf_del_mark(buf, name)

        emit("MarksDelete", {
          name = name,
          buf = buf,
        })
      end
    end
  end
end

--------------------------------------------------------------------------------
-- Activation
--------------------------------------------------------------------------------
M.attach = function()
  local root = normalize(M.options.root_dir())
  if root == nil then
    M.detach()
    return
  end

  if M._active and M._root == root then
    return
  end

  M.detach()

  M._active = true
  M._root = root

  vim.fn.mkdir(M.options.shada_projects_dir, "p")
  vim.o.shadafile = M.options.shada_projects_dir .. "/" .. project_key(root) .. ".shada"
  vim.cmd("rshada!")
end

M.detach = function()
  if not M._active then
    return
  end

  -- Persist the mark when switching the project.
  vim.cmd("wshada")

  M._active = false
  M._root = nil
end

--------------------------------------------------------------------------------
-- Setup
--------------------------------------------------------------------------------
---@param opts modules.marks.Config?
M.setup = function(opts)
  M.options = vim.tbl_deep_extend("force", M.defaults, opts or {})

  autocmd({ "VimEnter", "DirChanged" }, {
    group = augroup("MarksDetect", { clear = true }),
    desc = "Detect marks",
    callback = function()
      M.attach()
    end,
  })

  vim.keymap.set("n", "m", function()
    M.set(vim.fn.getcharstr())
  end, { desc = "Set mark" })

  vim.keymap.set("n", "`", function()
    M.jump(vim.fn.getcharstr(), true)
  end, { desc = "Jump to mark (exact)" })

  vim.keymap.set("n", "'", function()
    M.jump(vim.fn.getcharstr(), false)
  end, { desc = "Jump to mark (line)" })

  command("MarksDelete", function(event)
    M.delete(event.fargs[1])
  end, { desc = "Delete a mark", nargs = 1 })

  M.attach()
end

M.reload = function()
  M.setup(M.options)
end

--------------------------------------------------------------------------------
-- Export
--------------------------------------------------------------------------------
return M
