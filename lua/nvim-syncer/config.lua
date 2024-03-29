-- config.lua
-- ~~~~~~~~~~
-- Handlers for getting config
local config = {}
local function get_config_file()
	local src_path = vim.fn.getcwd()
	local file_path = vim.fn.findfile(src_path .. '/' .. "sync.lua")
	if string.len(file_path) > 0 then
		config.opts = require("sync")
		config.opts.src_path = src_path
		return config
	end
	return false
end

return get_config_file()
