{
  description = "OS config";

  inputs = {
    nixpgs.url = "github:NixOs/nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs, ...}:
  let
    lib = nixpkgs.lib;
    hardware_path = (./hardware + "/${
      let dev = builtins.readFile ./cur_hardware; 
      in 
        if dev=="" then throw "'cur_hardware'has been set" 
        else dev
      }/load_hardware.nix");
  in{
    nixosConfigurations = {
      fekete = lib.nixosSystem{
        system = "x86_64-linux";
      	modules = [ 
	        ./configurations/fekete/configuration.nix
          ./configurations/fekete/custom_pkgs.nix
          hardware_path
        ];
      };
    };
  };
}
