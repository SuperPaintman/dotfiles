--------------------------------------------------------------------------------
-- Init
--------------------------------------------------------------------------------
local autocmd = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup
local command = vim.api.nvim_create_user_command

local M = {}

--------------------------------------------------------------------------------
-- Helpers
--------------------------------------------------------------------------------
local function supports_format(client)
  -- client.server_capabilities.documentFormattingProvider

  if
    client.config
    and client.config.capabilities
    and client.config.capabilities.documentFormattingProvider == false
  then
    return false
  end
  return client.supports_method("textDocument/formatting")
    or client.supports_method("textDocument/rangeFormatting")
end

--------------------------------------------------------------------------------
-- Modules
--------------------------------------------------------------------------------
---@class AutoFormatConfig
M.defaults = {
  enabled = true,
  preferred = {
    css = "null-ls", -- prettier
    go = "null-ls", -- goimports
    html = "null-ls", -- prettier
    json = "null-ls", -- prettier
    nix = "nixd",
    terraform = "terraformls",
    yaml = "null-ls", -- prettier
    default = "null-ls",
  },
}

---@type AutoFormatConfig
M.options = {}

M.toggle = function()
  M.options.enabled = not M.options.enabled
end

M.enabled = function()
  return M.options.enabled
end

---@param opts? {force?:boolean, buf?:number, filetype?:string, preferred?:string}
M.format = function(opts)
  local force = opts and opts.force or false
  if not force and not M.options.enabled then
    return
  end

  local buf = opts and opts.buf
  if buf == nil then
    buf = vim.api.nvim_get_current_buf()
  end

  local filetype = opts and opts.filetype
  if filetype == nil then
    filetype = vim.bo.filetype
  end

  local preferred = opts and opts.preferred
  if preferred == nil then
    preferred = M.options.preferred[filetype] or M.options.preferred.default
  end

  local clients = vim.lsp.get_active_clients({ bufnr = buf })

  -- Find the client id.
  local available_id = nil
  local preferred_id = nil
  for _, client in ipairs(clients) do
    if supports_format(client) then
      if preferred ~= nil and client.name == preferred then
        available_id = available_id or client.id
        preferred_id = preferred_id or client.id
      else
        available_id = available_id or client.id
      end

      if preferred_id ~= nil then
        break
      end
    end
  end

  local id = preferred_id or available_id
  if id == nil then
    return
  end

  vim.lsp.buf.format({
    bufnr = buf,
    async = false,
    filter = function(c)
      return c.id == id
    end,
  })
end

---@param opts? AutoFormatConfig
M.setup = function(opts)
  M.options = vim.tbl_deep_extend("force", M.defaults, opts or {})

  autocmd("BufWritePre", {
    group = augroup("AutoFormatOnSave", { clear = true }),
    desc = "Auto format on save",
    callback = function(e)
      M.format({ buf = e.buf })
    end,
  })

  command("AutoFormatToggle", function()
    M.toggle()
  end, {
    desc = "Toggle auto formatting",
    bang = true,
  })

  command("Format", function(event)
    M.format({
      force = true,
      preferred = event.fargs[1],
    })
  end, {
    desc = "Format the current buffer",
    bang = true,
    nargs = "?",
    complete = function(_, line)
      local args = vim.split(line, "%s+")
      if #args ~= 2 then
        return {}
      end

      local buf = vim.api.nvim_get_current_buf()
      local clients = vim.lsp.get_active_clients({ bufnr = buf })

      clients = vim.tbl_filter(supports_format, clients)

      local options = vim.tbl_map(function(client)
        return client.name
      end, clients)

      table.sort(options)

      return options
    end,
  })
end

--------------------------------------------------------------------------------
-- Export
--------------------------------------------------------------------------------
return M
