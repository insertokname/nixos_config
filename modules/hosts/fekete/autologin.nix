{ ... }:
{
  flake.modules.nixos.fekete = { pkgs, ... }: {
    services.displayManager.autoLogin = {
      enable = true;
      user = "fekete";
    };

    services.displayManager.defaultSession = "hyprland-uwsm";

    networking.interfaces.enp4s0.wakeOnLan.enable = true;

    environment.systemPackages = with pkgs; [
      ethtool
    ];
  };
}
