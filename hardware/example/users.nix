{ config, pkgs, ... }:
{
  users.users.test= {
    isNormalUser = true;
    description = "test";
    extraGroups = [ "networkmanager" "wheel" ];
    password = "test";
  };
}