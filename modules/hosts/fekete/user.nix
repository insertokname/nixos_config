{ ... }:
{
  flake.modules.nixos.fekete = {
    users.users.fekete = {
      isNormalUser = true;
      description = "fekete";
      extraGroups = [
        "networkmanager"
        "wheel"
        "uinput" # sunshine
      ];
      initialPassword = "test";
    };
  };

  flake.modules.homeManager.fekete = {
    home = {
      username = "fekete";
      homeDirectory = "/home/fekete";
      stateVersion = "23.11";
    };
  };
}
