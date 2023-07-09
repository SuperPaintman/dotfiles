--------------------------------------------------------------------------------
-- Init
--------------------------------------------------------------------------------
local opt = vim.opt
local cmd = vim.cmd
local env = vim.env

--------------------------------------------------------------------------------
-- Reset default options
--------------------------------------------------------------------------------
-- Save old values.
local old_columns = opt.columns
local old_lines = opt.lines
local old_syntax = opt.syntax

-- Set all options to their default value.
cmd([[set all&]])

-- Reset color scheme.
cmd([[colorscheme default]])

--------------------------------------------------------------------------------
-- Options
--------------------------------------------------------------------------------
cmd([[syntax on]])

cmd([[filetype plugin indent on]])

-- When a file has been detecte.d to have been changed outside of Vim and it
-- has not been changed inside of Vim, automatically read it again.
opt.autoread = true

-- When set to "dark" or "light", adjusts the default color groups for that
-- background type.
opt.background = "dark"

-- Influences the working of <BS>, <Del>, CTRL-W and CTRL-U in Insert mode.
opt.backspace = { "indent", "eol", "start" }

-- Make a backup before overwriting a file.
opt.backup = false

-- Columns to highlight.
opt.colorcolumn = { 80, 120 }

-- Set default number of columns of the screen.
opt.columns = old_columns

-- Highlight the screen line of the cursor.
opt.cursorline = true

-- Encoding used internally.
opt.encoding = "utf-8"

-- When on, all the windows are automatically made the same size after
-- splitting or closing a window.
opt.equalalways = false

-- In Insert mode: Use the appropriate number of spaces to insert a <Tab>.
opt.expandtab = true

-- Characters to fill the statuslines, vertical separators and special lines in
-- the window.
opt.fillchars = { eob = "~" }

-- When off, all folds are open.
--
-- This option can be used to quickly switch between showing all text unfolded
-- and viewing the text with folds (including manually opened or closed folds).
opt.foldenable = false

-- A history of ":" commands, and a history of previous search patterns is
-- remembered.
opt.history = 10000

-- When there is a previous search pattern, highlight all its matches.
opt.hlsearch = true

-- Ignore case in search patterns.
opt.ignorecase = true

-- The value of this option influences when the last window will have a status
-- line.
opt.laststatus = 2 -- always

-- Set default number of lines of the window.
opt.lines = old_lines

-- Show <Tab> and <EOL>.
opt.list = true

-- Strings to use in 'list' mode and for the :list command.
opt.listchars = {
  eol = "¬",
  tab = ">-",
  space = "·",
  trail = "·",
  extends = ">",
  precedes = "<",
}

-- Enables mouse support.
opt.mouse = "a" -- all modes

-- Print the line number in front of each line.
opt.number = true

-- Minimal number of screen lines to keep above and below the cursor.
opt.scrolloff = 10

-- Number of spaces to use for each step of (auto)indent.
opt.shiftwidth = 2

-- If in Insert, Replace or Visual mode put a message on the last line.
opt.showmode = false

-- The value of this option specifies when the line with tab page labels will
-- be displayed.
opt.showtabline = 2 -- always

-- When and how to draw the signcolumn.
opt.signcolumn = "yes" -- always

-- Override the 'ignorecase' option if the search pattern contains upper case
-- characters.
opt.smartcase = true

-- When on, a <Tab> in front of a line inserts blanks according to
-- 'shiftwidth'.
opt.smarttab = true

-- Number of spaces that a <Tab> counts for while performing editing
-- operations, like inserting a <Tab> or using <BS>.
opt.softtabstop = 2

-- When on, splitting a window will put the new window below the current one.
opt.splitbelow = true

-- When on, splitting a window will put the new window right of the current
-- one.
opt.splitright = true

-- Enables 24-bit RGB color in the TUI.
if
  (env.TERM or ""):sub(-1 * string.len("-256color")) == "-256color"
  or env.COLORTERM == "truecolor"
then
  opt.termguicolors = true
end

-- Use a swapfile for the buffer.
opt.swapfile = false

-- When this option is set, the syntax with this name is loaded, unless syntax
-- highlighting has been switched off with ":syntax off".
opt.syntax = old_syntax

-- If this many milliseconds nothing is typed the swap file will be written to
-- disk.
--
-- Also used for the CursorHold autocommand event.
opt.updatetime = 1000

-- This option changes how text is displayed.
opt.wrap = false

-- Make a backup before overwriting a file.
opt.writebackup = false
