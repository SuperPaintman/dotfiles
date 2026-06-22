--------------------------------------------------------------------------------
-- Init
--------------------------------------------------------------------------------
---@class modules.quickfix.Module
local M = {
  _initialized = false,
}

local autocmd = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup

local cb = require("utils.mappings").create_callback_factory(
  M,
  "quickfix is not initialized"
)

--------------------------------------------------------------------------------
-- Modules
--------------------------------------------------------------------------------
---@class modules.quickfix.Config
M.defaults = {
}

---@type modules.quickfix.Config
M.options = vim.tbl_deep_extend("force", M.defaults, {})

---@param opts modules.quickfix.Config?
M.setup = function(opts)
  M.options = vim.tbl_deep_extend("force", M.defaults, opts or {})

  autocmd("FileType", {
    group = augroup("QuickFixInit", { clear = true }),
    pattern = "qf",
    callback = function()
      vim.wo.winhighlight = table.concat({
        "Normal:QuickFixNormal",
        "NormalNC:QuickFixNormalNC",
      }, ",")

      local is_loclist = vim.fn.getloclist(0, { filewinid = 0 }).filewinid ~= 0
      if is_loclist then
        return
      end

      -- vim.cmd("wincmd L")
      -- vim.cmd("vertical resize 80")

      vim.cmd("wincmd J")
      vim.cmd("resize 15")
    end,
  })

  M._initialized = true
end

M.reload = function()
  M.setup(M.options)
end

M.mappings = {
  open = cb(function()
    for _, win in ipairs(vim.fn.getwininfo()) do
      if win.quickfix == 1 then
        vim.api.nvim_set_current_win(win.winid)
        return
      end
    end
    vim.cmd("copen")
  end),

  close = cb(function()
    vim.cmd("cclose")
  end),

  clean = cb(function()
    vim.fn.setqflist({})
    vim.cmd("cclose")
  end),

  next = cb(function()
    local ok = pcall(function()
      vim.cmd("cnext")
    end)
    if ok then
      return
    end

    pcall(function()
      vim.cmd("cfirst")
    end)
  end),

  prev = cb(function()
    local ok = pcall(function()
      vim.cmd("cprev")
    end)
    if ok then
      return
    end

    pcall(function()
      vim.cmd("clast")
    end)
  end),
}

--------------------------------------------------------------------------------
-- Export
--------------------------------------------------------------------------------
return M
