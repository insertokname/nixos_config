{ config, pkgs, ... }:
{
  users.mutableUsers = true;
  
  users.users.ferenti = {
    isNormalUser = true;
    description = "ferenti";
    extraGroups = [ "networkmanager" "wheel" "docker"];
    initialPassword="test";
    packages = with pkgs; [
    ];
  };
}
