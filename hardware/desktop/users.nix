{ config, pkgs, ... }:
{
    users.users.fekete= {
    isNormalUser = true;
    description = "fekete";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [
      #xarchiver
    ];
  };
}