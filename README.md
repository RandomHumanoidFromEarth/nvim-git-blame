# nvim-git-blame
This plugin opens a simple git blame view in split view.<br/>
Good for getting started with lua and nvim-plugins.<br/>
Open for improvements and contributions.

### Installation with Packer
Under construction. For now do git checkout in packer directory `~/.local/share/nvim/site/pack/packer/start`.

### Configuration
```lua
# ~/.config/nvim/init.lua
vim.keymap.set('normal', '<C-b>', ':GitBlameToggle<CR>'
```

### Development

On NixOS
- Run `nix develop`
- Use `lint` and `test` alias

On Debian
- `sudo apt update && sudo apt install lua-check luarocks`
- `luarocks --local install luaunit`
- lint: `luacheck --config .luacheckrc .`
- test: `lua test/init.lua`

# TODO
- testing: write a good mock for vim.api
- check buffer is written before "git blame filename"

