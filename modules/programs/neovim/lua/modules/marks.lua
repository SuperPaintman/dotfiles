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

local CHEATSHEET_SEP = "➜"
local CHEATSHEET_NS = vim.api.nvim_create_namespace("marks_cheatsheet")

--------------------------------------------------------------------------------
-- Types
--------------------------------------------------------------------------------
---@alias modules.marks.Entry {bufnr?: integer, lnum: integer, col: integer}
---@alias modules.marks.CheatsheetEntry {name: string, label: string}

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

---@param names string[]
---@return string|nil
local function hlname(names)
  for _, name in ipairs(names) do
    if vim.fn.hlexists(name) == 1 then
      return name
    end
  end
  return nil
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
M._cheatsheet_win = nil ---@type integer?
M._styles = {
  normal = "",
  border = "",
  title = "",

  key = "",
  sep = "",
  desc = "",
}

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
      bufnr = m[3] ~= 0 and m[3] or nil,
      lnum = m[1],
      col = m[2],
    }
  elseif is_lower(name) then
    for _, buf in ipairs(vim.api.nvim_list_bufs()) do
      if vim.api.nvim_buf_is_valid(buf) then
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

  -- Keep the mark unique across buffers.
  local cur = vim.api.nvim_get_current_buf()

  if is_upper(name) then
    emit("MarksDelete", {
      name = name,
      buf = nil,
    })
  elseif is_lower(name) then
    for _, buf in ipairs(vim.api.nvim_list_bufs()) do
      if vim.api.nvim_buf_is_valid(buf) then
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
  end

  emit("MarksSet", {
    name = name,
    buf = cur,
  })
end

--- Find a window in the current tabpage for the bufnr.
---@param buf integer|nil
---@return integer|nil
local function buf_window(buf)
  if buf == nil then
    return nil
  end

  -- Prefer the current window.
  local cur = vim.api.nvim_get_current_win()
  if vim.api.nvim_win_get_buf(cur) == buf then
    return cur
  end

  for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
    if vim.api.nvim_win_get_buf(win) == buf then
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
  elseif entry.bufnr ~= nil then
    if not vim.api.nvim_buf_is_loaded(entry.bufnr) then
      vim.fn.bufload(entry.bufnr)
      vim.bo[entry.bufnr].buflisted = true
    end
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
      if vim.api.nvim_buf_is_valid(buf) then
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
end

--- Collects all marks.
---@return modules.marks.CheatsheetEntry[]
function M._collect_marks()
  local items = {}

  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    if vim.api.nvim_buf_is_valid(buf) then
      local bufname = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(buf), ":~:.")

      for c = ("a"):byte(), ("z"):byte() do
        local name = string.char(c)
        local pos = vim.api.nvim_buf_get_mark(buf, name)
        if pos[1] > 0 then
          items[#items + 1] = {
            name = name,
            label = string.format(
              "%s:%d",
              bufname ~= "" and bufname or "[No Name]",
              pos[1]
            ),
          }
        end
      end
    end
  end

  for _, m in ipairs(vim.fn.getmarklist()) do
    local name = m.mark:sub(2)
    if is_upper(name) or m.mark == "'" then
      items[#items + 1] = {
        name = name,
        label = string.format("%s:%d", vim.fn.fnamemodify(m.file, ":~:."), m.pos[2]),
      }
    end
  end

  -- table.sort(items, function(a, b)
  --   return a.name < b.name
  -- end)

  return items
end

---@param items modules.marks.CheatsheetEntry[]
---@return string[], integer[][]
function M._cheatsheet_layout(items)
  if #items == 0 then
    return { " no marks" }, {}
  end

  local lines = {}
  local hls = {}

  for r, it in ipairs(items) do
    local key = it.name

    local text = " "
    local hstart = 1
    local hend = hstart

    text = text .. key
    hend = hend + #key
    hls[#hls + 1] = { r - 1, hstart, hend, M._styles.key }
    hstart = hend + 1

    text = text .. " " .. CHEATSHEET_SEP
    hend = hstart + #CHEATSHEET_SEP
    hls[#hls + 1] = { r - 1, hstart, hend, M._styles.sep }
    hstart = hend + 1

    text = text .. " " .. it.label
    hend = hstart + #it.label
    hls[#hls + 1] = { r - 1, hstart, hend, M._styles.desc }
    hstart = hend + 1

    text = text .. " "

    lines[#lines + 1] = text
  end

  return lines, hls
end

function M._close_cheatsheet()
  if M._cheatsheet_win ~= nil and vim.api.nvim_win_is_valid(M._cheatsheet_win) then
    vim.api.nvim_win_close(M._cheatsheet_win, true)
  end
  M._cheatsheet_win = nil
end

---@param items modules.marks.CheatsheetEntry[]
function M._open_cheatsheet(items)
  local lines, hls = M._cheatsheet_layout(items)

  local buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
  for _, h in ipairs(hls) do
    vim.api.nvim_buf_set_extmark(buf, CHEATSHEET_NS, h[1], h[2], {
      end_col = h[3],
      hl_group = h[4],
    })
  end
  vim.bo[buf].bufhidden = "wipe"
  vim.bo[buf].modifiable = false

  local height = #lines
  local margin_bottom = 1

  M._cheatsheet_win = vim.api.nvim_open_win(buf, false, {
    relative = "editor",
    width = vim.o.columns,
    height = #lines,
    row = vim.o.lines - height - vim.o.cmdheight - margin_bottom,
    col = 0,
    style = "minimal",
    border = "none",
    -- title = " marks ",
    -- title_pos = "center",
    focusable = false,
    noautocmd = true,
    zindex = 200,
  })

  vim.wo[M._cheatsheet_win].winhighlight = table.concat({
    "Normal:" .. M._styles.normal,
    "FloatBorder:" .. M._styles.border,
    "FloatTitle:" .. M._styles.title,
  }, ",")
end

--- Prompts for a mark.
---@return string
function M._prompt()
  if M._active then
    local marks = M._collect_marks()
    M._open_cheatsheet(marks)
    vim.cmd("redraw")
  end

  local ok, char = pcall(vim.fn.getcharstr)
  M._close_cheatsheet()

  return ok and char or ""
end

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

---@param opts modules.marks.Config?
M.setup = function(opts)
  M.options = vim.tbl_deep_extend("force", M.defaults, opts or {})

  M._styles = {
    normal = hlname({ "MarksCheatsheetNormal", "WhichKeyNormal", "NormalFloat" }),
    border = hlname({ "MarksCheatsheetBorder", "WhichKeyBorder", "FloatBorder" }),
    title = hlname({ "MarksCheatsheetTitle", "WhichKeyTitle", "FloatTitle" }),

    key = hlname({ "MarksCheatsheetKey", "WhichKey", "Function" }),
    sep = hlname({ "MarksCheatsheetSeparator", "WhichKeySeparator", "Comment" }),
    desc = hlname({ "MarksCheatsheetDesc", "WhichKeyDesc", "Identifier" }),
  }

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
    local c = M._prompt()
    if c ~= "" then
      M.jump(c, true)
    end
  end, { desc = "Jump to mark (exact)" })

  vim.keymap.set("n", "'", function()
    local c = M._prompt()
    if c ~= "" then
      M.jump(c, false)
    end
  end, { desc = "Jump to mark (line)" })

  command("MarksDelete", function(event)
    M.delete(event.fargs[1])
  end, { desc = "Delete a mark", nargs = 1 })

  M.attach()
end

M.reload = function()
  M._close_cheatsheet()
  vim.cmd("wshada")

  M.setup(M.options)
end

--------------------------------------------------------------------------------
-- Export
--------------------------------------------------------------------------------
return M
