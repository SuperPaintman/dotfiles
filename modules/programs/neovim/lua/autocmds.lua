--------------------------------------------------------------------------------
-- Init
--------------------------------------------------------------------------------
local autocmd = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup


--------------------------------------------------------------------------------
-- Auto commands
--------------------------------------------------------------------------------
autocmd("BufWritePre", {
  group = augroup("AutoFormatOnSave", { clear = true }),
  desc = "Auto format on save",
  callback = function(e)
    local clients = vim.lsp.get_active_clients({ bufnr = e.buf })

    local can_lsp_format = false
    for _, client in ipairs(clients) do
      if client.server_capabilities.documentFormattingProvider then
        can_lsp_format = true
        break
      end
    end

    if can_lsp_format then
      vim.lsp.buf.format({ bufnr = e.buf })
    end
  end,
})
