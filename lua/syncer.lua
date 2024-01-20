-- syncer.lua
-- ~~~~~~~~~~
-- Core plugin implementation.

local function get_config_file()
	local file_path = vim.fn.findfile("sync.lua")
	if file_path.len > 0 then
		return require(file_path)
	end
	return nil
end

local function test()
	local config = get_config_file()
	if not config == nil then
		print(config.message)
	end
end
