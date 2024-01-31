-- syncer.lua
-- ~~~~~~~~~~
-- Core plugin implementation.
local syncer = {}

function syncer.notify_error(message)
	vim.notify(message, vim.log.levels.ERROR)
	return false
end

-- Ensures options are valid.
local function validate_opts(opts)
	if not opts.dest_path then
		return syncer.notify_error("No dest_path specdifed!")
	end
	if opts.remote_ip then
		if not opts.username then
			return syncer.notify_error("A remote ip was specified, however a username was not provided.")
		end
	end
	return true
end

local function construct_excludes(opts)
	local initial = ""
	-- Files to be excluded
	if opts.excludes then
		initial = "--exclude={"
		for idx, exclude in ipairs(opts.excludes) do
			initial = initial .. '\'' .. exclude .. '\','
		end
		initial = initial .. '} '
	end
	-- Exclusion files
	if opts.exclude_files then
		initial = initial .. "--exclude-from={"
		for idx, exclude_file in ipairs(opts.exclude_files) do
			initial = initial .. '\'' .. exclude_file .. '\','
		end
		initial = initial .. '} '
	end
	return initial
end

-- Creates ssh syncing address in form <username>@<remote_ip>:<dest_path>
local function create_destination(opts)
	if opts.remote_ip then
		return opts.username .. "@" .. opts.remote_ip .. ":" .. opts.dest_path
	else
		return opts.dest_path
	end
end

-- Invokes sync job
local function do_sync(command, opts, is_up)
	local job = vim.fn.jobstart(command, {
		cwd = opts.src_path,
		on_stderr = function(_, msg)
			syncer.notify_error(table.concat(msg, '\n'))
		end,
		stderr_buffered = true
	})

	local direction = is_up and "up" or "down"
	vim.notify("Syncing " .. direction .. "...", vim.log.levels.INFO)

	if job == 0 or job == -1 then
		syncer.notify_error("Error while syncing " .. direction .. "!")
	end
end

-- Syncing upwards (host -> remote)
function syncer.sync_up(opts)
	if not validate_opts then
		return syncer.notify_error("Error with configuration options!")
	end

	local command = "rsync -varz "
	if opts.excludes or opts.exclude_files then
		command = command .. construct_excludes(opts)
	end
	command = command .. " -f'- sync.lua' " .. opts.src_path .. "/ " .. create_destination(opts)
	do_sync(command, opts, true)
end

-- Syncing upwards (remote -> host)
function syncer.sync_down(opts)
	if not validate_opts then
		return syncer.notify_error("sync.lua file is missing dest_path value!")
	end

	local command = "rsync -varz "
	if opts.excludes or opts.exclude_files then
		command = command .. construct_excludes(opts.excludes)
	end
	command = command .. " -f'- sync.lua' " .. create_destination(opts) .. " " .. opts.src_path
	do_sync(command, opts, false)
end

return syncer
