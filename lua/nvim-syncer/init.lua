-- init.lua
-- ~~~~~~~~
-- Plugin Routing
local M = {}
local config = require('nvim-syncer.config')
local syncer = require("nvim-syncer.syncer")

-- Syncer autocommands
vim.api.nvim_create_user_command("SyncUp", function()
	if not config then
		syncer.notify_error("No sync.lua file found in current working directory!")
	else
		syncer.sync_up(config.opts)
	end
end, {})

vim.api.nvim_create_user_command("SyncDown", function()
	if not config then
		syncer.notify_error("No sync.lua file found in current working directory!")
	else
		syncer.sync_down(config.opts)
	end
end, {})

-- Sync on save
if config and config.opts.on_save then
	vim.api.nvim_create_autocmd({ "BufWritePost" }, {
		callback = function() syncer.sync_up(config.opts) end
	})
end

return M
