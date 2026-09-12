{ inputs, ... }: {
  flake.modules.nixos.desktop =
    { pkgs, ... }:
    {
      programs.hyprland = {
        package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
        portalPackage =
          inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland;
        enable = true;
        withUWSM = true;
        xwayland.enable = true;
      };

      xdg.sounds.enable = false;
      xdg.portal = {
        enable = true;
        extraPortals = [
          pkgs.xdg-desktop-portal-gtk
          inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland
        ];
        config.common.default = [
          "hyprland"
          "gtk"
        ];
      };

      environment.systemPackages = with pkgs; [
        wofi
        grim
        slurp
      ];
    };

  flake.modules.homeManager.desktop =
    { ... }:
    {
      systemd.user.startServices = "sd-switch";

      wayland.windowManager.hyprland = {
        enable = true;
        package = null;
        portalPackage = null;

        configType = "lua";

        systemd.enable = false;

        extraConfig = builtins.readFile ./hypwrland.lua;
      };

      services.flameshot = {
        enable = true;
        settings.General = {
          showDesktopNotification = false;
          showAbortNotification = false;
          showStartupLaunchMessage = false;
        };
      };

      services.mako = {
        enable = true;
        settings = {
          default-timeout = 5000;
        };
      };
    };
}
