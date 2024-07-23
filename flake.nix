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
            gnumake
            lua
            luaPackages.luaunit
            luaPackages.luacheck
        ];
      };
    };
}
