--------------------------------------------------------------------------------
-- Imports
--------------------------------------------------------------------------------
local ui = require("core.ui")

--------------------------------------------------------------------------------
-- Init
--------------------------------------------------------------------------------
local M = {
  _initialized = false,
}

local cb = require("utils.mappings").create_callback_factory(
  M,
  "lspsaga is not initialized"
)

--------------------------------------------------------------------------------
-- Modules
--------------------------------------------------------------------------------
M.dependencies = {
  "neovim/nvim-lspconfig",
  "nvim-treesitter/nvim-treesitter", -- optional
  "nvim-tree/nvim-web-devicons", -- optional
}

M.config = function()
  require("lspsaga").setup({
    ui = {
      border = ui.borders.thick(),
      title = false,
      code_action = ui.icons.diagnostic.Hint,
    },
    code_action = {
      keys = {
        quit = { "<Esc>", "<C-c>" },
        exec = "<CR>",
      },
    },
    lightbulb = {
      enable = true,
      sign = true,
      virtual_text = false,
      enable_in_insert = false,
    },
    rename = {
      keys = {
        quit = { "<Esc>", "<C-c>" },
        exec = "<CR>",
        select = "x",
      },
    },
    symbol_in_winbar = {
      enable = false,
    },
    beacon = {
      enable = false,
    },
  })

  M._initialized = true
end

M.mappings = {
  rename = cb(function()
    require("lspsaga.rename"):lsp_rename()
  end),

  code_action = cb(function()
    require("lspsaga.codeaction"):code_action()
  end),
}

--------------------------------------------------------------------------------
-- Export
--------------------------------------------------------------------------------
return M
