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
math.randomseed(os.time())

require("init-native-extensions")
require("core.options")
require("core.logger").setup({})
require("theme").setup({})

require("lazyinit")

require("core.mappings")
require("core.autocmds")
require("modules")
