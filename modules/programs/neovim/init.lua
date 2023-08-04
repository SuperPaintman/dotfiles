--------------------------------------------------------------------------------
-- Imports
--------------------------------------------------------------------------------
local unload = require("utils.modules").unload

--------------------------------------------------------------------------------
-- Unload
--------------------------------------------------------------------------------
unload("^core%.", true)
unload("^configs%.", true)
unload("^modules%.", true)
unload("^snippets%.", true)
unload("^theme%.", true)
unload("^utils%.", true)

--------------------------------------------------------------------------------
-- Init
--------------------------------------------------------------------------------
require("core.options")
require("theme").setup({})
require("modules")
require("core.mappings")
require("core.autocmds")

require("lazyinit")
