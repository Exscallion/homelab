{
  description = "NixOS configuration for Workstation";
  
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";
    home-manager.url = "github:nix-community/home-manager/release-25.11";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    
    homelab.url = "github:DrSkitterbug/homelab?dir=workstation";
  };

  outputs = { self, nixpkgs, home-manager, homelab, ... } @inputs: {
    nixosConfigurations = {
      palica = nixpkgs.lib.nixosSystem {
        modules = [
          ./configuration.nix
          home-manager.nixosModules.home-manager 
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.zeta = import ./home.nix {
              pkgs = nixpkgs.legacyPackages."x86_64-linux";
              homelab = homelab;
            };
          }
        ];
      };
    };
  };
}
