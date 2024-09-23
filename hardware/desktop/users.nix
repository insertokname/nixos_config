{ config, pkgs, ... }: {
  users.users.fekete = {
    isNormalUser = true;
    description = "fekete";
    extraGroups = [ "networkmanager" "wheel" "docker" "adbusers" ];
    initialPassword = "test";
    packages = with pkgs;
      [
        #xarchiver
      ];
  };
}
