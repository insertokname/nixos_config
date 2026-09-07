{ inputs, ... }: {
  flake.modules.nixos.flatpak = { pkgs, ... }: {
    services.flatpak.enable = true;

    environment.systemPackages = with pkgs; [
      flatpak
    ];
  };

  flake.modules.homeManager.flatpak = { ... }: {
    imports = [
      inputs.nix-flatpak.homeManagerModules.nix-flatpak
    ];

    services.flatpak = {
      enable = true;

      update.auto = {
        enable = true;
        onCalendar = "weekly";
      };

      packages = [
        "org.vinegarhq.Sober"
      ];
    };

    home.sessionVariables = {
      XDG_DATA_DIRS = "$XDG_DATA_DIRS:$HOME/.local/share/flatpak/exports/share:/var/lib/flatpak/exports/share";
    };
  };
}
