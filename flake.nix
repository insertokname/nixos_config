{
  description = "OS config";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, ... }@inputs:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in {
      nixosConfigurations = {
        fekete = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = { inherit inputs system; };
          modules = [
            ./configurations/common/configuration.nix
            ./configurations/common/custom_pkgs.nix
            ./hardware/desktop/load_hardware.nix
            ./home-manager/fekete/load_home.nix
          ];
        };

        ferenti = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = { inherit inputs system; };
          modules = [
            ./configurations/common/configuration.nix
            ./configurations/common/custom_pkgs.nix
            ./hardware/laptop/load_hardware.nix
            ./home-manager/fekete/load_home.nix
          ];
        };
      };

      homeConfigurations."ferenti" = home-manager.lib.homeManagerConfiguration {
        pkgs = pkgs;
        # extraSpecialArgs = {...};
        modules = [ ./home-manager/ferenti/home.nix ];
      };

      homeConfigurations."fekete" = home-manager.lib.homeManagerConfiguration {
        pkgs = pkgs;
        # extraSpecialArgs = {...};
        modules = [ ./home-manager/fekete/home.nix ];
      };
    };
}
