{ config, pkgs, ... }: {
  imports = [
    ./boot.nix
    ./hardware-configuration.nix
    ./users.nix
    ./amd_drivers.nix
    ./scrolling.nix
    ./power_saving.nix
  ];
}
