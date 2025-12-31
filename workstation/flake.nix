{
  description = "NixOS configuration for wWorkstation";
  
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs, ... }:
    let
      system = "x86-64-linux";
    in {
      nixosConfigurations.palica = nixpkgs.lib.nixosSystem {
        inherit system;
        modules = [
          ./configuration.nix
        ];
      };
    };
}
