# nvim-syncer
This plugin leverages rsync to provide automatic syncing of host and remote directories. <br>

WARNING: This software is very new and is prone to bugs, feel free to open an issue if you have found one. 
## Usage
### Dependencies
- rsync
- ssh
### Installation
Use any whatever plugin manager you would like.<br>
### Setup
Example lua configuration setup:
```lua
local syncer = require("nvim-syncer")
if syncer ~= nil then
	vim.keymap.set('n', "<leader>sd", ":SyncDown<CR>")
	vim.keymap.set('n', "<leader>su", ":SyncUp<CR>")
end
```
In the directory you are syncing, create a ```sync.lua``` file with the following template:
```lua
local sync_config = {
        -- Username on remote machine
        username = "",
        -- Address of remote machine
        remote_ip = "",
        -- Destination syncing path on the remote machine
        dest_path = "",
        -- Option to automatically sync on save.
        on_save = true
}
return sync_config
```
If a ```sync.lua``` file is found in the directory the neovim user commands ```SyncUp``` and ```SyncDown``` will be registered. Otherwise none of the functionality will be available.
