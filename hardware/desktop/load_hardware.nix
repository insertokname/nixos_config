{ config, pkgs, ... }:
{
  imports = [
    ./boot.nix
    ./hardware-configuration.nix
    ./nvidia_drivers.nix
    ./users.nix
  ];
}
