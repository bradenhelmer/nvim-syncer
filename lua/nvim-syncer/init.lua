-- init.lua
-- ~~~~~~~~
-- Plugin Routing
local M = {}
local config = require('nvim-syncer.config')
-- If config is null, we know there is no sync.lua file, just return
if config == nil then
	return nil
end
local syncer = require("nvim-syncer.syncer")


-- Syncer autocommands
vim.api.nvim_create_user_command("SyncUp", function()
	syncer.sync_up(config.opts)
end, {})

vim.api.nvim_create_user_command("SyncDown", function()
	syncer.sync_down(config.opts)
end, {})

-- Conditionally create autocommand to sync on save.
if config.opts.on_save then
	vim.api.nvim_create_autocmd({"BufWritePost"}, {
		callback = function() syncer.sync_up(config.opts) end
	})
end

return M
