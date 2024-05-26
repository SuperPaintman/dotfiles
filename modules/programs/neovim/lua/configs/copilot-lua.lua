--------------------------------------------------------------------------------
-- Imports
--------------------------------------------------------------------------------
local fs = require("utils.fs")
local ignore = require("utils.ignore")

--------------------------------------------------------------------------------
-- Init
--------------------------------------------------------------------------------
local M = {}

--------------------------------------------------------------------------------
-- Helpers
--------------------------------------------------------------------------------

---@type utils.ignore.Ignore
local default_patterns = {
  -- .git
  { pattern = ".git/*", allowed = false },

  -- .copilotignore
  { pattern = ".copilotignore", allowed = false },

  -- .env
  { pattern = ".env", allowed = false },
  { pattern = "*.env", allowed = false },
  { pattern = ".env.*", allowed = false },
  { pattern = "*.env.*", allowed = false },

  -- secrets
  { pattern = "secret", allowed = false },
  { pattern = "*.secret", allowed = false },
  { pattern = "secret.*", allowed = false },
  { pattern = "*.secret.*", allowed = false },

  { pattern = "secrets", allowed = false },
  { pattern = "*.secrets", allowed = false },
  { pattern = "secrets.*", allowed = false },
  { pattern = "*.secrets.*", allowed = false },

  { pattern = "secret/*", allowed = false },
  { pattern = "*.secret/*", allowed = false },
  { pattern = "secret.*/*", allowed = false },
  { pattern = "*.secret.*/*", allowed = false },

  { pattern = "secrets/*", allowed = false },
  { pattern = "*.secrets/*", allowed = false },
  { pattern = "secrets.*/*", allowed = false },
  { pattern = "*.secrets.*/*", allowed = false },
}

---@param path string
---@return boolean
local function is_ignored(path)
  local ignore_files = fs.find_ancestors(path, { ".copilotignore" })

  -- Allow only in repos with .copilotignore.
  if #ignore_files <= 0 then
    return true
  end

  ---@type utils.ignore.Ignore
  local patterns = {}

  -- Add default patterns.
  for _, p in ipairs(default_patterns) do
    table.insert(patterns, p)
  end

  -- Read all ignore files.
  -- Read them in reverse.
  for i = #ignore_files, 1, -1 do
    local ignore_file = ignore_files[i]
    local content = fs.read(ignore_file .. fs.sep .. ".copilotignore")

    local file_patterns = ignore.parse(content)
    for _, p in ipairs(file_patterns) do
      -- Patch the pattern.
      local first = string.sub(p.pattern, 1, 1)
      if first == "/" or first == fs.sep then
        p.pattern = ignore_file .. p.pattern
      else
        p.pattern = ignore_file .. fs.sep .. "**" .. fs.sep .. p.pattern
      end

      table.insert(patterns, p)
    end
  end

  -- Disable by default.
  local allowed = false
  for _, p in ipairs(patterns) do
    if ignore.matches(p.pattern, path) then
      allowed = p.allowed
    end
  end

  return not allowed
end

---@return boolean
local function is_enabled_for_file()
  local path = vim.fn.expand("%:p")

  -- Check if file is disabled in `.copilotignore`.
  if is_ignored(path) then
    return false
  end

  return true
end

--------------------------------------------------------------------------------
-- Modules
--------------------------------------------------------------------------------
M.lazy = true

M.cmd = "Copilot"

M.config = function()
  if vim.fn.executable("bubblewrap-copilot") ~= 1 then
    return
  end

  require("copilot").setup({
    copilot_node_command = "bubblewrap-copilot",
    server_opts_overrides = {
      cmd = {
        "bubblewrap-copilot",
        "/opt/copilot/index.js",
      },

      trace = "verbose",

      settings = {
        advanced = {
          inlineSuggestCount = 3,
        },
      },
    },

    suggestion = { enabled = false }, -- Use copilot-cmp instead.
    panel = { enabled = false }, -- Use copilot-cmp instead.

    filetypes = {
      ["*"] = is_enabled_for_file,
    },
  })

  -- Setup copilot-cmp.
  -- require("copilot_cmp").setup()
end

--------------------------------------------------------------------------------
-- Export
--------------------------------------------------------------------------------
return M
