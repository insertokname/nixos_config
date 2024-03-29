{ config, pkgs, ... }:
{
  users.mutableUsers = true;
  
  users.users.ferenti = {
    isNormalUser = true;
    description = "ferenti";
    extraGroups = [ "networkmanager" "wheel" ];
    initialPassword="test";
    packages = with pkgs; [
      firefox
    #  thunderbird
    ];
  };
}