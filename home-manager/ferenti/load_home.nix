{ inputs, pkgs, newest_pkgs, ... }: {
  imports = [ inputs.home-manager.nixosModules.home-manager ];

  home-manager = {
    extraSpecialArgs = { inherit inputs newest_pkgs; };
    users = { ferenti = import ./home.nix; };
  };
}
