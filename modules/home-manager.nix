{ inputs, ... }: {
  flake.modules.nixos.home-manager = {
    imports = [
      inputs.home-manager.nixosModules.home-manager
    ];
    home-manager = {
      useGlobalPkgs = true;
      useUserPackages = true;
    };
  };

  # this is a flake parts import
  imports = [
    inputs.home-manager.flakeModules.home-manager
  ];
}
