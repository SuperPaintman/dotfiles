-- See: https://github.com/goolord/alpha-nvim
--------------------------------------------------------------------------------
-- Init
--------------------------------------------------------------------------------
local M = {}

--------------------------------------------------------------------------------
-- Helpers
--------------------------------------------------------------------------------
local function can_restore_last_session()
  -- TODO(SuperPaintman): check if session is available.

  local ok, _ = pcall(require, "auto-session")
  return ok
end

local function restore_last_session()
  local autosession = require("auto-session")
  autosession.RestoreSession()
end

local function can_open_file_explorer()
  local ok, _ = pcall(require, "nvim-tree.api")
  return ok
end

local function open_file_explorer()
  local nvimtree_api = require("nvim-tree.api")
  nvimtree_api.tree.open({
    current_window = true,
  })
end

--- @param sc string
--- @param txt string
--- @param keybind string?
--- @param keybind_opts table?
local function button(sc, txt, keybind, keybind_opts)
  local opts = {
    position = "center",
    shortcut = sc,
    cursor = 3,
    width = 50,
    align_shortcut = "right",
    hl_shortcut = "Keyword",
  }
  if keybind then
    keybind_opts = keybind_opts
      or { noremap = true, silent = true, nowait = true }
    opts.keymap = { "n", sc, keybind, keybind_opts }
  end

  local function on_press()
    if keybind_opts ~= nil and keybind_opts.callback ~= nil then
      keybind_opts.callback()
    else
      local key = vim.api.nvim_replace_termcodes(
        keybind or sc .. "<Ignore>",
        true,
        false,
        true
      )
      vim.api.nvim_feedkeys(key, "t", false)
    end
  end

  return {
    type = "button",
    val = txt,
    on_press = on_press,
    opts = opts,
  }
end

local function logo()
  return {
    type = "text",
    val = {
      [[      .          .      ]],
      [[    ';;,.        ::'    ]],
      [[  ,:::;,,        :ccc,  ]],
      [[ ,::c::,,,,.     :cccc, ]],
      [[ ,cccc:;;;;;.    cllll, ]],
      [[ ,cccc;.;;;;;,   cllll; ]],
      [[ :cccc; .;;;;;;. coooo; ]],
      [[ ;llll;   ,:::::'loooo; ]],
      [[ ;llll:    ':::::loooo: ]],
      [[ :oooo:     .::::llodd: ]],
      [[ .;ooo:       ;cclooo:. ]],
      [[   .;oc        'coo;.   ]],
      [[     .'         .,.     ]],
    },
    opts = {
      position = "center",
      hl = "Comment",
    },
  }
end

local cats = {
  { [[ฅ^•ﻌ•^ฅ]] },
  { [[(=^･ω･^=)]] },
  { [[(=ච ω ච=)]] },
  { [[(= ФェФ=)]] },
}

local function cat()
  local idx = math.floor(#cats * math.random()) + 1

  return {
    type = "text",
    val = cats[idx],
    opts = {
      position = "center",
      hl = "Comment",
    },
  }
end

local function header()
  return {
    type = "text",
    val = {
      [[ ███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗ ]],
      [[ ████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║ ]],
      [[ ██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║ ]],
      [[ ██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║ ]],
      [[ ██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║ ]],
      [[ ╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝ ]],
    },
    opts = {
      position = "center",
      hl = "Comment",
    },
  }
end

local function buttons()
  local val = {}

  -- New file.
  table.insert(val, button("e", "  New file", "<cmd>ene <CR>"))

  -- Restore last session.
  if can_restore_last_session() then
    table.insert(
      val,
      button("s", "  Restore last session", "", {
        callback = restore_last_session,
        noremap = true,
        silent = true,
        nowait = true,
      })
    )
  end

  -- Open file explorer.
  if can_open_file_explorer() then
    table.insert(
      val,
      button("f", "  Open file explorer", "", {
        callback = open_file_explorer,
        noremap = true,
        silent = true,
        nowait = true,
      })
    )
  end

  return {
    type = "group",
    val = val,
    opts = {
      spacing = 1,
    },
  }
end

local function footer()
  return {
    type = "text",
    val = "",
    opts = {
      position = "center",
      hl = "Type",
    },
  }
end

--------------------------------------------------------------------------------
-- Modules
--------------------------------------------------------------------------------
M.config = function()
  require("alpha").setup({
    layout = {
      { type = "padding", val = 10 },
      header(),
      { type = "padding", val = 1 },
      cat(),
      { type = "padding", val = 1 },
      buttons(),
      { type = "padding", val = 10 },
      footer(),
    },
    opts = {
      margin = 5,
    },
  })
end

--------------------------------------------------------------------------------
-- Export
--------------------------------------------------------------------------------
return M
