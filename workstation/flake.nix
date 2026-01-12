{
  description = "NixOS configuration for Workstation";
  
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";
    
    home-manager.url = "github:nix-community/home-manager/release-25.11";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    userData.url = "github:DrSkitterbug/homelab/feat-wallpaper-storage-and-rotation?dir=workstation-data";
    
    agenix = {
      url = "github:ryantm/agenix";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        darwin.follows = "";
      };
    };
  };

  outputs = { self, nixpkgs, agenix, home-manager, userData, ... } @inputs: {
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
              userData = userData;
              agenix = agenix;
            };
          }
        ];
      };
    };
  };
}
