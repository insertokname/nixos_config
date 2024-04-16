{ config, pkgs, ... }:
{
  users.users.fekete= {
    isNormalUser = true;
    description = "fekete";
    extraGroups = [ "networkmanager" "wheel" ];
    initialPassword="test";
    packages = with pkgs; [
      #xarchiver
    ];
  };
}