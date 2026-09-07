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
        ];
        config.common.default = [
          "hyprland"
          "gtk"
        ];
      };

      environment.systemPackages = with pkgs; [
        wofi
        flameshot
      ];
    };

  flake.modules.homeManager.desktop =
    { ... }:
    {
      wayland.windowManager.hyprland = {
        enable = true;
        package = null;
        portalPackage = null;

        configType = "lua";

        systemd.enable = false;

        extraConfig = builtins.readFile ./hypwrland.lua;
      };
    };
}
