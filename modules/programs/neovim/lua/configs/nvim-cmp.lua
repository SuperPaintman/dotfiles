--------------------------------------------------------------------------------
-- Imports
--------------------------------------------------------------------------------
local ui = require("core.ui")

--------------------------------------------------------------------------------
-- Init
--------------------------------------------------------------------------------
local M = {}

--------------------------------------------------------------------------------
-- Helpers
--------------------------------------------------------------------------------
---Check if TreeSitter is active in this buffer.
---@return boolean
local function has_treesitter()
  if vim.treesitter == nil then
    return false
  end

  return vim.treesitter.highlighter.active[vim.api.nvim_get_current_buf()]
      ~= nil
end

---Check if cursor is in syntax group
---@param group string | []string
---@return boolean
local function in_syntax_group(group)
  local row, col = unpack(vim.api.nvim_win_get_cursor(0))
  if not require("cmp.utils.api").is_insert_mode() then
    col = col + 1
  end

  for _, syn_id in ipairs(vim.fn.synstack(row, col)) do
    syn_id = vim.fn.synIDtrans(syn_id) -- Resolve :highlight links
    local g = vim.fn.synIDattr(syn_id, "name")
    if type(group) == "string" and g == group then
      return true
    end
    if type(group) == "table" and vim.tbl_contains(group, g) then
      return true
    end
  end

  return false
end

---Check if cursor is in treesitter capture
---@param capture string | []string
---@return boolean
local function in_treesitter_capture(capture)
  -- Check if treesitter is available.
  if vim.treesitter == nil or vim.treesitter.get_captures_at_pos == nil then
    return false
  end

  local buf = vim.api.nvim_get_current_buf()
  local row, col = unpack(vim.api.nvim_win_get_cursor(0))
  row = row - 1
  if vim.api.nvim_get_mode().mode == "i" then
    col = col - 1
  end

  local get_captures_at_pos = vim.treesitter.get_captures_at_pos

  local captures_at_cursor = vim.tbl_map(function(x)
    return x.capture
  end, get_captures_at_pos(buf, row, col))

  if vim.tbl_isempty(captures_at_cursor) then
    return false
  end

  if
      type(capture) == "string" and vim.tbl_contains(captures_at_cursor, capture)
  then
    return true
  end

  if type(capture) == "table" then
    for _, v in ipairs(capture) do
      if vim.tbl_contains(captures_at_cursor, v) then
        return true
      end
    end
  end

  return false
end

local function is_in_comment(ctx)
  return ctx.cache:ensure("meta:is_in_comment", function()
    if has_treesitter() then
      return in_treesitter_capture("comment")
    else
      return in_syntax_group("Comment")
    end
  end)
end

local function get_reason(ctx)
  if ctx.option.reason then
    return ctx.option.reason
  end

  if ctx.prev_context then
    return ctx.prev_context.option.reason
  end

  return nil
end

--------------------------------------------------------------------------------
-- Modules
--------------------------------------------------------------------------------
M.dependencies = {
  "hrsh7th/cmp-nvim-lua",
  "hrsh7th/cmp-nvim-lsp",
  "hrsh7th/cmp-buffer",
  "hrsh7th/cmp-path",
  "saadparwaiz1/cmp_luasnip",
  "L3MON4D3/LuaSnip",
}

M.event = "InsertEnter"

M.config = function()
  local cmp = require("cmp")
  local kinds = require("cmp.types.lsp").CompletionItemKind

  cmp.setup({
    -- enabled = function()
    --   -- Disable completion if the cursor in a comment.
    --   if has_treesitter() then
    --     if in_treesitter_capture("comment") then
    --       return false
    --     end
    --   else
    --     if in_syntax_group("Comment") then
    --       return false
    --     end
    --   end
    --
    --   return true
    -- end,
    snippet = {
      expand = function(args)
        require("luasnip").lsp_expand(args.body)
      end,
    },
    window = {
      completion = cmp.config.window.bordered({
        border = ui.borders.thick(),
        winhighlight = table.concat({
          "Normal:Pmenu",
          "FloatBorder:Pmenu",
          "CursorLine:PmenuSel",
          "Search:None",
        }, ","),
      }),

      documentation = cmp.config.window.bordered({
        border = ui.borders.thick("CmpDocBorder"),
        winhighlight = table.concat({
          "Normal:CmpDocNormal",
          "FloatBorder:CmpDocBorder",
          "CursorLine:Visual",
          "Search:None",
        }, ","),
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
        local icon = ui.icons.cmp[item.kind]
        if icon ~= nil then
          item.kind = " " .. icon .. " "
        end

        return item
      end,
    },
    sources = cmp.config.sources({
      {
        name = "nvim_lua",
        entry_filter = function(_entry, ctx)
          -- Disable auto completion if the cursor in a comment.
          if is_in_comment(ctx) and get_reason(ctx) ~= "manual" then
            return false
          end

          return true
        end,
      },
      {
        name = "nvim_lsp",
        entry_filter = function(entry, ctx)
          -- Disable auto completion if the cursor in a comment.
          if is_in_comment(ctx) and get_reason(ctx) ~= "manual" then
            return false
          end

          local kind = kinds[entry:get_kind()]

          -- Filter keywords.
          if kind == "Keyword" then
            return false
          end

          return true
        end,
      },
      {
        name = "buffer",
        keyword_length = 3,
        entry_filter = function(_entry, ctx)
          -- Disable auto completion if the cursor in a comment.
          if is_in_comment(ctx) and get_reason(ctx) ~= "manual" then
            return false
          end

          return true
        end,
      },
      {
        name = "path",
        keyword_length = 2,
        entry_filter = function(_entry, ctx)
          -- Disable auto completion if the cursor in a comment.
          if is_in_comment(ctx) and get_reason(ctx) ~= "manual" then
            return false
          end

          return true
        end,
      },
      {
        name = "luasnip",
        -- entry_filter = function(entry, ctx)
        --   if is_in_comment(ctx) then
        --     -- Disable auto completion if the cursor in a comment.
        --     if get_reason(ctx) == "manual" then
        --       return true
        --     end
        --
        --     -- Allow TODO-like macros.
        --     local word = entry:get_word()
        --     if word == "TODO" or word == "NOTE" or word == "FIX" then
        --       return true
        --     end
        --
        --     return false
        --   end
        --
        --   return true
        -- end,
      },
    }),
  })
end

M.reload = function()
  local unload = require("utils.modules").unload
  unload("core.ui")
  M.config()
end

--------------------------------------------------------------------------------
-- Export
--------------------------------------------------------------------------------
return M
