-- See: https://github.com/mfussenegger/nvim-dap/wiki/Debug-Adapter-installation
--------------------------------------------------------------------------------
-- Imports
--------------------------------------------------------------------------------
local ui = require("core.ui")
local fs = require("utils.fs")

--------------------------------------------------------------------------------
-- Init
--------------------------------------------------------------------------------
local M = {}

local autocmd = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup
local command = vim.api.nvim_create_user_command

local ts_utils = nil
local ts_locals = nil

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

---@type (fun(bufnr: number, configs: dap.Configuration[]): dap.Configuration[])?
local config_filter = nil

--------------------------------------------------------------------------------
-- Helpers
--------------------------------------------------------------------------------
local function add_to_jumplist()
  vim.cmd([[normal! m']]) -- Add the current position to the jump list.
end

local function init_treesitter()
  if vim.treesitter == nil then
    return false
  end

  if ts_utils == nil then
    local ok, pkg = pcall(require, "nvim-treesitter.ts_utils")
    if not ok then
      return false
    end
    ts_utils = pkg
  end

  if ts_locals == nil then
    local ok, pkg = pcall(require, "nvim-treesitter.locals")
    if not ok then
      return false
    end
    ts_locals = pkg
  end

  return true
end

local treesitter_go_query_is_set = false
local function set_treesitter_go_query()
  if treesitter_go_query_is_set then
    return
  end

  treesitter_go_query_is_set = true
  if vim.treesitter == nil then
    return
  end

  vim.treesitter.query.set(
    "go",
    "nvim_dap_go_function_name",
    [[ 
      [
        (function_declaration name: (_) @name)
      ]
    ]]
  )
end

---@param bufnr number
---@return TSNode[]
local function get_scope_tree_at_cursor(bufnr)
  if not init_treesitter() then
    return {}
  end

  local cursor_node = ts_utils.get_node_at_cursor(0, true)
  if cursor_node == nil then
    return {}
  end

  local scope = ts_locals.get_scope_tree(cursor_node, bufnr)
  return scope
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
      name = "Debug Test",
      request = "launch",
      mode = "test",
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
      name = "Debug Test File",
      request = "launch",
      mode = "test",
      program = "${file}",
    },
  }
end

---@param bufnr number
---@param configs dap.Configuration[]
---@return dap.Configuration[]
local function smart_config_filter_go(bufnr, configs)
  local fullname = vim.api.nvim_buf_get_name(bufnr)
  local basename = vim.fs.basename(fullname)

  local is_module = fs.find_ancestor(fullname, { "go.mod" }) ~= nil
  local is_test_file = string.match(basename, "_test%.go$") ~= nil

  local best_option = ""
  if is_module then
    if is_test_file then
      best_option = "Debug Test"
    else
      best_option = "Debug"
    end
  else
    if is_test_file then
      best_option = "Debug Test File"
    else
      best_option = "Debug File"
    end
  end

  -- TODO(SuperPaintman):
  --     Run the test under the cursor. Refactor it!
  --
  --     See: https://github.com/golang/vscode-go/blob/5e506ea7347210ea5003a87f929394b299102962/extension/src/goTest.ts#L275-L275
  --     See: https://github.com/golang/vscode-go/blob/5e506ea7347210ea5003a87f929394b299102962/extension/src/testUtils.ts#L250-L250

  set_treesitter_go_query()
  local scope = get_scope_tree_at_cursor(bufnr)
  local query = (vim.fn.has("nvim-0.9") == 1)
    and vim.treesitter.query.get("go", "nvim_dap_go_function_name")

  local function_name = ""
  if query then
    for _, node in ipairs(scope) do
      if node:type() == "function_declaration" then
        for _, n in query:iter_captures(node, 0) do
          function_name = vim.treesitter.get_node_text(n, 0)
          break
        end
      end
    end
  end

  if best_option ~= "" then
    for _, config in ipairs(configs) do
      if config.name == best_option then
        if is_test_file and string.match(function_name, "^Test") then
          local new_config = vim.tbl_deep_extend("force", {}, config, {
            args = {
              "-test.run",
              "^" .. function_name .. "$",
            },
          })

          return { new_config }
        elseif is_test_file and string.match(function_name, "^Benchmark") then
          local new_config = vim.tbl_deep_extend("force", {}, config, {
            args = {
              "-test.bench",
              "^" .. function_name .. "$",
              "-test.run",
              "^$",
            },
          })

          return { new_config }
        end

        return { config }
      end
    end
  end

  return configs
end

---@param bufnr number
---@param configs dap.Configuration[]
---@return dap.Configuration[]
local function smart_config_filter(bufnr, configs)
  local filetype = vim.bo[bufnr].filetype
  if filetype == "go" then
    return smart_config_filter_go(bufnr, configs)
  else
    return configs
  end
end

local function smart_continue(dap)
  if not dap then
    dap = require("dap")
  end

  -- Check if we already have an active / stopped session.
  local session = dap.session()
  if session then
    config_filter = nil
  else
    config_filter = smart_config_filter
  end

  dap.continue()
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

  -- Custom.
  "DapSmartContinue",
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

  -- Patch the configs providers.
  --
  -- Add config filtering to support smart continue.
  local orig_dap_global = dap.providers.configs["dap.global"]
  dap.providers.configs["dap.global"] = function(bufnr, ...)
    local configurations = orig_dap_global(bufnr, ...)

    if config_filter then
      configurations = config_filter(bufnr, configurations)
    end

    return configurations
  end

  local orig_dap_launch_json = dap.providers.configs["dap.launch.json"]
  dap.providers.configs["dap.launch.json"] = function(bufnr, ...)
    local configurations = orig_dap_launch_json(bufnr, ...)

    if config_filter then
      configurations = config_filter(bufnr, configurations)
    end

    return configurations
  end

  -- Add custom commands.
  command("DapSmartContinue", function()
    smart_continue(dap)
  end, { nargs = 0 })

  command("DapContinue", function()
    config_filter = nil
    dap.continue()
  end, { nargs = 0 })

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
