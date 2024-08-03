{ config, pkgs, ... }: {
  users.mutableUsers = true;

  users.users.test = {
    isNormalUser = true;
    description = "test";
    extraGroups = [ "networkmanager" "wheel" ];
    initialPassword = "test";
  };
}
