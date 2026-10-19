{ ... }:
{
  # autologin into the hyprland-uwsm session from sddm so basically desktop is required
  moduleDependencies.fekete = [ "desktop" ];

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
