# nvim-git-blame
This plugin opens a simple git blame in split view.<br/>
Good for getting started with lua and nvim-plugins.<br/>
Open for improvements and contributions.

### Installation with Packer
```
use 'RandomHumanoidFromEarth/nvim-git-blame'
```

### Configuration
```lua
# ~/.config/nvim/init.lua
vim.keymap.set('normal', '<C-b>', ':GitBlameToggle<CR>'
```

### Development

On NixOS
- Run `nix develop`
- Use `run-lint` and `run-test` alias

On Debian
- `sudo apt update && sudo apt install lua-check luarocks`
- `luarocks --local install luaunit`
- lint: `luacheck --config .luacheckrc .`
- test: `lua test/init.lua`

