-- syncer.lua
-- ~~~~~~~~~~
-- Core plugin implementation.
local syncer = {}

-- Ensures options are valid.
local function validate_opts(opts)
	return opts.username and opts.remote_ip and opts.dest_path and opts.src_path
end

-- TODO: Implement function to construct an exclusion string for the command
local function construct_excludes(excludes)
end

-- Creates ssh syncing address in form <username>@<remote_ip>:<dest_path>
local function create_ssh_address(opts)
	return opts.username .. "@" .. opts.remote_ip .. ":" .. opts.dest_path
end

-- Invokes sync job
local function do_sync(command, opts, is_up)
	local job = vim.fn.jobstart(command, {
		cwd = opts.src_path
	})

	local direction = is_up and "up" or "down"
	vim.api.nvim_out_write("Syncing " .. direction .. "...\n")

	if job == 0 or job == -1 then
		vim.api.nvim_err_writeln("Error while syncing " .. direction .. "!" )
	end
end

-- Syncing upwards (host -> remote)
function syncer.sync_up(opts)
	if not validate_opts then
		vim.api.nvim_err_writeln("sync.lua file is missing required keys! (username, remote_ip, dest_path)")
		return false
	end

	local command = "rsync -varz "
	if opts.excludes then
		command = command .. construct_excludes(opts.excludes)
	end
	command = command .. " -f'- sync.lua' " .. opts.src_path .. "/ " .. create_ssh_address(opts)
	do_sync(command, opts, true)
end

-- Syncing upwards (remote -> host)
function syncer.sync_down(opts)
	if not validate_opts then
		vim.api.nvim_err_writeln("sync.lua file is missing required keys! (username, remote_ip, dest_path)")
		return false
	end

	local command = "rsync -varz "
	if opts.excludes then
		command = command .. construct_excludes(opts.excludes)
	end
	command = command .. " -f'- sync.lua' " .. create_ssh_address(opts) .. " " .. opts.src_path
	do_sync(command, opts, false)
end

return syncer
