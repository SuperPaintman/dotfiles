--------------------------------------------------------------------------------
-- Init
--------------------------------------------------------------------------------
local M = {}

--------------------------------------------------------------------------------
-- Helpers
--------------------------------------------------------------------------------
local function border(hl_name)
  return {
    { "╭", hl_name },
    { "─", hl_name },
    { "╮", hl_name },
    { "│", hl_name },
    { "╯", hl_name },
    { "─", hl_name },
    { "╰", hl_name },
    { "│", hl_name },
  }
end

local icons = {
  Namespace = "󰌗",
  Text = "󰉿",
  Method = "󰆧",
  Function = "󰆧",
  Constructor = "",
  Field = "󰜢",
  Variable = "󰀫",
  Class = "󰠱",
  Interface = "",
  Module = "",
  Property = "󰜢",
  Unit = "󰑭",
  Value = "󰎠",
  Enum = "",
  Keyword = "󰌋",
  Snippet = "",
  Color = "󰏘",
  File = "󰈚",
  Reference = "󰈇",
  Folder = "󰉋",
  EnumMember = "",
  Constant = "󰏿",
  Struct = "󰙅",
  Event = "",
  Operator = "󰆕",
  TypeParameter = "󰊄",
  Table = "",
  Object = "󰅩",
  Tag = "",
  Array = "",
  Boolean = "",
  Number = "",
  Null = "󰟢",
  String = "󰉿",
  Calendar = "",
  Watch = "󰥔",
  Package = "",
  Copilot = "",
  Codeium = "",
  TabNine = "",
}

--------------------------------------------------------------------------------
-- Modules
--------------------------------------------------------------------------------
M.config = function()
  local cmp = require("cmp")

  cmp.setup({
    snippet = {
      expand = function(args)
        require("luasnip").lsp_expand(args.body)
      end,
    },
    window = {
      documentation = cmp.config.window.bordered({
        border = border("CmpDocBorder"),
      }),
    },
    mapping = {
      ["<C-n>"] = {
        i = function()
          if cmp.visible() then
            cmp.select_next_item({ behavior = cmp.SelectBehavior.Insert })
          else
            cmp.complete()
          end
        end,
      },
      ["<C-p>"] = {
        i = function()
          if cmp.visible() then
            cmp.select_prev_item({ behavior = cmp.SelectBehavior.Insert })
          else
            cmp.complete()
          end
        end,
      },
      ["<CR>"] = cmp.mapping.confirm({
        behavior = cmp.ConfirmBehavior.Insert,
        select = true,
      }),
    },
    formatting = {
      fields = { "kind", "abbr", "menu" },
      format = function(_, item)
        local icon = icons[item.kind]
        if icon ~= nil then
          item.kind = " " .. icon .. " "
        end

        return item
      end,
    },
    sources = cmp.config.sources({
      { name = "nvim_lua" },
      { name = "nvim_lsp" },
      { name = "buffer" },
      { name = "path" },
      { name = "luasnip" },
    }),
  })
end

--------------------------------------------------------------------------------
-- Export
--------------------------------------------------------------------------------
return M
