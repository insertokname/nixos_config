{
  description = "OS config";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, ...}:
  let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
  in
  {
    nixosConfigurations = {
      fekete = nixpkgs.lib.nixosSystem{
        system = "x86_64-linux";
      	modules = [ 
	        ./configurations/fekete/configuration.nix
          ./configurations/fekete/custom_pkgs.nix
          ./hardware/desktop/load_hardware.nix
        ];
      };

      ferenti = nixpkgs.lib.nixosSystem{
        system = "x86_64-linux";
      	modules = [ 
	        ./configurations/fekete/configuration.nix
          ./configurations/fekete/custom_pkgs.nix
          ./hardware/laptop/load_hardware.nix
        ];
      };
    };

    homeConfigurations."ferenti" = home-manager.lib.homeManagerConfiguration {
      pkgs = pkgs;
      # extraSpecialArgs = {...};
      modules = [
        ./home-manager/ferenti/home.nix
      ];
    };
  };
}
