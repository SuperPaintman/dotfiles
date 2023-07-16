--------------------------------------------------------------------------------
-- Init
--------------------------------------------------------------------------------
local M = {
  _initialized = false,
}

local cb = require("utils.mappings").create_callback_factory(
  M,
  "telescope is not initialized"
)

--------------------------------------------------------------------------------
-- Modules
--------------------------------------------------------------------------------
M.config = function()
  require("telescope").setup({})
  M._initialized = true
end

M.mappings = {
  find_buffers = cb(function()
    require("telescope.builtin").buffers()
  end),

  find_files = cb(function()
    require("telescope.builtin").find_files()
  end),

  find_words = cb(function()
    require("telescope.builtin").live_grep()
  end),

  find_help_tags = cb(function()
    require("telescope.builtin").help_tags()
  end),

  find_recent_files = cb(function()
    require("telescope.builtin").oldfiles()
  end),
}

--------------------------------------------------------------------------------
-- Export
--------------------------------------------------------------------------------
return M
