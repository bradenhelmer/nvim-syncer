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
        -- Address of remote machine.
        remote_ip = "",
        -- Username on remote machine, required if remote_ip specified.
        username = "",
        -- Destination syncing path, better if absolute path.
        dest_path = "",
        -- Option to automatically sync on save. Required
        on_save = true
        -- List of files to be excluded. sync.lua is excluded by default!
        excludes = {}
        -- List of files to read excludes from e.g .gitgnore.
        exclude_files = {}
}
return sync_config
```
If ```sync.lua``` is edited, neovim must be reloaded.
