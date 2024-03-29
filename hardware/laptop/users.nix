{ config, pkgs, ... }:
{
  users.mutableUsers = true;
  
  users.users.test= {
    isNormalUser = true;
    description = "test";
    extraGroups = [ "networkmanager" "wheel" ];
    initialPassword = "test";
  };

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