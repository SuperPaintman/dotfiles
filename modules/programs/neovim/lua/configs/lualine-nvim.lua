-- See: https://github.com/nvim-lualine/lualine.nvim
--------------------------------------------------------------------------------
-- Imports
--------------------------------------------------------------------------------
local autoformat = require("modules.autoformat")
-- TODO(SuperPaintman): Use links instead of colors.
local colors = require("theme.palette").colors

--------------------------------------------------------------------------------
-- Init
--------------------------------------------------------------------------------
local M = {}

-- TODO(SuperPaintman): Check OS separator.
local SEP = "/"
local HOME = vim.env.HOME or ""

-- TODO(SuperPaintman): Use links instead of colors.
local MODE_COLORS = {
  normal = colors.blue,
  insert = colors.green,
  terminal = colors.green,
  command = colors.yellow,
  visual = colors.magenta,
  replace = colors.red,
}

--------------------------------------------------------------------------------
-- Helpers
--------------------------------------------------------------------------------
local function const(v)
  return function()
    return v
  end
end

local _filepath_cache = {}
-- TODO(SuperPaintman): Add colors.
local function filepath()
  local path = vim.fn.expand("%")

  local cached = _filepath_cache[path]
  if cached ~= nil then
    return cached
  end

  -- Normalize path.
  path = vim.fs.normalize(path)

  if HOME ~= nil then
    if vim.startswith(path, HOME) then
      path = string.sub(path, #HOME + 1)
      if not vim.startswith(path, SEP) then
        path = SEP .. path
      end
      path = "~" .. path
    end
  end

  -- Fishify path.
  local parts = vim.split(path, SEP)

  for ii = 2, #parts do
    local i = ii - 1
    local part = parts[i]

    if vim.startswith(part, ".") or vim.startswith(part, "_") then
      parts[i] = string.sub(part, 0, 2)
    else
      parts[i] = string.sub(part, 0, 1)
    end
  end

  local res = table.concat(parts, SEP)
  _filepath_cache[path] = res
  return res
end

local function is_nvimtree_buffer()
  local name = vim.fn.expand("%")
  return vim.startswith(name, "NvimTree_")
end

local function has_lsp_server()
  local bufnr = vim.api.nvim_get_current_buf()
  local clients = vim.lsp.get_active_clients({ bufnr = bufnr })
  return #clients > 0
end

local function mode_color()
  local mode = require("lualine.highlight").get_mode_suffix()
  if mode == nil then
    return nil
  end

  mode = string.sub(mode, 2)
  return MODE_COLORS[mode]
end

local function create_hl(tag, options, color)
  local highlight = require("lualine.highlight")

  local hl =
    highlight.create_component_highlight_group(color, tag, options, false)

  return highlight.component_format_highlight(hl)
end

local function lazy_hl(tag, color)
  local hl = nil
  return function(options)
    if hl == nil then
      hl = create_hl(tag, options, color)
    end
    return hl
  end
end

local function indicator(status, fmt, color)
  if type(fmt) == "table" then
    local fmt_on = fmt.on
    local fmt_off = fmt.off
    fmt = function(enabled)
      if enabled then
        return fmt_on
      else
        return fmt_off
      end
    end
  end

  if type(color) == "table" then
    local color_on = lazy_hl("indicator_on", color.on)
    local color_off = lazy_hl("indicator_off", color.off)
    color = function(enabled)
      if enabled then
        return color_on
      else
        return color_off
      end
    end
  end

  return function(self)
    local hl = nil
    local text = ""
    if status(self) then
      hl = color(true)(self.options)
      text = fmt(true)
    else
      hl = color(false)(self.options)
      text = fmt(false)
    end
    return hl .. text
  end
end

--------------------------------------------------------------------------------
-- Modules
--------------------------------------------------------------------------------
M.config = function()
  -- Init.
  local sections = {
    lualine_a = {},
    lualine_b = {},
    lualine_c = {},
    lualine_x = {},
    lualine_y = {},
    lualine_z = {},
  }
  local inactive_sections = {
    lualine_a = {},
    lualine_b = {},
    lualine_c = {},
    lualine_x = {},
    lualine_y = {},
    lualine_z = {},
  }

  -- Helpers.
  local function insert_section(component, section)
    if section == nil then
      section = "a"
    end

    table.insert(sections["lualine_" .. section], component)
  end

  local function insert_left(component)
    return insert_section(component, "c")
  end

  local function insert_right(component)
    return insert_section(component, "x")
  end

  -- Config the left section.
  --- Marker
  insert_left({
    const("▊"),
    color = { fg = colors.blue },
    padding = { right = 1 },
  })

  --- Mode
  insert_left({
    const(""),
    color = function()
      return { fg = mode_color() }
    end,
    padding = { right = 1 },
  })

  --- Filename
  insert_left({
    -- "filename",
    filepath,
    color = { fg = colors.green, gui = "bold" },
    cond = function()
      return not is_nvimtree_buffer()
    end,
  })

  --- Location
  insert_left({
    "location",
    cond = function()
      return not is_nvimtree_buffer()
    end,
  })

  --- Progress
  insert_left({
    "progress",
    cond = function()
      return not is_nvimtree_buffer()
    end,
  })

  -- Config the right section.
  --- Encoding
  insert_right({
    "encoding",
    cond = function()
      return not is_nvimtree_buffer()
    end,
  })

  --- File type
  insert_right({
    "filetype",
    color = { fg = colors.blue, gui = "bold" },
    cond = function()
      return not is_nvimtree_buffer()
    end,
  })

  --- Autoformat.
  insert_right({
    indicator(
      autoformat.enabled,
      { on = "", off = "" },
      { on = { fg = colors.green }, off = { fg = colors.red } }
    ),
    cond = function()
      return not is_nvimtree_buffer()
    end,
  })

  -- Copilot.
  insert_right({
    indicator(
      function()
        local bufnr = vim.api.nvim_get_current_buf()
        local clients =
          vim.lsp.get_active_clients({ bufnr = bufnr, name = "copilot" })
        return #clients > 0
      end,
      { on = "", off = "" },
      { on = { fg = colors.green }, off = { fg = colors.red } }
    ),
    cond = function()
      return not is_nvimtree_buffer()
    end,
  })

  -- Lsp servers.
  insert_right({
    function()
      local bufnr = vim.api.nvim_get_current_buf()
      local clients = vim.lsp.get_active_clients({ bufnr = bufnr })

      local names = {}
      for _, client in ipairs(clients) do
        if client.name ~= "copilot" then
          table.insert(names, client.name)
        end
      end

      return table.concat(names, " ")
    end,
    -- color = { gui = "bold" },
    cond = function()
      return not (is_nvimtree_buffer() and has_lsp_server())
    end,
  })

  --- Branch
  insert_right({
    "branch",
    icon = "",
    color = { fg = colors.green, gui = "bold" },
  })

  --- Diff
  insert_right({
    "diff",
    cond = function()
      -- NOTE(SuperPaintman):
      --     For some reason diff disappears in NvimTree. So we disable it
      --     preemptively.
      return not is_nvimtree_buffer()
    end,
  })

  --- Diagnostics
  insert_right({
    "diagnostics",
    -- TODO(SuperPaintman): Add custom symbols.
    symbols = {},
    cond = function()
      return not is_nvimtree_buffer()
    end,
  })

  --- Marker
  insert_right({
    const("▊"),
    color = { fg = colors.blue },
    padding = { left = 1 },
  })

  -- Setup.
  require("lualine").setup({
    options = {
      -- Disable sections and component separators.
      component_separators = "",
      section_separators = "",
    },
    sections = sections,
    inactive_sections = inactive_sections,
  })
end

--------------------------------------------------------------------------------
-- Export
--------------------------------------------------------------------------------
return M
