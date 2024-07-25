{
  description = "nvim-git-blame development shell";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
  };

  outputs = { self, nixpkgs }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in with pkgs; {
      devShells.${system}.default = mkShell {
          buildInputs = with pkgs; [
            lua
            luaPackages.luaunit
            luaPackages.luacheck
            neovim
        ];
        shellHook = ''
            alias vim=nvim
            alias was="git status --short"
            alias lint="luacheck --config .luacheckrc ."
            alias test="lua tests/init.lua -v"
            export PS1="֍ \u:dev-shell → "
          '';
      };
    };
}
