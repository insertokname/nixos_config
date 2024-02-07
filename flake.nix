{
  description = "OS config";

  inputs = {
    nixpgs.url = "github:NixOs/nixpkgs/nixos-23.05";
  };

  outputs = { self, nixpkgs, ...}:
  let
    lib = nixpkgs.lib;
  in{
    nixosConfigurations = {
      nixos-fekete = lib.nixosSystem{
        system = "x86_64-linux";
	modules = [ ./configuration.nix];
      };
    };
  };
}
