-- See: https://github.com/mfussenegger/nvim-dap/wiki/Debug-Adapter-installation
--------------------------------------------------------------------------------
-- Imports
--------------------------------------------------------------------------------
local ui = require("core.ui")

--------------------------------------------------------------------------------
-- Init
--------------------------------------------------------------------------------
local M = {}

local autocmd = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup
local command = vim.api.nvim_create_user_command

local signs = {
  {
    name = "DapBreakpoint",
    text = ui.icons.debugger.Breakpoint,
  },
  {
    name = "DapBreakpointCondition",
    text = ui.icons.debugger.BreakpointCondition,
  },
  {
    name = "DapBreakpointRejected",
    text = ui.icons.debugger.BreakpointRejected,
  },
  {
    name = "DapLogPoint",
    text = ui.icons.debugger.Logpoint,
  },
  {
    name = "DapStopped",
    text = ui.icons.debugger.Stopped,
    linehl = "DapStoppedLine",
    numhl = "DapStoppedLineNr",
  },
}

--------------------------------------------------------------------------------
-- Helpers
--------------------------------------------------------------------------------
local function add_to_jumplist()
  vim.cmd([[normal! m']]) -- Add the current position to the jump list.
end

--------------------------------------------------------------------------------
-- Adapters
--------------------------------------------------------------------------------
---@see https://github.com/mfussenegger/nvim-dap/wiki/Debug-Adapter-installation#go
---@see https://github.com/leoluz/nvim-dap-go/blob/main/lua/dap-go.lua
local function setup_adapter_go(dap)
  if not dap then
    dap = require("dap")
  end

  ---@alias dap.DelveConfiguration
  ---| dap.Configuration
  ---| { host?: string; port?: number | string }

  -- Adapter.
  ---@param callback fun(adapter: dap.Adapter)
  ---@param client_config dap.DelveConfiguration
  dap.adapters.delve = function(callback, client_config)
    client_config = client_config or {}

    local host = client_config.host or "127.0.0.1"
    local port = client_config.port or "${port}"

    ---@type dap.Adapter
    local adapter = {
      type = "server",
      port = port,
      executable = {
        command = "dlv", -- TODO(SuperPaintman): take the command from the config.
        args = {
          "dap",
          "-l",
          host .. ":" .. port,
          "--log",
          "--log-output=dap",
        },
        detached = vim.fn.has("win32") == 0,
      },
      options = {
        initialize_timeout_sec = 30,
      },
    }

    callback(adapter)
  end

  -- Configurations.
  ---@see https://github.com/go-delve/delve/blob/master/Documentation/usage/dlv_dap.md
  dap.configurations.go = {
    {
      type = "delve",
      name = "Debug",
      request = "launch",
      program = "./${relativeFileDirname}",
    },
    {
      type = "delve",
      name = "Debug File",
      request = "launch",
      program = "${file}",
    },
    {
      type = "delve",
      name = "Debug Test",
      request = "launch",
      mode = "test",
      program = "./${relativeFileDirname}",
    },
    {
      type = "delve",
      name = "Debug Test File",
      request = "launch",
      mode = "test",
      program = "${file}",
    },
  }
end

--------------------------------------------------------------------------------
-- Modules
--------------------------------------------------------------------------------
M.dependencies = {
  "rcarriga/nvim-dap-ui",
  "theHamsta/nvim-dap-virtual-text",
  "nvim-neotest/nvim-nio",
}

M.lazy = true

M.cmd = {
  "DapVirtualTextForceRefresh",
  "DapVirtualTextDisable",
  "DapVirtualTextToggle",
  "DapVirtualTextEnable",
  "DapClearBreakpoints",
  "DapToggleBreakpoint",
  "DapRestartFrame",
  "DapSetLogLevel",
  "DapToggleRepl",
  "DapDisconnect",
  "DapTerminate",
  "DapStepOver",
  "DapStepInto",
  "DapContinue",
  "DapStepOut",
  "DapShowLog",
  "DapEval",
  "DapNew",
}

M.config = function()
  local dap = require("dap")
  local dapui = require("dapui")

  -- Define diagnostic sings.
  for _, sign in pairs(signs) do
    vim.fn.sign_define(sign.name, {
      texthl = sign.name,
      text = sign.text,
      linehl = sign.linehl,
      numhl = sign.numhl,
    })
  end

  -- Set window-specific configs.
  autocmd("BufEnter", {
    group = augroup("ConfigsNvimDapUIOptions", { clear = true }),
    pattern = "DAP Scopes",
    callback = function()
      local winid = vim.api.nvim_get_current_win()

      -- Disable column highlighting.
      vim.wo[winid].colorcolumn = false

      -- Hide special characters.
      vim.wo[winid].list = false
      vim.wo[winid].listchars = false
    end,
  })

  -- Patch the DapToggleBreakpoint command.
  --
  -- In addition to adding a breakpoint, it pins the buffer, and adds
  -- the location to the jump list.
  command("DapToggleBreakpoint", function()
    dap.toggle_breakpoint()
    vim.cmd([[silent! BufferLinePin]])
    add_to_jumplist()
  end, { nargs = 0 })

  -- Adapters.
  --- Go.
  setup_adapter_go(dap)

  dapui.setup({
    icons = {
      expanded = ui.icons.common.Expanded,
      collapsed = ui.icons.common.Collapsed,
      -- TODO(SuperPaintman): use custom icon for the current frame.
      current_frame = ui.icons.common.Collapsed,
    },
  })

  local layout_sidebar = 1
  local layout_repl = 2
  dap.listeners.after.event_initialized["dapui_config"] = function()
    dapui.open({ layout = layout_sidebar })
    -- dapui.open({ layout = layout_repl })
  end

  dap.listeners.before.event_terminated["dapui_config"] = function()
    dapui.close({ layout = layout_sidebar })
    -- dapui.close({ layout = layout_repl })
  end

  dap.listeners.before.event_exited["dapui_config"] = function()
    dapui.close({ layout = layout_sidebar })
    -- dapui.close({ layout = layout_repl })
  end

  -- Add locations to the jumplist.
  for _, event in pairs({
    "event_initialized",
    "continue", -- Continue.
    "event_continued", -- Step Over.
    "stepIn", -- Step Into.
    "stepOut", -- Step Out.
  }) do
    dap.listeners.after[event]["jumplist"] = function()
      add_to_jumplist()
    end
  end

  require("nvim-dap-virtual-text").setup({
    enabled = true,
    enabled_commands = true,
    highlight_changed_variables = false,
    only_first_definition = false,
    all_references = false,
    display_callback = function(variable, buf, stackframe, node, options)
      if options.virt_text_pos == "inline" then
        return " = " .. variable.value:gsub("%s+", " ") .. " "
      else
        return " "
          .. variable.name
          .. " = "
          .. variable.value:gsub("%s+", " ")
          .. " "
      end
    end,
  })
end

--------------------------------------------------------------------------------
-- Export
--------------------------------------------------------------------------------
return M
