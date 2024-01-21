-- config.lua
-- ~~~~~~~~~~
-- Handlers for getting config
local config = {}
local function get_config_file()
	local file_path = vim.fn.findfile("sync.lua")
	if string.len(file_path) > 0 then
		config.opts = require("sync")
		config.opts.src_path = vim.fn.getcwd()
		return true
	end
	return false
end

if get_config_file() then
	return config
end
