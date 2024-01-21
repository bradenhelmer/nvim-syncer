-- init.lua
-- ~~~~~~~~
-- Plugin Routing
local M = {}
local config = require('nvim-syncer.config')
local syncer = require("nvim-syncer.syncer")


-- Conditionally create commands if config present
if config ~= true then
	-- Syncer autocommands
	vim.api.nvim_create_user_command("SyncUp", function()
		syncer.sync_up(config.opts)
	end, {})

	vim.api.nvim_create_user_command("SyncDown", function()
		syncer.sync_down(config.opts)
	end, {})
	 -- Sync on save
	if config.opts.on_save then
		vim.api.nvim_create_autocmd({ "BufWritePost" }, {
			callback = function() syncer.sync_up(config.opts) end
		})
	end
end

return M
