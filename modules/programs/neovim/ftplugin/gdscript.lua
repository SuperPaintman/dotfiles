local undo_opts = {}
local set_local = function(name, value)
  vim.opt_local[name] = value
  undo_opts[name] = true
end

local append_local = function(name, value)
  vim.opt_local[name]:append(value)
  undo_opts[name] = true
end

local remove_local = function(name, value)
  vim.opt_local[name]:remove(value)
  undo_opts[name] = true
end

set_local("expandtab", false)
set_local("shiftwidth", 0)
set_local("softtabstop", 0)
set_local("tabstop", 4)
set_local("suffixesadd", ".gd")
set_local("comments", "b:#")
set_local("commentstring", "# %s")
remove_local("cinkeys", "0#")
remove_local("indentkeys", "0#")

remove_local("formatoptions", "t") -- Auto-wrap text using 'textwidth'.
append_local("formatoptions", "c") -- Auto-wrap comments using 'textwidth'.
append_local("formatoptions", "r") -- Automatically insert the current comment leader after hitting <Enter> in Insert mode.
append_local("formatoptions", "o") -- Automatically insert the current comment leader after hitting 'o' or 'O' in Normal mode.
append_local("formatoptions", "q") -- Allow formatting of comments with "gq".
append_local("formatoptions", "l") -- Long lines are not broken in insert mode.

-- Undo local options.
vim.b.undo_ftplugin = "setlocal "
  .. table.concat(
    vim.tbl_map(function(name)
      return name .. "<"
    end, vim.tbl_keys(undo_opts)),
    " "
  )
