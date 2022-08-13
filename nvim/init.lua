------------------------------------------------------------------------------
-- Init the default Vim config.
--------------------------------------------------------------------------------
local cmd = vim.cmd
local opt = vim.opt
local api = vim.api
local fn = vim.fn

local expand = fn.expand
local isdirectory = fn.isdirectory
local filereadable = fn.filereadable

if isdirectory(expand("~/.vim")) then
  -- Use ~/.vim as the runtime path.
  opt.runtimepath:prepend { expand("~/.vim"), expand("~/.vim/after") }
end

if filereadable(expand("~/.vimrc")) then
  vim.cmd("source " .. expand("~/.vimrc"))
end

api.nvim_create_user_command(
    'Eval',
    function(opts)
      local filetype = vim.bo.filetype
      if filetype ~= "lua" and filetype ~= "vim" then
        return
      end

      local line1 = opts.line1
      local line2 = opts.line2

      local lines = api.nvim_buf_get_lines(0, line1 - 1, line2, false)
      local source = table.concat(lines, "\n")
      
      if filetype == "lua" then
        local f = loadstring(source)
        f()
      else
        api.nvim_exec(source, false)
      end
    end,
    {
      -- nargs = "*",
      range = "%"
    }
)
