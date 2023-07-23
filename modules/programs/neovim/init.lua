--------------------------------------------------------------------------------
-- Imports
--------------------------------------------------------------------------------
local unload = require("utils.modules").unload

--------------------------------------------------------------------------------
-- Unload
--------------------------------------------------------------------------------
unload("^configs%.", true)
unload("^modules%.", true)
unload("^snippets%.", true)
unload("^theme%.", true)
unload("^utils%.", true)
unload("options")
unload("mappings")
unload("autocmds")

--------------------------------------------------------------------------------
-- Init
--------------------------------------------------------------------------------
require("options")
require("theme").setup({})
require("modules")
require("mappings")
require("autocmds")

require("lazyinit")
