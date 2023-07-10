-- See: https://github.com/nvim-lualine/lualine.nvim
--------------------------------------------------------------------------------
-- Init
--------------------------------------------------------------------------------
local M = {}

-- TODO(SuperPaintman): Check OS separator.
local SEP = "/"
local HOME = vim.env.HOME or ""

-- TODO(SuperPaintman): Use colors from the theme.
-- See: https://github.com/catppuccin/nvim/blob/main/lua/catppuccin/palettes/mocha.lua
local colors = {
  rosewater = "#f5e0dc",
  flamingo = "#f2cdcd",
  pink = "#f5c2e7",
  mauve = "#cba6f7",
  red = "#f38ba8",
  maroon = "#eba0ac",
  peach = "#fab387",
  yellow = "#f9e2af",
  green = "#a6e3a1",
  teal = "#94e2d5",
  sky = "#89dceb",
  sapphire = "#74c7ec",
  blue = "#89b4fa",
  lavender = "#b4befe",
  text = "#cdd6f4",
  subtext1 = "#bac2de",
  subtext0 = "#a6adc8",
  overlay2 = "#9399b2",
  overlay1 = "#7f849c",
  overlay0 = "#6c7086",
  surface2 = "#585b70",
  surface1 = "#45475a",
  surface0 = "#313244",
  base = "#1e1e2e",
  mantle = "#181825",
  crust = "#11111b",
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
  local clients = vim.lsp.get_active_clients()
  if #clients <= 0 then
    return false
  end

  local filetype = vim.api.nvim_buf_get_option(0, "filetype")

  for _, client in ipairs(clients) do
    local filetypes = client.config.filetypes
    if filetypes and vim.fn.index(filetypes, filetype) ~= -1 then
      return true
    end
  end

  return false
end

local function mode_color(theme)
  if theme == nil then
    theme = require("lualine.themes.auto")
  end

  local mode = require("lualine.highlight").get_mode_suffix()
  if mode == nil then
    return nil
  end

  mode = string.sub(mode, 2)

  local mode_colors = theme[mode]
  if mode_colors == nil then
    return nil
  end

  local section_colors = mode_colors.a
  if section_colors == nil then
    return nil
  end

  return section_colors.bg
end

--------------------------------------------------------------------------------
-- Modules
--------------------------------------------------------------------------------
M.config = function()
  -- Imports.
  local theme = require("lualine.themes.auto")

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
      return { fg = mode_color(theme) }
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

  -- Lsp servers.
  insert_right({
    function()
      local filetype = vim.api.nvim_buf_get_option(0, "filetype")
      local clients = vim.lsp.get_active_clients()

      local names = {}
      for _, client in ipairs(clients) do
        local filetypes = client.config.filetypes
        if filetypes and vim.fn.index(filetypes, filetype) ~= -1 then
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
      -- Theme.
      theme = theme,

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
