{ config, pkgs, ... }:
{
  users.users.fekete= {
    isNormalUser = true;
    description = "fekete";
    extraGroups = [ "networkmanager" "wheel" "docker"];
    initialPassword="test";
    packages = with pkgs; [
      #xarchiver
    ];
  };
}
