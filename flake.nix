{
  description = "OS config";

  inputs = {
    newest_nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    grub2-themes = { url = "github:vinceliuice/grub2-themes"; };
  };

  outputs = { self, nixpkgs, home-manager, grub2-themes, newest_nixpkgs, ... }@inputs:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
      newest_pkgs = import newest_nixpkgs { system = system; config.allowUnfree = true; };
    in {
      nixosConfigurations = {
        fekete = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = { inherit inputs system newest_pkgs; };
          modules = [
            ./configurations/common/configuration.nix
            # ./configurations/common/custom_pkgs.nix
            ./hardware/desktop/load_hardware.nix
            ./home-manager/fekete/load_home.nix
            grub2-themes.nixosModules.default
          ];
        };

        ferenti = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = { inherit inputs system newest_pkgs; };
          modules = [
            ./configurations/common/configuration.nix
            # ./configurations/common/custom_pkgs.nix
            ./hardware/laptop/load_hardware.nix
            ./home-manager/ferenti/load_home.nix
            grub2-themes.nixosModules.default
          ];
        };
      };

      homeConfigurations."ferenti" = home-manager.lib.homeManagerConfiguration {
        pkgs = pkgs;
        modules = [ ./home-manager/ferenti/home.nix ];
      };

      homeConfigurations."fekete" = home-manager.lib.homeManagerConfiguration {
        pkgs = pkgs;
        modules = [ ./home-manager/fekete/home.nix ];
      };
    };
}
