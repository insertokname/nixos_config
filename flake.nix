{
  description = "OS config";

  inputs = {
    nixpgs.url = "github:NixOs/nixpkgs/nixos-23.05";
  };

  outputs = { self, nixpkgs, ...}:
  let
    lib = nixpkgs.lib;
    hardware_path = (./hardware + "/${
      let dev = (import ./cur_device.nix); 
      in 
        if dev.device=="" then throw "'device' attribute has been set to an empty string or doesn't exist " 
        else dev.device
      }/load_hardware.nix");
  in{
    nixosConfigurations = {
      fekete = lib.nixosSystem{
        system = "x86_64-linux";
      	modules = [ 
	        ./configurations/fekete/configuration.nix
          hardware_path
        ];
      };
    };
  };
}
