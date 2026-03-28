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

set_local("commentstring", "# %s")

-- Undo local options.
vim.b.undo_ftplugin = "setlocal "
    .. table.concat(
      vim.tbl_map(function(name)
        return name .. "<"
      end, vim.tbl_keys(undo_opts)),
      " "
    )
